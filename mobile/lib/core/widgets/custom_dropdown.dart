import 'package:flutter/material.dart';
import '../constants/app_constants.dart';
import '../constants/app_colors.dart';

/// Custom dropdown widget that matches CustomTextField styling
/// This widget uses a controlled value approach where the parent maintains state
class CustomDropdown<T> extends StatefulWidget {
  final String label;
  final String? hint;
  final T? value;
  final List<DropdownMenuItem<T>> items;
  final void Function(T?)? onChanged;
  final String? Function(T?)? validator;
  final Widget? prefixIcon;

  const CustomDropdown({
    super.key,
    required this.label,
    this.hint,
    this.value,
    required this.items,
    this.onChanged,
    this.validator,
    this.prefixIcon,
  });

  @override
  State<CustomDropdown<T>> createState() => _CustomDropdownState<T>();
}

class _CustomDropdownState<T> extends State<CustomDropdown<T>> {
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

        // Dropdown field
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
          child: DropdownButtonFormField<T>(
            // ignore: deprecated_member_use
            value: widget.value,
            focusNode: _focusNode,
            items: widget.items,
            onChanged: widget.onChanged,
            validator: widget.validator,
            hint: widget.hint != null
                ? Text(
                    widget.hint!,
                    style: theme.textTheme.bodyLarge?.copyWith(
                      color: AppColors.gray500,
                    ),
                  )
                : null,
            icon: Icon(
              Icons.keyboard_arrow_down_rounded,
              color: AppColors.gray500,
            ),
            style: theme.textTheme.bodyLarge,
            decoration: InputDecoration(
              prefixIcon: widget.prefixIcon,
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
          ),
        ),
      ],
    );
  }
}
