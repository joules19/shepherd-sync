import 'package:flutter/material.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:intl_phone_field/phone_number.dart';
import '../constants/app_colors.dart';
import '../constants/app_constants.dart';

/// Custom phone input field with country code picker
/// Matches the styling of CustomTextField
class CustomPhoneField extends StatefulWidget {
  const CustomPhoneField({
    super.key,
    required this.label,
    this.hint,
    this.initialCountryCode = 'US',
    this.initialValue,
    this.onChanged,
    this.validator,
  });

  final String label;
  final String? hint;
  final String initialCountryCode;
  final String? initialValue;
  final Function(PhoneNumber)? onChanged;
  final String? Function(PhoneNumber?)? validator;

  @override
  State<CustomPhoneField> createState() => _CustomPhoneFieldState();
}

class _CustomPhoneFieldState extends State<CustomPhoneField> {
  final FocusNode _focusNode = FocusNode();
  bool _isFocused = false;

  @override
  void initState() {
    super.initState();
    _focusNode.addListener(_onFocusChange);
  }

  @override
  void dispose() {
    _focusNode.removeListener(_onFocusChange);
    _focusNode.dispose();
    super.dispose();
  }

  void _onFocusChange() {
    setState(() {
      _isFocused = _focusNode.hasFocus;
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Label - matches CustomTextField
        Text(
          widget.label,
          style: theme.textTheme.labelMedium?.copyWith(
            color: AppColors.textPrimaryLight,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: AppConstants.spacingSM),

        // Phone field with animated container
        AnimatedContainer(
          duration: AppConstants.animationFast,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(AppConstants.radiusMD),
            boxShadow: _isFocused
                ? [
                    BoxShadow(
                      color: AppColors.primary.withValues(alpha: 0.1),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ]
                : null,
          ),
          child: IntlPhoneField(
            focusNode: _focusNode,
            initialCountryCode: widget.initialCountryCode,
            initialValue: widget.initialValue,
            onChanged: widget.onChanged,
            validator: (phoneNumber) {
              if (widget.validator != null) {
                return widget.validator!(phoneNumber);
              }
              return null;
            },
            decoration: InputDecoration(
              hintText: widget.hint,
              hintStyle: theme.textTheme.bodyLarge?.copyWith(
                color: AppColors.gray500,
              ),
              filled: true,
              fillColor: theme.colorScheme.surface,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: AppConstants.spacingMD,
                vertical: AppConstants.spacingMD,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(AppConstants.radiusMD),
                borderSide: const BorderSide(color: AppColors.borderLight),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(AppConstants.radiusMD),
                borderSide: const BorderSide(color: AppColors.borderLight),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(AppConstants.radiusMD),
                borderSide: const BorderSide(
                  color: AppColors.primary,
                  width: 2,
                ),
              ),
              errorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(AppConstants.radiusMD),
                borderSide: const BorderSide(color: AppColors.error),
              ),
              focusedErrorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(AppConstants.radiusMD),
                borderSide: const BorderSide(
                  color: AppColors.error,
                  width: 2,
                ),
              ),
            ),
            style: theme.textTheme.bodyLarge,
            dropdownIcon: Icon(
              Icons.arrow_drop_down_rounded,
              color: AppColors.gray500,
            ),
            dropdownTextStyle: theme.textTheme.bodyLarge,
            flagsButtonPadding: const EdgeInsets.only(left: 12),
            showCountryFlag: true,
            showDropdownIcon: true,
          ),
        ),
      ],
    );
  }
}
