import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../core/widgets/custom_button.dart';
import '../../data/providers/auth_providers.dart';
import 'invite_signup_screen.dart';

/// Screen for entering 6-digit invite code
/// Alternative to clicking deep link
class InviteCodeScreen extends ConsumerStatefulWidget {
  const InviteCodeScreen({super.key});

  @override
  ConsumerState<InviteCodeScreen> createState() => _InviteCodeScreenState();
}

class _InviteCodeScreenState extends ConsumerState<InviteCodeScreen> {
  final _codeController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;

  @override
  void dispose() {
    _codeController.dispose();
    super.dispose();
  }

  Future<void> _validateCode() async {
    if (!_formKey.currentState!.validate()) return;

    final code = _codeController.text.trim().toUpperCase();

    setState(() => _isLoading = true);

    try {
      // Validate the invite code (backend accepts both token and code)
      final repository = ref.read(authRepositoryProvider);
      final result = await repository.validateInvite(code);

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

            // Navigate to invite signup screen with the code as token
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => InviteSignupScreen(inviteToken: code),
              ),
            );
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
      backgroundColor: AppColors.backgroundLight,
      appBar: AppBar(
        title: const Text(
          'Enter Invite Code',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        elevation: 0,
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppConstants.spacingLG),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: AppConstants.spacingXL),

                // Icon
                Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withValues(alpha: 0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.key_rounded,
                    size: 64,
                    color: AppColors.primary,
                  ),
                ),

                const SizedBox(height: AppConstants.spacingXL),

                // Title
                Text(
                  'Have an Invite Code?',
                  style: AppTextStyles.headlineMedium.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),

                const SizedBox(height: AppConstants.spacingSM),

                // Subtitle
                Text(
                  'Enter the 6-digit code from your invite email or SMS',
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: Colors.grey[600],
                  ),
                  textAlign: TextAlign.center,
                ),

                const SizedBox(height: AppConstants.spacingXL),

                // Code input
                TextFormField(
                  controller: _codeController,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 8,
                  ),
                  decoration: InputDecoration(
                    hintText: 'ABC123',
                    hintStyle: TextStyle(
                      color: Colors.grey[400],
                      letterSpacing: 8,
                    ),
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: BorderSide(color: Colors.grey[300]!),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: BorderSide(color: Colors.grey[300]!),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: BorderSide(color: AppColors.primary, width: 2),
                    ),
                    errorBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: const BorderSide(color: Colors.red),
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      vertical: 24,
                      horizontal: 16,
                    ),
                  ),
                  inputFormatters: [
                    LengthLimitingTextInputFormatter(6),
                    FilteringTextInputFormatter.allow(RegExp(r'[A-Za-z0-9]')),
                    UpperCaseTextFormatter(),
                  ],
                  keyboardType: TextInputType.text,
                  textCapitalization: TextCapitalization.characters,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Please enter your invite code';
                    }
                    if (value.trim().length != 6) {
                      return 'Code must be 6 characters';
                    }
                    return null;
                  },
                ),

                const SizedBox(height: AppConstants.spacingXL),

                // Submit button
                CustomButton(
                  text: 'Continue',
                  onPressed: _isLoading ? null : _validateCode,
                  isLoading: _isLoading,
                ),

                const SizedBox(height: AppConstants.spacingLG),

                // Help text
                Container(
                  padding: const EdgeInsets.all(AppConstants.spacingMD),
                  decoration: BoxDecoration(
                    color: Colors.blue.withValues(alpha: 0.05),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: Colors.blue.withValues(alpha: 0.1),
                    ),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.info_outline_rounded,
                        color: Colors.blue[700],
                        size: 20,
                      ),
                      const SizedBox(width: AppConstants.spacingSM),
                      Expanded(
                        child: Text(
                          'You can find your code in the invite email or SMS from your church.',
                          style: AppTextStyles.bodySmall.copyWith(
                            color: Colors.blue[700],
                            fontSize: 13,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Text formatter to convert input to uppercase
class UpperCaseTextFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    return TextEditingValue(
      text: newValue.text.toUpperCase(),
      selection: newValue.selection,
    );
  }
}
