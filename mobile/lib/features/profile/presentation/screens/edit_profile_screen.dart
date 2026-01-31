import 'dart:io';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:intl_phone_field/phone_number.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/constants/app_routes.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../core/widgets/custom_button.dart';
import '../../../../core/widgets/custom_text_field.dart';
import '../../../../core/widgets/custom_dropdown.dart';
import '../../../../core/widgets/profile_picture_picker.dart';
import '../../../../core/widgets/custom_phone_field.dart';
import '../../../auth/presentation/providers/auth_state_provider.dart';
import '../../../members/data/providers/members_providers.dart';

/// Edit profile screen for users to update their own information
class EditProfileScreen extends ConsumerStatefulWidget {
  const EditProfileScreen({super.key});

  @override
  ConsumerState<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends ConsumerState<EditProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _occupationController = TextEditingController();
  final _dateOfBirthController = TextEditingController();
  final _streetController = TextEditingController();
  final _cityController = TextEditingController();
  final _stateController = TextEditingController();
  final _zipController = TextEditingController();
  final _emergencyNameController = TextEditingController();
  final _emergencyRelationshipController = TextEditingController();

  bool _isLoading = false;
  File? _profileImage;
  String? _profileImageUrl;
  String? _phoneCountryCode;
  String? _phoneNumber;
  String? _emergencyPhoneCountryCode;
  String? _emergencyPhoneNumber;
  String? _selectedGender;
  String? _selectedMaritalStatus;

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
  DateTime? _dateOfBirth;
  String? _memberId;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  void _loadUserData() {
    final user = ref.read(authStateProvider).user;
    if (user != null) {
      setState(() {
        _firstNameController.text = user.firstName;
        _lastNameController.text = user.lastName;
        _emailController.text = user.email;
        _phoneCountryCode = user.phoneCountryCode ?? '+1';
        _phoneNumber = user.phone;
        _profileImageUrl = user.avatar;
      });
    }
    // Load member data if user is linked to a member
    _loadMemberData();
  }

