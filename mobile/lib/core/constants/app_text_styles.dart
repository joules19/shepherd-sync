import 'package:flutter/material.dart';
import 'app_colors.dart';

/// Premium typography system for Shepherd Sync
/// Using Montserrat font for clean, modern typography
class AppTextStyles {
  AppTextStyles._(); // Private constructor

  // Font families
  static const String _fontFamilyDisplay = 'Montserrat';
  static const String _fontFamilyText = 'Montserrat';

  // ========================================
  // DISPLAY STYLES (Large headings)
  // ========================================

  /// Display Large - For hero sections
  /// 32px, Bold, -0.5 letter spacing
  static const TextStyle displayLarge = TextStyle(
    fontFamily: _fontFamilyDisplay,
    fontSize: 32,
    fontWeight: FontWeight.w700,
    letterSpacing: -0.5,
    height: 1.2,
  );

  /// Display Medium - For page titles
  /// 24px, SemiBold
  static const TextStyle displayMedium = TextStyle(
    fontFamily: _fontFamilyDisplay,
    fontSize: 24,
    fontWeight: FontWeight.w600,
    height: 1.3,
  );

  /// Display Small - For section titles
  /// 20px, SemiBold
  static const TextStyle displaySmall = TextStyle(
    fontFamily: _fontFamilyDisplay,
    fontSize: 20,
    fontWeight: FontWeight.w600,
    height: 1.4,
  );

  // ========================================
  // HEADLINE STYLES
  // ========================================

  /// Headline Large - For card titles
  /// 18px, SemiBold
  static const TextStyle headlineLarge = TextStyle(
    fontFamily: _fontFamilyText,
    fontSize: 18,
    fontWeight: FontWeight.w600,
    height: 1.4,
  );

  /// Headline Medium - For subsection headers
  /// 16px, SemiBold
  static const TextStyle headlineMedium = TextStyle(
    fontFamily: _fontFamilyText,
    fontSize: 16,
    fontWeight: FontWeight.w600,
    height: 1.4,
  );

  /// Headline Small - For list item headers
  /// 14px, SemiBold
  static const TextStyle headlineSmall = TextStyle(
    fontFamily: _fontFamilyText,
    fontSize: 14,
    fontWeight: FontWeight.w600,
    height: 1.4,
  );

  // ========================================
  // BODY STYLES
  // ========================================

  /// Body Large - For primary content
  /// 16px, Regular, line height 1.5
  static const TextStyle bodyLarge = TextStyle(
    fontFamily: _fontFamilyText,
    fontSize: 16,
    fontWeight: FontWeight.w400,
    height: 1.5,
  );

  /// Body Medium - For secondary content
  /// 14px, Regular, line height 1.5
  static const TextStyle bodyMedium = TextStyle(
    fontFamily: _fontFamilyText,
    fontSize: 14,
    fontWeight: FontWeight.w400,
    height: 1.5,
  );

  /// Body Small - For tertiary content
  /// 12px, Regular, line height 1.5
  static const TextStyle bodySmall = TextStyle(
    fontFamily: _fontFamilyText,
    fontSize: 12,
    fontWeight: FontWeight.w400,
    height: 1.5,
  );

  // ========================================
  // LABEL STYLES
  // ========================================

  /// Label Large - For button text
  /// 16px, Medium
  static const TextStyle labelLarge = TextStyle(
    fontFamily: _fontFamilyText,
    fontSize: 16,
    fontWeight: FontWeight.w500,
    letterSpacing: 0.1,
  );

  /// Label Medium - For tab labels
  /// 14px, Medium
  static const TextStyle labelMedium = TextStyle(
    fontFamily: _fontFamilyText,
    fontSize: 14,
    fontWeight: FontWeight.w500,
    letterSpacing: 0.1,
  );

  /// Label Small - For small buttons
  /// 12px, Medium
  static const TextStyle labelSmall = TextStyle(
    fontFamily: _fontFamilyText,
    fontSize: 12,
    fontWeight: FontWeight.w500,
    letterSpacing: 0.1,
  );

  // ========================================
  // CAPTION STYLES
  // ========================================

  /// Caption - For hints and metadata
  /// 12px, Regular, opacity 0.6
  static TextStyle caption = TextStyle(
    fontFamily: _fontFamilyText,
    fontSize: 12,
    fontWeight: FontWeight.w400,
    color: AppColors.textSecondaryLight.withValues(alpha: 0.6),
  );

