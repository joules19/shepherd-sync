import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/constants/app_routes.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../core/widgets/custom_button.dart';
import '../../../../core/widgets/custom_text_field.dart';
import '../../../../core/widgets/profile_picture_picker.dart';
import '../../data/models/auth_models.dart';
import '../../data/providers/auth_providers.dart';

/// Beautiful invite signup screen
/// Member completes their profile and creates account
class InviteSignupScreen extends ConsumerStatefulWidget {
  const InviteSignupScreen({
    super.key,
    required this.inviteToken,
  });

  final String inviteToken;

  @override
  ConsumerState<InviteSignupScreen> createState() => _InviteSignupScreenState();
}

class _InviteSignupScreenState extends ConsumerState<InviteSignupScreen> {
  final _formKey = GlobalKey<FormState>();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  bool _isLoading = false;
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  File? _profileImage;

  // Invite data (loaded from API)
  String? _firstName;
  String? _lastName;
  String? _email;
  String? _phone;
  String? _organizationName;
  String? _organizationLogo;

  @override
  void initState() {
    super.initState();
    _validateAndLoadInvite();
  }

  @override
  void dispose() {
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _validateAndLoadInvite() async {
    setState(() => _isLoading = true);

    try {
      final repository = ref.read(authRepositoryProvider);
      final result = await repository.validateInvite(widget.inviteToken);

      result.fold(
        (error) {
          // Invalid or expired invite
          if (mounted) {
            setState(() => _isLoading = false);
            _showErrorAndGoBack(error.message);
          }
        },
        (response) {
          if (mounted) {
            setState(() {
              _firstName = response.member.firstName;
              _lastName = response.member.lastName;
              _email = response.member.email;
              _phone = response.member.phone != null
                  ? '${response.member.phoneCountryCode ?? ''} ${response.member.phone}'
                  : null;
              _organizationName = response.member.organizationName;
              _organizationLogo = response.member.organizationLogo;
              _isLoading = false;
            });
          }
        },
      );
    } catch (e) {
      if (mounted) {
        setState(() => _isLoading = false);
        _showErrorAndGoBack('Failed to load invite. Please try again.');
      }
    }
  }

  void _showErrorAndGoBack(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Invalid Invite'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pop(context);
            },
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  Future<void> _completeSignup() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      // Convert profile image to base64 if provided
      String? profilePhotoBase64;
      if (_profileImage != null) {
        final bytes = await _profileImage!.readAsBytes();
        profilePhotoBase64 = 'data:image/jpeg;base64,${base64Encode(bytes)}';
      }

      // Create complete invite request
      final request = CompleteInviteRequest(
        token: widget.inviteToken,
        password: _passwordController.text.trim(),
        profilePhotoBase64: profilePhotoBase64,
      );

      // Call API to complete signup
      final repository = ref.read(authRepositoryProvider);
      final result = await repository.completeInvite(request);

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
        (response) {
          if (mounted) {
            setState(() => _isLoading = false);

            // Show success message
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: const Text('Account created successfully! Please log in to continue.'),
                backgroundColor: AppColors.success,
                behavior: SnackBarBehavior.floating,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                duration: const Duration(seconds: 2),
              ),
            );

            // Navigate to login screen after the current frame completes
            // This ensures the widget tree is stable before navigation
            WidgetsBinding.instance.addPostFrameCallback((_) {
              if (mounted) {
                // First pop the current screen (InviteSignupScreen)
                // Then navigate to login using GoRouter
                Navigator.of(context).popUntil((route) => route.isFirst);
                context.go(AppRoutes.login);
              }
            });
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

  Future<void> _signUpWithGoogle() async {
    // TODO: Implement Google Sign-In
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Google Sign-In coming soon')),
    );
  }

