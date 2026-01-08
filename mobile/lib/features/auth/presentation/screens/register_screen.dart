import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/widgets/custom_text_field.dart';
import '../../../../core/widgets/custom_button.dart';
import '../providers/auth_state_provider.dart';

/// Beautiful multi-step registration screen for new organizations
class RegisterScreen extends ConsumerStatefulWidget {
  const RegisterScreen({super.key});

  @override
  ConsumerState<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends ConsumerState<RegisterScreen>
    with SingleTickerProviderStateMixin {
  final _formKeys = [
    GlobalKey<FormState>(), // Step 1
    GlobalKey<FormState>(), // Step 2
    GlobalKey<FormState>(), // Step 3
  ];

  // Controllers
  final _organizationNameController = TextEditingController();
  final _subdomainController = TextEditingController();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  late PageController _pageController;
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  int _currentStep = 0;

  @override
  void initState() {
    super.initState();

    _pageController = PageController();

    // Setup animations
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeIn),
    );

    // Start animation
    _animationController.forward();
  }

  @override
  void dispose() {
    _organizationNameController.dispose();
    _subdomainController.dispose();
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _pageController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  void _nextStep() {
    // Validate current step
    if (!_formKeys[_currentStep].currentState!.validate()) {
      return;
    }

    if (_currentStep < 2) {
      setState(() => _currentStep++);
      _pageController.animateToPage(
        _currentStep,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      _handleRegister();
    }
  }

  void _previousStep() {
    if (_currentStep > 0) {
      setState(() => _currentStep--);
      _pageController.animateToPage(
        _currentStep,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  Future<void> _handleRegister() async {
    // Clear any previous errors
    ref.read(authStateProvider.notifier).clearError();

    // Hide keyboard
    FocusScope.of(context).unfocus();

    // Perform registration
    await ref
        .read(authStateProvider.notifier)
        .register(
          organizationName: _organizationNameController.text.trim(),
          subdomain: _subdomainController.text.trim().toLowerCase(),
          firstName: _firstNameController.text.trim(),
          lastName: _lastNameController.text.trim(),
          email: _emailController.text.trim(),
          password: _passwordController.text,
          phone: _phoneController.text.trim().isEmpty
              ? null
              : _phoneController.text.trim(),
        );

    // Check for errors - ensure widget is still mounted
    if (!mounted) return;

    final authState = ref.read(authStateProvider);
    if (authState.error != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(authState.error!),
          backgroundColor: AppColors.error,
        ),
      );
    }

    // Navigation handled automatically by GoRouter based on auth state
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final authState = ref.watch(authStateProvider);

    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: _currentStep > 0
            ? IconButton(
                icon: const Icon(
                  Icons.arrow_back,
                  color: AppColors.textPrimaryLight,
                ),
                onPressed: authState.isLoading ? null : _previousStep,
              )
            : IconButton(
                icon: const Icon(
                  Icons.arrow_back,
                  color: AppColors.textPrimaryLight,
                ),
                onPressed: () => Navigator.of(context).pop(),
              ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Progress indicator
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: AppConstants.spacingLG,
              ),
              child: Row(
                children: List.generate(
                  3,
                  (index) => Expanded(
                    child: Container(
                      margin: EdgeInsets.only(
                        right: index < 2 ? AppConstants.spacingSM : 0,
                      ),
                      height: 4,
                      decoration: BoxDecoration(
                        color: index <= _currentStep
                            ? AppColors.primary
                            : AppColors.gray300,
                        borderRadius: BorderRadius.circular(
                          AppConstants.radiusSM,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),

            const SizedBox(height: AppConstants.spacingXL),

            // Content
            Expanded(
              child: FadeTransition(
                opacity: _fadeAnimation,
                child: PageView(
                  controller: _pageController,
                  physics: const NeverScrollableScrollPhysics(),
                  onPageChanged: (index) =>
                      setState(() => _currentStep = index),
                  children: [
                    _buildStep1(theme),
                    _buildStep2(theme),
                    _buildStep3(theme),
                  ],
                ),
              ),
            ),

            // Bottom button
            Padding(
              padding: const EdgeInsets.all(AppConstants.spacingLG),
              child: CustomButton(
                text: _currentStep < 2 ? 'Continue' : 'Create Account',
                onPressed: authState.isLoading ? null : _nextStep,
                isLoading: authState.isLoading,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Step 1: Organization Details
  Widget _buildStep1(ThemeData theme) {
    return SingleChildScrollView(
      padding: const EdgeInsets.only(
        left: AppConstants.spacingLG,
        right: AppConstants.spacingLG,
        top: 0,
        bottom: AppConstants.spacingLG,
      ),
      child: Form(
        key: _formKeys[0],
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Logo
            Center(
              child: Image.asset(
                'assets/images/shepherdsync-high-resolution-logo.png',
                width: 180,
                height: 180,
                fit: BoxFit.contain,
              ),
            ),

            // Title
            Text(
              'Organization Details',
              style: theme.textTheme.displayMedium?.copyWith(
                color: AppColors.textPrimaryLight,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: AppConstants.spacingSM),

            Text(
              'Tell us about your church or organization',
              style: theme.textTheme.bodyLarge?.copyWith(
                color: AppColors.textSecondaryLight,
              ),
            ),

            const SizedBox(height: AppConstants.spacingXL),

            // Organization Name
            CustomTextField(
              controller: _organizationNameController,
              label: 'Organization Name',
              hint: 'e.g., Grace Community Church',
              textCapitalization: TextCapitalization.words,
              prefixIcon: const Icon(
                Icons.business,
                color: AppColors.gray500,
                size: 20,
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your organization name';
                }
                if (value.length < 3) {
                  return 'Name must be at least 3 characters';
                }
                return null;
              },
            ),

            const SizedBox(height: AppConstants.spacingLG),

            // Subdomain
            CustomTextField(
              controller: _subdomainController,
              label: 'Subdomain',
              hint: 'gracechurch',
              keyboardType: TextInputType.text,
              prefixIcon: const Icon(
                Icons.link,
                color: AppColors.gray500,
                size: 20,
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter a subdomain';
                }
                if (value.length < 3) {
                  return 'Subdomain must be at least 3 characters';
                }
                // Only lowercase letters, numbers, and hyphens
                if (!RegExp(r'^[a-z0-9-]+$').hasMatch(value.toLowerCase())) {
                  return 'Only lowercase letters, numbers, and hyphens allowed';
                }
                return null;
              },
            ),

            const SizedBox(height: AppConstants.spacingSM),

            // Subdomain hint
            Container(
              padding: const EdgeInsets.all(AppConstants.spacingMD),
              decoration: BoxDecoration(
                color: AppColors.info.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(AppConstants.radiusMD),
                border: Border.all(
                  color: AppColors.info.withValues(alpha: 0.3),
                ),
              ),
              child: Row(
                children: [
                  const Icon(
                    Icons.info_outline,
                    color: AppColors.info,
                    size: 20,
                  ),
                  const SizedBox(width: AppConstants.spacingSM),
                  Expanded(
                    child: Text(
                      'Your subdomain will be used for your custom URL',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: AppColors.info,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: AppConstants.spacingXL),
          ],
        ),
      ),
    );
  }

  // Step 2: Admin User Details
  Widget _buildStep2(ThemeData theme) {
    return SingleChildScrollView(
      padding: const EdgeInsets.only(
        left: AppConstants.spacingLG,
        right: AppConstants.spacingLG,
        top: AppConstants.spacingSM,
        bottom: AppConstants.spacingLG,
      ),
      child: Form(
        key: _formKeys[1],
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Icon
            Center(
              child: Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  color: AppColors.secondary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(AppConstants.radiusLG),
                  border: Border.all(
                    color: AppColors.secondary.withValues(alpha: 0.3),
                    width: 2,
                  ),
                ),
                child: const Icon(
                  Icons.person,
                  size: 40,
                  color: AppColors.secondary,
                ),
              ),
            ),

            const SizedBox(height: AppConstants.spacingXL),

            // Title
            Text(
              'Your Details',
              style: theme.textTheme.displayMedium?.copyWith(
                color: AppColors.textPrimaryLight,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: AppConstants.spacingSM),

            Text(
              'You will be the main administrator',
              style: theme.textTheme.bodyLarge?.copyWith(
                color: AppColors.textSecondaryLight,
              ),
            ),

            const SizedBox(height: AppConstants.spacingXL),

            // First Name
            CustomTextField(
              controller: _firstNameController,
              label: 'First Name',
              hint: 'John',
              textCapitalization: TextCapitalization.words,
              prefixIcon: const Icon(
                Icons.person_outline,
                color: AppColors.gray500,
                size: 20,
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your first name';
                }
                return null;
              },
            ),

            const SizedBox(height: AppConstants.spacingLG),

            // Last Name
            CustomTextField(
              controller: _lastNameController,
              label: 'Last Name',
              hint: 'Doe',
              textCapitalization: TextCapitalization.words,
              prefixIcon: const Icon(
                Icons.person_outline,
                color: AppColors.gray500,
                size: 20,
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your last name';
                }
                return null;
              },
            ),

            const SizedBox(height: AppConstants.spacingLG),

            // Email
            CustomTextField(
              controller: _emailController,
              label: 'Email Address',
              hint: 'admin@church.com',
              keyboardType: TextInputType.emailAddress,
              prefixIcon: const Icon(
                Icons.email_outlined,
                color: AppColors.gray500,
                size: 20,
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your email';
                }
                if (!value.contains('@') || !value.contains('.')) {
                  return 'Please enter a valid email';
                }
                return null;
              },
            ),

            const SizedBox(height: AppConstants.spacingLG),

            // Phone (Optional)
            CustomTextField(
              controller: _phoneController,
              label: 'Phone Number (Optional)',
              hint: '+1 (555) 123-4567',
              keyboardType: TextInputType.phone,
              prefixIcon: const Icon(
                Icons.phone_outlined,
                color: AppColors.gray500,
                size: 20,
              ),
            ),

            const SizedBox(height: AppConstants.spacingXL),
          ],
        ),
      ),
    );
  }

  // Step 3: Password Setup
  Widget _buildStep3(ThemeData theme) {
    return SingleChildScrollView(
      padding: const EdgeInsets.only(
        left: AppConstants.spacingLG,
        right: AppConstants.spacingLG,
        top: AppConstants.spacingSM,
        bottom: AppConstants.spacingLG,
      ),
      child: Form(
        key: _formKeys[2],
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Icon
            Center(
              child: Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  color: AppColors.success.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(AppConstants.radiusLG),
                  border: Border.all(
                    color: AppColors.success.withValues(alpha: 0.3),
                    width: 2,
                  ),
                ),
                child: const Icon(
                  Icons.lock_outline,
                  size: 40,
                  color: AppColors.success,
                ),
              ),
            ),

            const SizedBox(height: AppConstants.spacingXL),

            // Title
            Text(
              'Secure Your Account',
              style: theme.textTheme.displayMedium?.copyWith(
                color: AppColors.textPrimaryLight,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: AppConstants.spacingSM),

            Text(
              'Create a strong password to protect your data',
              style: theme.textTheme.bodyLarge?.copyWith(
                color: AppColors.textSecondaryLight,
              ),
            ),

            const SizedBox(height: AppConstants.spacingXL),

            // Password
            CustomTextField(
              controller: _passwordController,
              label: 'Password',
              hint: 'Enter a strong password',
              obscureText: true,
              prefixIcon: const Icon(
                Icons.lock_outline,
                color: AppColors.gray500,
                size: 20,
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter a password';
                }
                if (value.length < 8) {
                  return 'Password must be at least 8 characters';
                }
                return null;
              },
            ),

            const SizedBox(height: AppConstants.spacingLG),

            // Confirm Password
            CustomTextField(
              controller: _confirmPasswordController,
              label: 'Confirm Password',
              hint: 'Re-enter your password',
              obscureText: true,
              prefixIcon: const Icon(
                Icons.lock_outline,
                color: AppColors.gray500,
                size: 20,
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

            const SizedBox(height: AppConstants.spacingMD),

            // Password requirements
            Container(
              padding: const EdgeInsets.all(AppConstants.spacingMD),
              decoration: BoxDecoration(
                color: AppColors.gray100,
                borderRadius: BorderRadius.circular(AppConstants.radiusMD),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Password Requirements:',
                    style: theme.textTheme.labelMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimaryLight,
                    ),
                  ),
                  const SizedBox(height: AppConstants.spacingSM),
                  _buildRequirement(
                    theme,
                    'At least 8 characters long',
                    _passwordController.text.length >= 8,
                  ),
                  _buildRequirement(
                    theme,
                    'Contains both upper and lowercase letters',
                    _passwordController.text.contains(RegExp(r'[A-Z]')) &&
                        _passwordController.text.contains(RegExp(r'[a-z]')),
                  ),
                  _buildRequirement(
                    theme,
                    'Contains at least one number',
                    _passwordController.text.contains(RegExp(r'[0-9]')),
                  ),
                ],
              ),
            ),

            const SizedBox(height: AppConstants.spacingXL),

            // Terms and conditions
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(
                  Icons.check_circle_outline,
                  color: AppColors.primary,
                  size: 20,
                ),
                const SizedBox(width: AppConstants.spacingSM),
                Expanded(
                  child: Text(
                    'By creating an account, you agree to our Terms of Service and Privacy Policy',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: AppColors.textSecondaryLight,
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: AppConstants.spacingXL),
          ],
        ),
      ),
    );
  }

  Widget _buildRequirement(ThemeData theme, String text, bool isMet) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppConstants.spacingXS),
      child: Row(
        children: [
          Icon(
            isMet ? Icons.check_circle : Icons.circle_outlined,
            size: 16,
            color: isMet ? AppColors.success : AppColors.gray400,
          ),
          const SizedBox(width: AppConstants.spacingSM),
          Expanded(
            child: Text(
              text,
              style: theme.textTheme.bodySmall?.copyWith(
                color: isMet ? AppColors.success : AppColors.gray500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
