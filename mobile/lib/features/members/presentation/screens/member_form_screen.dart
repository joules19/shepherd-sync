import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/widgets/custom_button.dart';
import '../../../../core/widgets/custom_text_field.dart';
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
  final _phoneController = TextEditingController();
  final _occupationController = TextEditingController();
  final _dateOfBirthController = TextEditingController();
  final _joinedDateController = TextEditingController();
  final _baptismDateController = TextEditingController();
  final _streetController = TextEditingController();
  final _cityController = TextEditingController();
  final _stateController = TextEditingController();
  final _zipController = TextEditingController();
  final _emergencyNameController = TextEditingController();
  final _emergencyPhoneController = TextEditingController();
  final _emergencyRelationshipController = TextEditingController();

  bool _isLoading = false;
  String? _selectedGender;
  String? _selectedMembershipStatus;
  String? _selectedMaritalStatus;
  DateTime? _dateOfBirth;
  DateTime? _joinedDate;
  DateTime? _baptismDate;

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
            _phoneController.text = member.phone ?? '';
            _occupationController.text = member.occupation ?? '';
            _selectedGender = member.gender;
            _selectedMembershipStatus = member.membershipStatus;
            _selectedMaritalStatus = member.maritalStatus;

            if (member.dateOfBirth != null) {
              _dateOfBirth = DateTime.parse(member.dateOfBirth!);
              _dateOfBirthController.text = member.dateOfBirth!;
            }
            if (member.joinedDate != null) {
              _joinedDate = DateTime.parse(member.joinedDate!);
              _joinedDateController.text = member.joinedDate!;
            }
            if (member.baptismDate != null) {
              _baptismDate = DateTime.parse(member.baptismDate!);
              _baptismDateController.text = member.baptismDate!;
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
              _emergencyPhoneController.text =
                  member.emergencyContact!.phone ?? '';
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
    _phoneController.dispose();
    _occupationController.dispose();
    _dateOfBirthController.dispose();
    _joinedDateController.dispose();
    _baptismDateController.dispose();
    _streetController.dispose();
    _cityController.dispose();
    _stateController.dispose();
    _zipController.dispose();
    _emergencyNameController.dispose();
    _emergencyPhoneController.dispose();
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
    return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
  }

  Future<void> _saveMember() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    final data = {
      'firstName': _firstNameController.text.trim(),
      'lastName': _lastNameController.text.trim(),
      if (_emailController.text.isNotEmpty)
        'email': _emailController.text.trim(),
      if (_phoneController.text.isNotEmpty)
        'phone': _phoneController.text.trim(),
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
          _emergencyPhoneController.text.isNotEmpty ||
          _emergencyRelationshipController.text.isNotEmpty)
        'emergencyContact': {
          'name': _emergencyNameController.text.trim(),
          'relationship': _emergencyRelationshipController.text.trim(),
          'phone': _emergencyPhoneController.text.trim(),
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
          title: Text(widget.memberId == null ? 'Add Member' : 'Edit Member'),
        ),
        body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(AppConstants.spacingMD),
          children: [
            // Basic info section
            Card(
              child: Padding(
                padding: const EdgeInsets.all(AppConstants.spacingMD),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Basic Information',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: AppConstants.spacingMD),

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

                    // Phone
                    CustomTextField(
                      controller: _phoneController,
                      label: 'Phone',
                      hint: 'Enter phone number',
                      keyboardType: TextInputType.phone,
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: AppConstants.spacingMD),

            // Membership info section
            Card(
              child: Padding(
                padding: const EdgeInsets.all(AppConstants.spacingMD),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Membership Details',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: AppConstants.spacingMD),

                    // Gender
                    DropdownButtonFormField<String>(
                      value: _selectedGender,
                      decoration: const InputDecoration(
                        labelText: 'Gender',
                        border: OutlineInputBorder(),
                      ),
                      items: const [
                        DropdownMenuItem(value: 'MALE', child: Text('Male')),
                        DropdownMenuItem(
                          value: 'FEMALE',
                          child: Text('Female'),
                        ),
                        DropdownMenuItem(value: 'OTHER', child: Text('Other')),
                      ],
                      onChanged: (value) {
                        setState(() => _selectedGender = value);
                      },
                    ),

                    const SizedBox(height: AppConstants.spacingMD),

                    // Membership Status
                    DropdownButtonFormField<String>(
                      value: _selectedMembershipStatus,
                      decoration: const InputDecoration(
                        labelText: 'Membership Status',
                        border: OutlineInputBorder(),
                      ),
                      items: const [
                        DropdownMenuItem(
                          value: 'VISITOR',
                          child: Text('Visitor'),
                        ),
                        DropdownMenuItem(
                          value: 'REGULAR_ATTENDEE',
                          child: Text('Regular Attendee'),
                        ),
                        DropdownMenuItem(
                          value: 'ACTIVE_MEMBER',
                          child: Text('Active Member'),
                        ),
                        DropdownMenuItem(
                          value: 'INACTIVE',
                          child: Text('Inactive'),
                        ),
                      ],
                      onChanged: (value) {
                        setState(() => _selectedMembershipStatus = value);
                      },
                    ),

                    const SizedBox(height: AppConstants.spacingMD),

                    // Marital Status
                    DropdownButtonFormField<String>(
                      value: _selectedMaritalStatus,
                      decoration: const InputDecoration(
                        labelText: 'Marital Status',
                        border: OutlineInputBorder(),
                      ),
                      items: const [
                        DropdownMenuItem(
                          value: 'SINGLE',
                          child: Text('Single'),
                        ),
                        DropdownMenuItem(
                          value: 'MARRIED',
                          child: Text('Married'),
                        ),
                        DropdownMenuItem(
                          value: 'DIVORCED',
                          child: Text('Divorced'),
                        ),
                        DropdownMenuItem(
                          value: 'WIDOWED',
                          child: Text('Widowed'),
                        ),
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
              ),
            ),

            const SizedBox(height: AppConstants.spacingMD),

            // Church dates section
            Card(
              child: Padding(
                padding: const EdgeInsets.all(AppConstants.spacingMD),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Church Information',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: AppConstants.spacingMD),

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
              ),
            ),

            const SizedBox(height: AppConstants.spacingMD),

            // Address section
            Card(
              child: Padding(
                padding: const EdgeInsets.all(AppConstants.spacingMD),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Address',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: AppConstants.spacingMD),

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
              ),
            ),

            const SizedBox(height: AppConstants.spacingMD),

            // Emergency contact section
            Card(
              child: Padding(
                padding: const EdgeInsets.all(AppConstants.spacingMD),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Emergency Contact',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: AppConstants.spacingMD),

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

                    // Emergency contact phone
                    CustomTextField(
                      controller: _emergencyPhoneController,
                      label: 'Phone',
                      hint: 'Emergency contact phone',
                      keyboardType: TextInputType.phone,
                    ),
                  ],
                ),
              ),
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
}