  /// Caption Bold - For emphasized captions
  /// 12px, Medium
  static const TextStyle captionBold = TextStyle(
    fontFamily: _fontFamilyText,
    fontSize: 12,
    fontWeight: FontWeight.w500,
  );

  /// Overline - For category labels
  /// 10px, Medium, uppercase, letter spacing 1.5
  static const TextStyle overline = TextStyle(
    fontFamily: _fontFamilyText,
    fontSize: 10,
    fontWeight: FontWeight.w500,
    letterSpacing: 1.5,
  );

  // ========================================
  // SPECIALIZED STYLES
  // ========================================

  /// Button Text - For primary buttons
  static const TextStyle button = TextStyle(
    fontFamily: _fontFamilyText,
    fontSize: 16,
    fontWeight: FontWeight.w600,
    letterSpacing: 0.5,
  );

  /// Link Text - For clickable links
  static const TextStyle link = TextStyle(
    fontFamily: _fontFamilyText,
    fontSize: 14,
    fontWeight: FontWeight.w500,
    color: AppColors.primary,
    decoration: TextDecoration.underline,
  );

  /// Input Text - For form fields
  static const TextStyle input = TextStyle(
    fontFamily: _fontFamilyText,
    fontSize: 16,
    fontWeight: FontWeight.w400,
    height: 1.5,
  );

  /// Input Hint - For placeholder text
  static TextStyle inputHint = TextStyle(
    fontFamily: _fontFamilyText,
    fontSize: 16,
    fontWeight: FontWeight.w400,
    color: AppColors.textSecondaryLight.withValues(alpha: 0.5),
  );

  /// Input Error - For validation messages
  static const TextStyle inputError = TextStyle(
    fontFamily: _fontFamilyText,
    fontSize: 12,
    fontWeight: FontWeight.w400,
    color: AppColors.error,
  );

  /// Tab Label - For navigation tabs
  static const TextStyle tabLabel = TextStyle(
    fontFamily: _fontFamilyText,
    fontSize: 14,
    fontWeight: FontWeight.w600,
    letterSpacing: 0.2,
  );

  /// App Bar Title - For navigation bar titles
  static const TextStyle appBarTitle = TextStyle(
    fontFamily: _fontFamilyDisplay,
    fontSize: 18,
    fontWeight: FontWeight.w600,
  );

  /// Navigation Rail Label - For side navigation
  static const TextStyle navigationRailLabel = TextStyle(
    fontFamily: _fontFamilyText,
    fontSize: 12,
    fontWeight: FontWeight.w500,
  );

  /// Chip Label - For filter chips
  static const TextStyle chipLabel = TextStyle(
    fontFamily: _fontFamilyText,
    fontSize: 13,
    fontWeight: FontWeight.w500,
  );

  /// Badge - For notification badges
  static const TextStyle badge = TextStyle(
    fontFamily: _fontFamilyText,
    fontSize: 10,
    fontWeight: FontWeight.w700,
    color: AppColors.white,
  );

  /// Amount Large - For donation amounts
  static const TextStyle amountLarge = TextStyle(
    fontFamily: _fontFamilyDisplay,
    fontSize: 48,
    fontWeight: FontWeight.w700,
    letterSpacing: -1.0,
  );

  /// Amount Medium - For summary cards
  static const TextStyle amountMedium = TextStyle(
    fontFamily: _fontFamilyDisplay,
    fontSize: 32,
    fontWeight: FontWeight.w700,
    letterSpacing: -0.5,
  );

  /// Amount Small - For list items
  static const TextStyle amountSmall = TextStyle(
    fontFamily: _fontFamilyDisplay,
    fontSize: 20,
    fontWeight: FontWeight.w600,
  );

  /// Stat Value - For statistics
  static const TextStyle statValue = TextStyle(
    fontFamily: _fontFamilyDisplay,
    fontSize: 28,
    fontWeight: FontWeight.w700,
  );

  /// Stat Label - For stat labels
  static const TextStyle statLabel = TextStyle(
    fontFamily: _fontFamilyText,
    fontSize: 12,
    fontWeight: FontWeight.w500,
    color: AppColors.textSecondaryLight,
  );
}
