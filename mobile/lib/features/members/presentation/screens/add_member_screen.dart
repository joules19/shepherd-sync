import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:intl_phone_field/phone_number.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../core/widgets/custom_dropdown.dart';
import '../../../../core/widgets/custom_phone_field.dart';
import '../../../../core/widgets/custom_text_field.dart';
import '../../../../core/widgets/profile_picture_picker.dart';
import '../../data/models/member_model.dart';
import '../../data/providers/members_providers.dart';

/// Simplified add member screen for admins (invite-first approach)
/// Only collects minimal data needed to send invite
class AddMemberScreen extends ConsumerStatefulWidget {
  const AddMemberScreen({super.key});

  @override
  ConsumerState<AddMemberScreen> createState() => _AddMemberScreenState();
}

class _AddMemberScreenState extends ConsumerState<AddMemberScreen> {
  final _formKey = GlobalKey<FormState>();

  // Form controllers
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _dobController = TextEditingController();

  // Form state
  File? _profileImage;
  String? _profileImageUrl;
  String? _phoneCountryCode;
  String? _phoneNumber;
  String? _selectedGender;
  DateTime? _selectedDob;
  bool _isLoading = false;

  /// Convert dial code (e.g., "+44", "+1") to ISO country code (e.g., "GB", "US")
  String _getCountryCodeFromDialCode(String? dialCode) {
    if (dialCode == null || dialCode.isEmpty) return 'US';

    // Remove + and any extra characters
    final cleanCode = dialCode.replaceAll('+', '').trim();

    // Map common dial codes to ISO country codes
    const dialToIso = {
      '1': 'US',      // USA/Canada
      '44': 'GB',     // UK
      '234': 'NG',    // Nigeria
      '91': 'IN',     // India
      '61': 'AU',     // Australia
      '86': 'CN',     // China
      '81': 'JP',     // Japan
      '82': 'KR',     // South Korea
      '33': 'FR',     // France
      '49': 'DE',     // Germany
      '39': 'IT',     // Italy
      '34': 'ES',     // Spain
      '7': 'RU',      // Russia
      '55': 'BR',     // Brazil
      '52': 'MX',     // Mexico
      '27': 'ZA',     // South Africa
      '20': 'EG',     // Egypt
      '254': 'KE',    // Kenya
      '233': 'GH',    // Ghana
      '256': 'UG',    // Uganda
    };

    return dialToIso[cleanCode] ?? 'US';
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _dobController.dispose();
    super.dispose();
  }