  Future<void> _loadMemberData() async {
    final repository = ref.read(membersRepositoryProvider);
    final result = await repository.getMyMemberProfile();

    result.fold(
      (error) {
        // Member profile not found or error - user might not be linked to a member
        debugPrint('❌ Failed to load member data: ${error.message}');
      },
      (member) {
        if (mounted) {
          setState(() {
            _memberId = member.id;
            // Override with member data if available
            if (member.firstName.isNotEmpty) {
              _firstNameController.text = member.firstName;
            }
            if (member.lastName.isNotEmpty) {
              _lastNameController.text = member.lastName;
            }
            if (member.email != null && member.email!.isNotEmpty) {
              _emailController.text = member.email!;
            }
            if (member.phone != null) {
              _phoneCountryCode = member.phoneCountryCode ?? '+1';
              _phoneNumber = member.phone;
            }
            if (member.photo != null) {
              _profileImageUrl = member.photo;
            }
            _selectedGender = member.gender;
            _selectedMaritalStatus = member.maritalStatus;
            if (member.occupation != null) {
              _occupationController.text = member.occupation!;
            }
            if (member.dateOfBirth != null) {
              _dateOfBirth = DateTime.parse(member.dateOfBirth!);
              _dateOfBirthController.text = _formatDate(_dateOfBirth);
            }
            if (member.address != null) {
              _streetController.text = member.address!.street ?? '';
              _cityController.text = member.address!.city ?? '';
              _stateController.text = member.address!.state ?? '';
              _zipController.text = member.address!.zip ?? '';
            }
            if (member.emergencyContact != null) {
              _emergencyNameController.text = member.emergencyContact!.name ?? '';
              _emergencyRelationshipController.text =
                  member.emergencyContact!.relationship ?? '';
              _emergencyPhoneCountryCode =
                  member.emergencyContact!.phoneCountryCode ?? '+1';
              _emergencyPhoneNumber = member.emergencyContact!.phone;
            }
          });
        }
      },
    );
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _occupationController.dispose();
    _dateOfBirthController.dispose();
    _streetController.dispose();
    _cityController.dispose();
    _stateController.dispose();
    _zipController.dispose();
    _emergencyNameController.dispose();
    _emergencyRelationshipController.dispose();
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context, {
    required Function(DateTime) onDateSelected,
    DateTime? initialDate,
  }) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: initialDate ?? DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );

    if (picked != null) {
      onDateSelected(picked);
    }
  }

  String _formatDate(DateTime? date) {
    if (date == null) return '';
    return DateFormat('MMM d, y').format(date);
  }

  Future<void> _saveProfile() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      // Build user update data
      final userData = {
        'firstName': _firstNameController.text.trim(),
        'lastName': _lastNameController.text.trim(),
        if (_phoneNumber != null && _phoneNumber!.isNotEmpty) ...{
          'phoneCountryCode': _phoneCountryCode ?? '+1',
          'phone': _phoneNumber,
        },
      };

      // Convert profile image to base64 if changed
      // Backend will upload to Cloudinary
      if (_profileImage != null) {
        final bytes = await _profileImage!.readAsBytes();
        final base64String = base64Encode(bytes);
        final mimeType = _profileImage!.path.toLowerCase().endsWith('.png')
            ? 'image/png'
            : 'image/jpeg';
        userData['avatarBase64'] = 'data:$mimeType;base64,$base64String';
      }

      // Build member update data (for fields not in user model)
      final memberData = {
        'firstName': _firstNameController.text.trim(),
        'lastName': _lastNameController.text.trim(),
        if (_emailController.text.isNotEmpty)
          'email': _emailController.text.trim(),
        if (_phoneNumber != null && _phoneNumber!.isNotEmpty) ...{
          'phoneCountryCode': _phoneCountryCode ?? '+1',
          'phone': _phoneNumber,
        },
        if (_selectedGender != null) 'gender': _selectedGender,
        if (_selectedMaritalStatus != null) 'maritalStatus': _selectedMaritalStatus,
        if (_occupationController.text.isNotEmpty)
          'occupation': _occupationController.text.trim(),
        if (_dateOfBirth != null)
          'dateOfBirth': _dateOfBirth!.toIso8601String().split('T')[0],
        if (_streetController.text.isNotEmpty ||
            _cityController.text.isNotEmpty ||
            _stateController.text.isNotEmpty ||
            _zipController.text.isNotEmpty)
          'address': {
            'street': _streetController.text.trim(),
            'city': _cityController.text.trim(),
            'state': _stateController.text.trim(),
            'zip': _zipController.text.trim(),
            'country': 'USA',
          },
        if (_emergencyNameController.text.isNotEmpty ||
            _emergencyPhoneNumber != null ||
            _emergencyRelationshipController.text.isNotEmpty)
          'emergencyContact': {
            'name': _emergencyNameController.text.trim(),
            'relationship': _emergencyRelationshipController.text.trim(),
            if (_emergencyPhoneNumber != null && _emergencyPhoneNumber!.isNotEmpty) ...{
              'phoneCountryCode': _emergencyPhoneCountryCode ?? '+1',
              'phone': _emergencyPhoneNumber,
            },
          },
      };

      // If profile image changed, add to member data too
      if (_profileImage != null) {
        final bytes = await _profileImage!.readAsBytes();
        final base64String = base64Encode(bytes);
        final mimeType = _profileImage!.path.toLowerCase().endsWith('.png')
            ? 'image/png'
            : 'image/jpeg';
        memberData['photoBase64'] = 'data:$mimeType;base64,$base64String';
      }

      // Update user profile first
      final userSuccess = await ref
          .read(authStateProvider.notifier)
          .updateProfile(userData);

      // Update member profile if member ID is available
      bool memberSuccess = true;
      if (_memberId != null) {
        final memberRepository = ref.read(membersRepositoryProvider);
        final memberResult = await memberRepository.updateMyMemberProfile(memberData);
        memberResult.fold(
          (error) => memberSuccess = false,
          (member) => memberSuccess = true,
        );
      }

      if (!mounted) return;

      setState(() => _isLoading = false);

      if (userSuccess && memberSuccess) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Profile updated successfully'),
            backgroundColor: Colors.green,
            duration: Duration(seconds: 2),
          ),
        );
        // Navigate back to profile screen
        context.go(AppRoutes.profile);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Failed to update profile'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isLoading = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(authStateProvider).user;

    if (user == null) {
      return const Scaffold(
        body: Center(child: Text('Not logged in')),
      );
    }

    return GestureDetector(
      onHorizontalDragEnd: (details) {
        // Swipe from left to right to go back
        if (details.primaryVelocity != null &&
            details.primaryVelocity! > 0 &&
            Navigator.canPop(context)) {
          Navigator.pop(context);
        }
      },
      child: Scaffold(
        backgroundColor: AppColors.backgroundLight,
        appBar: AppBar(
          title: const Text(
            'Edit Profile',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
          elevation: 0,
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => Navigator.pop(context),
          ),
        ),
        body: Form(
          key: _formKey,
          child: ListView(
            padding: const EdgeInsets.all(AppConstants.spacingLG),
            children: [
              // Profile picture picker
              Center(
                child: ProfilePicturePicker(
                  imageUrl: _profileImageUrl,
                  imageFile: _profileImage,
                  onImageSelected: (file) {
                    setState(() {
                      _profileImage = file;
                    });
                  },
                  size: 120,
                ),
              ),

              const SizedBox(height: AppConstants.spacingLG),

              // Header with icon
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          AppColors.primary,
                          AppColors.primary.withValues(alpha: 0.7),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.primary.withValues(alpha: 0.3),
                          blurRadius: 12,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: const Icon(
                      Icons.edit_rounded,
                      color: Colors.white,
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: AppConstants.spacingMD),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Update Your Info',
                        style: AppTextStyles.headlineSmall.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        'Edit your profile details',
                        style: AppTextStyles.caption.copyWith(
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ],
              ),

              const SizedBox(height: AppConstants.spacingLG),

              // Basic Information Section - Contact info (name, email, phone)
              _buildFormSection(
                'Basic Information',
                Icons.contacts_rounded,
                Colors.blue,
                [
                  // First name
                  CustomTextField(
                    controller: _firstNameController,
                    label: 'First Name',
                    hint: 'Enter first name',
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'First name is required';
                      }
                      return null;
                    },
                  ),

                  const SizedBox(height: AppConstants.spacingMD),

                  // Last name
                  CustomTextField(
                    controller: _lastNameController,
                    label: 'Last Name',
                    hint: 'Enter last name',
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Last name is required';
                      }
                      return null;
                    },
                  ),

                  const SizedBox(height: AppConstants.spacingMD),

                  // Email (read-only for now, requires verification to change)
                  CustomTextField(
                    controller: _emailController,
                    label: 'Email',
                    hint: 'Enter email address',
                    keyboardType: TextInputType.emailAddress,
                    enabled: false, // Read-only
                  ),

                  const SizedBox(height: AppConstants.spacingMD),

                  // Phone with country code
                  CustomPhoneField(
                    label: 'Phone',
                    hint: 'Enter phone number',
                    initialCountryCode: _getCountryCodeFromDialCode(_phoneCountryCode),
                    initialValue: _phoneNumber,
                    onChanged: (PhoneNumber phone) {
                      setState(() {
                        _phoneCountryCode = '+${phone.countryCode}';
                        _phoneNumber = phone.number;
                      });
                    },
                  ),
                ],
              ),

              const SizedBox(height: AppConstants.spacingMD),

              // Personal Details Section
              _buildFormSection(
                'Personal Details',
                Icons.badge_rounded,
                Colors.purple,
                [
                  // Gender
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

                  const SizedBox(height: AppConstants.spacingMD),

                  // Marital Status
                  CustomDropdown<String>(
                    label: 'Marital Status',
                    hint: 'Select marital status',
                    value: _selectedMaritalStatus,
                    items: const [
                      DropdownMenuItem(value: 'SINGLE', child: Text('Single')),
                      DropdownMenuItem(value: 'MARRIED', child: Text('Married')),
                      DropdownMenuItem(value: 'DIVORCED', child: Text('Divorced')),
                      DropdownMenuItem(value: 'WIDOWED', child: Text('Widowed')),
                    ],
                    onChanged: (value) {
                      setState(() => _selectedMaritalStatus = value);
                    },
                  ),

                  const SizedBox(height: AppConstants.spacingMD),

                  // Date of Birth
                  InkWell(
                    onTap: () {
                      _selectDate(
                        context,
                        onDateSelected: (date) {
                          setState(() {
                            _dateOfBirth = date;
                            _dateOfBirthController.text = _formatDate(date);
                          });
                        },
                        initialDate: _dateOfBirth,
                      );
                    },
                    child: AbsorbPointer(
                      child: CustomTextField(
                        controller: _dateOfBirthController,
                        label: 'Date of Birth',
                        hint: 'Select date of birth',
                        suffixIcon: const Icon(Icons.calendar_today),
                      ),
                    ),
                  ),

                  const SizedBox(height: AppConstants.spacingMD),

                  // Occupation
                  CustomTextField(
                    controller: _occupationController,
                    label: 'Occupation',
                    hint: 'Enter occupation',
                  ),
                ],
              ),

              const SizedBox(height: AppConstants.spacingMD),

              // Address Section
              _buildFormSection(
                'Address',
                Icons.location_on_rounded,
                Colors.green,
                [
                  // Street
                  CustomTextField(
                    controller: _streetController,
                    label: 'Street',
                    hint: 'Enter street address',
                  ),

                  const SizedBox(height: AppConstants.spacingMD),

                  // City
                  CustomTextField(
                    controller: _cityController,
                    label: 'City',
                    hint: 'Enter city',
                  ),

                  const SizedBox(height: AppConstants.spacingMD),

                  Row(
                    children: [
                      // State
                      Expanded(
                        child: CustomTextField(
                          controller: _stateController,
                          label: 'State',
                          hint: 'State',
                        ),
                      ),
                      const SizedBox(width: AppConstants.spacingMD),
                      // ZIP
                      Expanded(
                        child: CustomTextField(
                          controller: _zipController,
                          label: 'ZIP Code',
                          hint: 'ZIP',
                          keyboardType: TextInputType.number,
                        ),
                      ),
                    ],
                  ),
                ],
              ),

              const SizedBox(height: AppConstants.spacingMD),

              // Emergency Contact Section
              _buildFormSection(
                'Emergency Contact',
                Icons.emergency_rounded,
                Colors.red,
                [
                  // Emergency contact name
                  CustomTextField(
                    controller: _emergencyNameController,
                    label: 'Name',
                    hint: 'Emergency contact name',
                  ),

                  const SizedBox(height: AppConstants.spacingMD),

                  // Emergency contact relationship
                  CustomTextField(
                    controller: _emergencyRelationshipController,
                    label: 'Relationship',
                    hint: 'Relationship (e.g., Spouse, Parent)',
                  ),

                  const SizedBox(height: AppConstants.spacingMD),

                  // Emergency contact phone with country code
                  CustomPhoneField(
                    label: 'Phone',
                    hint: 'Emergency contact phone',
                    initialCountryCode: _getCountryCodeFromDialCode(_emergencyPhoneCountryCode),
                    initialValue: _emergencyPhoneNumber,
                    onChanged: (PhoneNumber phone) {
                      setState(() {
                        _emergencyPhoneCountryCode = '+${phone.countryCode}';
                        _emergencyPhoneNumber = phone.number;
                      });
                    },
                  ),
                ],
              ),

              const SizedBox(height: AppConstants.spacingXL),

              // Save button
              CustomButton(
                text: 'Save Changes',
                onPressed: _isLoading ? null : _saveProfile,
                isLoading: _isLoading,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFormSection(
    String title,
    IconData icon,
    Color accentColor,
    List<Widget> children,
  ) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: accentColor.withValues(alpha: 0.1),
            blurRadius: 20,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Container(
            padding: const EdgeInsets.all(AppConstants.spacingMD),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  accentColor.withValues(alpha: 0.08),
                  accentColor.withValues(alpha: 0.02),
                ],
              ),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(16),
                topRight: Radius.circular(16),
              ),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                    boxShadow: [
                      BoxShadow(
                        color: accentColor.withValues(alpha: 0.2),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Icon(icon, color: accentColor, size: 18),
                ),
                const SizedBox(width: AppConstants.spacingMD),
                Text(
                  title,
                  style: AppTextStyles.headlineSmall.copyWith(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ),
          // Content
          Padding(
            padding: const EdgeInsets.all(AppConstants.spacingLG),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: children,
            ),
          ),
        ],
      ),
    );
  }
}
