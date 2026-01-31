import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:intl_phone_field/phone_number.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../core/widgets/custom_button.dart';
import '../../../../core/widgets/custom_text_field.dart';
import '../../../../core/widgets/custom_dropdown.dart';
import '../../../../core/widgets/profile_picture_picker.dart';
import '../../../../core/widgets/custom_phone_field.dart';
import '../../data/providers/members_providers.dart';

/// Member form screen for creating/editing members
class MemberFormScreen extends ConsumerStatefulWidget {
  const MemberFormScreen({
    super.key,
    this.memberId,
  });

  final String? memberId;

  @override
  ConsumerState<MemberFormScreen> createState() => _MemberFormScreenState();
}

class _MemberFormScreenState extends ConsumerState<MemberFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _occupationController = TextEditingController();
  final _dateOfBirthController = TextEditingController();
  final _joinedDateController = TextEditingController();
  final _baptismDateController = TextEditingController();
  final _streetController = TextEditingController();
  final _cityController = TextEditingController();
  final _stateController = TextEditingController();
  final _zipController = TextEditingController();
  final _emergencyNameController = TextEditingController();
  final _emergencyRelationshipController = TextEditingController();

  bool _isLoading = false;
  File? _profileImage;
  String? _profileImageUrl;
  String? _selectedGender;
  String? _selectedMembershipStatus;
  String? _selectedMaritalStatus;
  String? _phoneCountryCode;
  String? _phoneNumber;
  String? _emergencyPhoneCountryCode;
  String? _emergencyPhoneNumber;
  DateTime? _dateOfBirth;
  DateTime? _joinedDate;
  DateTime? _baptismDate;

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
  void initState() {
    super.initState();
    if (widget.memberId != null) {
      _loadMember();
    }
  }

  Future<void> _loadMember() async {
    final repository = ref.read(membersRepositoryProvider);
    final result = await repository.getMember(widget.memberId!);

    result.fold(
      (error) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(error.message)),
          );
        }
      },
      (member) {
        if (mounted) {
          setState(() {
            _firstNameController.text = member.firstName;
            _lastNameController.text = member.lastName;
            _emailController.text = member.email ?? '';
            _phoneCountryCode = member.phoneCountryCode ?? '+1';
            _phoneNumber = member.phone;
            _profileImageUrl = member.photo;
            _occupationController.text = member.occupation ?? '';
            _selectedGender = member.gender;
            _selectedMembershipStatus = member.membershipStatus;
            _selectedMaritalStatus = member.maritalStatus;

            if (member.dateOfBirth != null) {
              _dateOfBirth = DateTime.parse(member.dateOfBirth!);
              _dateOfBirthController.text = _formatDate(_dateOfBirth);
            }
            if (member.joinedDate != null) {
              _joinedDate = DateTime.parse(member.joinedDate!);
              _joinedDateController.text = _formatDate(_joinedDate);
            }
            if (member.baptismDate != null) {
              _baptismDate = DateTime.parse(member.baptismDate!);
              _baptismDateController.text = _formatDate(_baptismDate);
            }

            if (member.address != null) {
              _streetController.text = member.address!.street ?? '';
              _cityController.text = member.address!.city ?? '';
              _stateController.text = member.address!.state ?? '';
              _zipController.text = member.address!.zip ?? '';
            }

            if (member.emergencyContact != null) {
              _emergencyNameController.text =
                  member.emergencyContact!.name ?? '';
              _emergencyRelationshipController.text =
                  member.emergencyContact!.relationship ?? '';
              _emergencyPhoneCountryCode =
                  member.emergencyContact!.phoneCountryCode ?? '+1';
              _emergencyPhoneNumber =
                  member.emergencyContact!.phone;
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
    _joinedDateController.dispose();
    _baptismDateController.dispose();
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

  Future<void> _saveMember() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    final data = {
      'firstName': _firstNameController.text.trim(),
      'lastName': _lastNameController.text.trim(),
      if (_emailController.text.isNotEmpty)
        'email': _emailController.text.trim(),
      if (_phoneNumber != null && _phoneNumber!.isNotEmpty) ...{
        'phoneCountryCode': _phoneCountryCode ?? '+1',
        'phone': _phoneNumber,
      },
      if (_profileImageUrl != null) 'photo': _profileImageUrl,
      // TODO: Upload _profileImage to backend if changed
      if (_selectedGender != null) 'gender': _selectedGender,
      if (_selectedMembershipStatus != null)
        'membershipStatus': _selectedMembershipStatus,
      if (_selectedMaritalStatus != null)
        'maritalStatus': _selectedMaritalStatus,
      if (_occupationController.text.isNotEmpty)
        'occupation': _occupationController.text.trim(),
      if (_dateOfBirth != null)
        'dateOfBirth': _dateOfBirth!.toIso8601String().split('T')[0],
      if (_joinedDate != null)
        'joinedDate': _joinedDate!.toIso8601String().split('T')[0],
      if (_baptismDate != null)
        'baptismDate': _baptismDate!.toIso8601String().split('T')[0],
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

    final repository = ref.read(membersRepositoryProvider);
    final result = widget.memberId == null
        ? await repository.createMember(data)
        : await repository.updateMember(widget.memberId!, data);

    if (!mounted) return;

    setState(() => _isLoading = false);

    result.fold(
      (error) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(error.message)),
        );
      },
      (member) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(widget.memberId == null
                ? 'Member created successfully'
                : 'Member updated successfully'),
          ),
        );
        Navigator.pop(context, true);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
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
          title: Text(
            widget.memberId == null ? 'Add Member' : 'Edit Member',
            style: const TextStyle(
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
                    Icons.person_add_rounded,
                    color: Colors.white,
                    size: 24,
                  ),
                ),
                const SizedBox(width: AppConstants.spacingMD),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.memberId == null ? 'New Member' : 'Edit Member',
                      style: AppTextStyles.headlineSmall.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      'Fill in the details below',
                      style: AppTextStyles.caption.copyWith(
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ],
            ),

            const SizedBox(height: AppConstants.spacingLG),

            // Basic info section - Contact info (name, email, phone)
            _buildFormSection(
              'Basic Information',
              Icons.contacts_rounded,
              Colors.blue, // Matches "Contact Information" in detail screen
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

                    // Email
                    CustomTextField(
                      controller: _emailController,
                      label: 'Email',
                      hint: 'Enter email address',
                      keyboardType: TextInputType.emailAddress,
                      validator: (value) {
                        if (value != null &&
                            value.isNotEmpty &&
                            !value.contains('@')) {
                          return 'Enter a valid email';
                        }
                        return null;
                      },
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

            // Membership info section - Personal info (gender, marital status)
            _buildFormSection(
              'Membership Details',
              Icons.card_membership_rounded,
              Colors.purple, // Matches "Personal Information" in detail screen
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

                    // Membership Status
                    CustomDropdown<String>(
                      label: 'Membership Status',
                      hint: 'Select membership status',
                      value: _selectedMembershipStatus,
                      items: const [
                        DropdownMenuItem(value: 'VISITOR', child: Text('Visitor')),
                        DropdownMenuItem(
                          value: 'REGULAR_ATTENDEE',
                          child: Text('Regular Attendee'),
                        ),
                        DropdownMenuItem(
                          value: 'ACTIVE_MEMBER',
                          child: Text('Active Member'),
                        ),
                        DropdownMenuItem(value: 'INACTIVE', child: Text('Inactive')),
                      ],
                      onChanged: (value) {
                        setState(() => _selectedMembershipStatus = value);
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

            // Church dates section
            _buildFormSection(
              'Church Information',
              Icons.church_rounded,
              AppColors.primary,
              [
                    // Joined Date
                    InkWell(
                      onTap: () {
                        _selectDate(
                          context,
                          onDateSelected: (date) {
                            setState(() {
                              _joinedDate = date;
                              _joinedDateController.text = _formatDate(date);
                            });
                          },
                          initialDate: _joinedDate,
                        );
                      },
                      child: AbsorbPointer(
                        child: CustomTextField(
                          controller: _joinedDateController,
                          label: 'Joined Date',
                          hint: 'When did they join?',
                          suffixIcon: const Icon(Icons.calendar_today),
                        ),
                      ),
                    ),

                    const SizedBox(height: AppConstants.spacingMD),

                    // Baptism Date
                    InkWell(
                      onTap: () {
                        _selectDate(
                          context,
                          onDateSelected: (date) {
                            setState(() {
                              _baptismDate = date;
                              _baptismDateController.text = _formatDate(date);
                            });
                          },
                          initialDate: _baptismDate,
                        );
                      },
                      child: AbsorbPointer(
                        child: CustomTextField(
                          controller: _baptismDateController,
                          label: 'Baptism Date',
                          hint: 'Baptism date (optional)',
                          suffixIcon: const Icon(Icons.water_drop),
                        ),
                      ),
                    ),
              ],
            ),

            const SizedBox(height: AppConstants.spacingMD),

            // Address section
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

            // Emergency contact section
            _buildFormSection(
              'Emergency Contact',
              Icons.emergency_rounded,
              Colors.red, // Matches "Emergency Contact" in detail screen
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
              text: widget.memberId == null ? 'Add Member' : 'Save Changes',
              onPressed: _isLoading ? null : _saveMember,
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