  Future<void> _selectDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now().subtract(const Duration(days: 365 * 18)),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: AppColors.primary,
              onPrimary: Colors.white,
              surface: Colors.white,
              onSurface: Colors.black,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      setState(() {
        _selectedDob = picked;
        _dobController.text = DateFormat('MMM d, y').format(picked);
      });
    }
  }

  void _showInviteMethodSheet(MemberModel member) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        child: SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Draggable handle
              Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: AppConstants.spacingMD,
                ),
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),

              // Title
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppConstants.spacingLG,
                ),
                child: Column(
                  children: [
                    Text(
                      'Send Invite',
                      style: AppTextStyles.headlineSmall.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: AppConstants.spacingSM),
                    Text(
                      'Choose how to send the invite to ${member.firstName}',
                      textAlign: TextAlign.center,
                      style: AppTextStyles.bodyMedium.copyWith(
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppConstants.spacingLG),

              // Options
              if (member.phone != null)
                _buildInviteOption(
                  icon: Icons.sms_rounded,
                  label: 'Send via SMS',
                  subtitle: member.phone!,
                  color: Colors.green,
                  onTap: () {
                    Navigator.pop(context);
                    _sendInvite('SMS', member.id);
                  },
                ),

              if (member.email != null)
                _buildInviteOption(
                  icon: Icons.email_rounded,
                  label: 'Send via Email',
                  subtitle: member.email!,
                  color: Colors.blue,
                  onTap: () {
                    Navigator.pop(context);
                    _sendInvite('EMAIL', member.id);
                  },
                ),

              _buildInviteOption(
                icon: Icons.link_rounded,
                label: 'Copy Invite Link',
                subtitle: 'Share manually',
                color: AppColors.primary,
                onTap: () {
                  Navigator.pop(context);
                  _sendInvite('MANUAL', member.id);
                },
              ),

              const SizedBox(height: AppConstants.spacingSM),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInviteOption({
    required IconData icon,
    required String label,
    required String subtitle,
    required Color color,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppConstants.spacingLG,
          vertical: AppConstants.spacingMD,
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: color, size: 24),
            ),
            const SizedBox(width: AppConstants.spacingMD),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: AppTextStyles.bodyLarge.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(
                    subtitle,
                    style: AppTextStyles.bodyMedium.copyWith(
                      color: Colors.grey[600],
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.arrow_forward_ios_rounded,
              size: 16,
              color: Colors.grey[400],
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _sendInvite(String method, String memberId) async {
    // Show loading
    setState(() => _isLoading = true);

    try {
      final repository = ref.read(membersRepositoryProvider);
      final result = await repository.sendInvite(memberId, method);

      result.fold(
        (error) {
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(error.message),
                backgroundColor: AppColors.error,
                behavior: SnackBarBehavior.floating,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            );
          }
        },
        (response) {
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(response.message),
                backgroundColor: AppColors.success,
                behavior: SnackBarBehavior.floating,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            );

            // Navigate back to members list
            Navigator.pop(context, true);
          }
        },
      );
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: $e'),
            backgroundColor: AppColors.error,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  Future<void> _handleSubmit() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    // Validate that at least phone or email is provided
    if ((_phoneNumber == null || _phoneNumber!.isEmpty) &&
        _emailController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Please provide at least phone or email'),
          backgroundColor: AppColors.error,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      // Build member data
      final memberData = <String, dynamic>{
        'firstName': _firstNameController.text.trim(),
        'lastName': _lastNameController.text.trim(),
        if (_emailController.text.trim().isNotEmpty)
          'email': _emailController.text.trim(),
        if (_phoneNumber != null && _phoneNumber!.isNotEmpty) ...{
          'phoneCountryCode': _phoneCountryCode ?? '+1',
          'phone': _phoneNumber,
        },
        if (_selectedGender != null) 'gender': _selectedGender,
        if (_selectedDob != null)
          'dateOfBirth': _selectedDob!.toIso8601String().split('T')[0],
        // TODO: Upload profile image to Cloudinary if _profileImage != null
        if (_profileImageUrl != null) 'photo': _profileImageUrl,
      };

      // Create member via API
      final repository = ref.read(membersRepositoryProvider);
      final result = await repository.createMember(memberData);

      result.fold(
        (error) {
          if (mounted) {
            setState(() => _isLoading = false);
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(error.message),
                backgroundColor: AppColors.error,
                behavior: SnackBarBehavior.floating,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            );
          }
        },
        (member) {
          if (mounted) {
            setState(() => _isLoading = false);

            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: const Text('Member created successfully'),
                backgroundColor: AppColors.success,
                behavior: SnackBarBehavior.floating,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            );

            // Show invite method sheet
            _showInviteMethodSheet(member);
          }
        },
      );
    } catch (e) {
      if (mounted) {
        setState(() => _isLoading = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: $e'),
            backgroundColor: AppColors.error,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Add Member',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        elevation: 0,
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(AppConstants.spacingLG),
          children: [
            // Info card
            Container(
              padding: const EdgeInsets.all(AppConstants.spacingMD),
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.05),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: AppColors.primary.withValues(alpha: 0.1),
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.info_outline_rounded,
                    color: AppColors.primary,
                    size: 20,
                  ),
                  const SizedBox(width: AppConstants.spacingSM),
                  Expanded(
                    child: Text(
                      'Collect minimal info to send invite. Member completes profile during signup.',
                      style: AppTextStyles.bodySmall.copyWith(
                        color: AppColors.primary,
                        fontSize: 13,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: AppConstants.spacingLG),

            // Profile photo
            Center(
              child: ProfilePicturePicker(
                imageUrl: _profileImageUrl,
                imageFile: _profileImage,
                onImageSelected: (file) {
                  setState(() {
                    _profileImage = file;
                  });
                },
                size: 100,
                showEditIcon: true,
              ),
            ),

            const SizedBox(height: AppConstants.spacingLG),

            // First name (required)
            CustomTextField(
              controller: _firstNameController,
              label: 'First Name *',
              hint: 'Enter first name',
              textCapitalization: TextCapitalization.words,
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'First name is required';
                }
                return null;
              },
            ),

            const SizedBox(height: AppConstants.spacingMD),

            // Last name (required)
            CustomTextField(
              controller: _lastNameController,
              label: 'Last Name *',
              hint: 'Enter last name',
              textCapitalization: TextCapitalization.words,
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Last name is required';
                }
                return null;
              },
            ),

            const SizedBox(height: AppConstants.spacingMD),

            // Phone (optional but recommended)
            CustomPhoneField(
              label: 'Phone',
              hint: 'Enter phone number',
              initialCountryCode: 'US',
              initialValue: _phoneNumber,
              onChanged: (PhoneNumber phone) {
                setState(() {
                  _phoneCountryCode = '+${phone.countryCode}';
                  _phoneNumber = phone.number;
                });
              },
            ),

            const SizedBox(height: AppConstants.spacingMD),

            // Email (optional but recommended)
            CustomTextField(
              controller: _emailController,
              label: 'Email',
              hint: 'Enter email address',
              keyboardType: TextInputType.emailAddress,
              validator: (value) {
                if (value != null && value.trim().isNotEmpty) {
                  final emailRegex = RegExp(
                    r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
                  );
                  if (!emailRegex.hasMatch(value.trim())) {
                    return 'Please enter a valid email';
                  }
                }
                return null;
              },
            ),

            const SizedBox(height: AppConstants.spacingMD),

            // Date of birth (optional)
            CustomTextField(
              controller: _dobController,
              label: 'Date of Birth',
              hint: 'Select date of birth',
              enabled: true,
              suffixIcon: Icon(
                Icons.calendar_today_rounded,
                color: AppColors.gray500,
                size: 20,
              ),
              onChanged: (value) {
                // Prevent typing
                if (value.isNotEmpty) {
                  _dobController.clear();
                  _selectDate();
                }
              },
            ),

            const SizedBox(height: AppConstants.spacingMD),

            // Gender (optional)
            CustomDropdown<String>(
              label: 'Gender',
              hint: 'Select gender',
              value: _selectedGender,
              items: const [
                DropdownMenuItem(value: 'MALE', child: Text('Male')),
                DropdownMenuItem(value: 'FEMALE', child: Text('Female')),
                DropdownMenuItem(value: 'OTHER', child: Text('Other')),
              ],
              onChanged: (value) {
                setState(() => _selectedGender = value);
              },
            ),

            const SizedBox(height: AppConstants.spacingXL),

            // Submit button
            SizedBox(
              width: double.infinity,
              height: AppConstants.buttonHeightMD,
              child: ElevatedButton(
                onPressed: _isLoading ? null : _handleSubmit,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 0,
                  disabledBackgroundColor: AppColors.gray300,
                ),
                child: _isLoading
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator.adaptive(
                          strokeWidth: 2,
                          valueColor:
                              AlwaysStoppedAnimation<Color>(Colors.white),
                        ),
                      )
                    : const Text(
                        'Create & Send Invite',
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 16,
                        ),
                      ),
              ),
            ),

            const SizedBox(height: AppConstants.spacingMD),

            // Note
            Center(
              child: Text(
                '* Required field',
                style: AppTextStyles.caption.copyWith(
                  color: Colors.grey[600],
                  fontSize: 12,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