  Future<void> _signUpWithApple() async {
    // TODO: Implement Apple Sign-In
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Apple Sign-In coming soon')),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading && _firstName == null) {
      return Scaffold(
        backgroundColor: AppColors.backgroundLight,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircularProgressIndicator.adaptive(
                valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
              ),
              const SizedBox(height: AppConstants.spacingLG),
              Text(
                'Validating your invite...',
                style: AppTextStyles.bodyMedium.copyWith(
                  color: Colors.grey[600],
                ),
              ),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: ListView(
            padding: const EdgeInsets.all(AppConstants.spacingLG),
            children: [
              const SizedBox(height: AppConstants.spacingLG),

              // Church logo (if available)
              if (_organizationLogo != null)
                Center(
                  child: Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.05),
                          blurRadius: 10,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: Image.network(
                        _organizationLogo!,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),

              if (_organizationLogo != null)
                const SizedBox(height: AppConstants.spacingLG),

              // Welcome message
              Text(
                'Welcome to ${_organizationName ?? 'Shepherd Sync'}!',
                textAlign: TextAlign.center,
                style: AppTextStyles.headlineMedium.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: AppConstants.spacingSM),

              Text(
                'Complete your profile to get started',
                textAlign: TextAlign.center,
                style: AppTextStyles.bodyMedium.copyWith(
                  color: Colors.grey[600],
                ),
              ),

              const SizedBox(height: AppConstants.spacingXL),

              // Profile photo picker
              Center(
                child: ProfilePicturePicker(
                  imageFile: _profileImage,
                  onImageSelected: (file) {
                    setState(() {
                      _profileImage = file;
                    });
                  },
                  size: 100,
                ),
              ),

              const SizedBox(height: AppConstants.spacingXL),

              // Pre-filled member details (read-only)
              Container(
                padding: const EdgeInsets.all(AppConstants.spacingLG),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.04),
                      blurRadius: 10,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.info_outline_rounded,
                          color: AppColors.primary,
                          size: 20,
                        ),
                        const SizedBox(width: AppConstants.spacingSM),
                        Text(
                          'Your Information',
                          style: AppTextStyles.bodyMedium.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: AppConstants.spacingMD),

                    _buildInfoRow('Name', '$_firstName $_lastName'),
                    if (_email != null) _buildInfoRow('Email', _email!),
                    if (_phone != null) _buildInfoRow('Phone', _phone!),
                  ],
                ),
              ),

              const SizedBox(height: AppConstants.spacingLG),

              // Password section
              Container(
                padding: const EdgeInsets.all(AppConstants.spacingLG),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.04),
                      blurRadius: 10,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.lock_outline_rounded,
                          color: AppColors.primary,
                          size: 20,
                        ),
                        const SizedBox(width: AppConstants.spacingSM),
                        Text(
                          'Create Password',
                          style: AppTextStyles.bodyMedium.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: AppConstants.spacingMD),

                    // Password field
                    CustomTextField(
                      controller: _passwordController,
                      label: 'Password',
                      hint: 'Enter a secure password',
                      obscureText: _obscurePassword,
                      suffixIcon: IconButton(
                        icon: Icon(
                          _obscurePassword
                              ? Icons.visibility_off_rounded
                              : Icons.visibility_rounded,
                        ),
                        onPressed: () {
                          setState(() {
                            _obscurePassword = !_obscurePassword;
                          });
                        },
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Password is required';
                        }
                        if (value.length < 8) {
                          return 'Password must be at least 8 characters';
                        }
                        return null;
                      },
                    ),

                    const SizedBox(height: AppConstants.spacingMD),

                    // Confirm password field
                    CustomTextField(
                      controller: _confirmPasswordController,
                      label: 'Confirm Password',
                      hint: 'Re-enter your password',
                      obscureText: _obscureConfirmPassword,
                      suffixIcon: IconButton(
                        icon: Icon(
                          _obscureConfirmPassword
                              ? Icons.visibility_off_rounded
                              : Icons.visibility_rounded,
                        ),
                        onPressed: () {
                          setState(() {
                            _obscureConfirmPassword = !_obscureConfirmPassword;
                          });
                        },
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please confirm your password';
                        }
                        if (value != _passwordController.text) {
                          return 'Passwords do not match';
                        }
                        return null;
                      },
                    ),
                  ],
                ),
              ),

              const SizedBox(height: AppConstants.spacingLG),

              // Complete signup button
              CustomButton(
                text: 'Complete Signup',
                onPressed: _isLoading ? null : _completeSignup,
                isLoading: _isLoading,
              ),

              const SizedBox(height: AppConstants.spacingLG),

              // Divider
              Row(
                children: [
                  Expanded(child: Divider(color: Colors.grey[300])),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppConstants.spacingMD,
                    ),
                    child: Text(
                      'OR',
                      style: TextStyle(
                        color: Colors.grey[500],
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  Expanded(child: Divider(color: Colors.grey[300])),
                ],
              ),

              const SizedBox(height: AppConstants.spacingLG),

              // Google Sign-In
              OutlinedButton.icon(
                onPressed: _isLoading ? null : _signUpWithGoogle,
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                    vertical: AppConstants.spacingMD,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  side: BorderSide(color: Colors.grey[300]!),
                ),
                icon: const Icon(Icons.g_mobiledata_rounded, size: 28),
                label: const Text(
                  'Continue with Google',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),

              const SizedBox(height: AppConstants.spacingMD),

              // Apple Sign-In (iOS only)
              if (Platform.isIOS)
                OutlinedButton.icon(
                  onPressed: _isLoading ? null : _signUpWithApple,
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                      vertical: AppConstants.spacingMD,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    side: BorderSide(color: Colors.grey[300]!),
                  ),
                  icon: const Icon(Icons.apple_rounded, size: 24),
                  label: const Text(
                    'Continue with Apple',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),

              const SizedBox(height: AppConstants.spacingLG),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppConstants.spacingMD),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 2,
            child: Text(
              label,
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 13,
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: Text(
              value,
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 14,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
