import 'package:flutter/material.dart';

/// Premium color palette for Shepherd Sync
/// Designed for church management with elegance and clarity
class AppColors {
  AppColors._(); // Private constructor to prevent instantiation

  // ========================================
  // PRIMARY COLORS (Church Purple & Gold)
  // ========================================
  /// FF6C4AB6
  /// Deep Purple - Primary brand color
  static const Color primary = Color(0xFF713784);
  static const Color primaryDark = Color(0xFF4A338A);
  static const Color primaryLight = Color(0xFF8B6FCC);

  /// Gold - Secondary accent color
  static const Color secondary = Color(0xFFFFD700);
  static const Color secondaryDark = Color(0xFFCC9900);
  static const Color secondaryLight = Color(0xFFFFE44D);

  // ========================================
  // BACKGROUND COLORS
  // ========================================

  // Light Mode
  static const Color backgroundLight = Color(0xFFF8F9FA);
  static const Color surfaceLight = Color(0xFFFFFFFF);
  static const Color cardLight = Color(0xFFFFFFFF);

  // Dark Mode
  static const Color backgroundDark = Color(0xFF121212);
  static const Color surfaceDark = Color(0xFF1E1E1E);
  static const Color cardDark = Color(0xFF2C2C2C);

  // ========================================
  // TEXT COLORS
  // ========================================

  // Light Mode
  static const Color textPrimaryLight = Color(0xFF1A1A1A);
  static const Color textSecondaryLight = Color(0xFF666666);
  static const Color textTertiaryLight = Color(0xFF999999);

  // Dark Mode
  static const Color textPrimaryDark = Color(0xFFE5E5E5);
  static const Color textSecondaryDark = Color(0xFFB3B3B3);
  static const Color textTertiaryDark = Color(0xFF808080);

  // ========================================
  // SEMANTIC COLORS
  // ========================================

  /// Success color (green) - for positive actions
  static const Color success = Color(0xFF28A745);
  static const Color successDark = Color(0xFF1E7A2F);
  static const Color successLight = Color(0xFF5FD67F);

  /// Error color (red) - for destructive actions
  static const Color error = Color(0xFFDC3545);
  static const Color errorDark = Color(0xFFA82733);
  static const Color errorLight = Color(0xFFE66671);

  /// Warning color (orange) - for cautionary messages
  static const Color warning = Color(0xFFFFC107);
  static const Color warningDark = Color(0xFFCC9A06);
  static const Color warningLight = Color(0xFFFFD54F);

  /// Info color (blue) - for informational messages
  static const Color info = Color(0xFF17A2B8);
  static const Color infoDark = Color(0xFF117A8B);
  static const Color infoLight = Color(0xFF58C5D7);

  // ========================================
  // FUNCTIONAL COLORS
  // ========================================

  /// Donation/Giving colors
  static const Color giving = Color(0xFF713784); // Primary purple
  static const Color givingBackground = Color(0xFFF3F0FF);

  /// Events colors
  static const Color events = Color(0xFFFF6B6B);
  static const Color eventsBackground = Color(0xFFFFEDED);

  /// Attendance colors
  static const Color attendance = Color(0xFF4ECDC4);
  static const Color attendanceBackground = Color(0xFFE8F9F7);

  /// Media colors
  static const Color media = Color(0xFFFFBE0B);
  static const Color mediaBackground = Color(0xFFFFF8E1);

  // ========================================
  // NEUTRAL COLORS
  // ========================================

  static const Color white = Color(0xFFFFFFFF);
  static const Color black = Color(0xFF000000);

  /// Gray scale
  static const Color gray50 = Color(0xFFFAFAFA);
  static const Color gray100 = Color(0xFFF5F5F5);
  static const Color gray200 = Color(0xFFEEEEEE);
  static const Color gray300 = Color(0xFFE0E0E0);
  static const Color gray400 = Color(0xFFBDBDBD);
  static const Color gray500 = Color(0xFF9E9E9E);
  static const Color gray600 = Color(0xFF757575);
  static const Color gray700 = Color(0xFF616161);
  static const Color gray800 = Color(0xFF424242);
  static const Color gray900 = Color(0xFF212121);

  // ========================================
  // SPECIAL EFFECTS
  // ========================================

  /// Shimmer loading colors
  static const Color shimmerBase = Color(0xFFE0E0E0);
  static const Color shimmerHighlight = Color(0xFFF5F5F5);
  static const Color shimmerBaseDark = Color(0xFF2C2C2C);
  static const Color shimmerHighlightDark = Color(0xFF3E3E3E);

  /// Overlay colors
  static const Color overlayLight = Color(0x33000000); // 20% black
  static const Color overlayDark = Color(0x66000000); // 40% black
  static const Color dialogBarrier = Color(0x80000000); // 50% black

  /// Divider colors
  static const Color dividerLight = Color(0xFFE0E0E0);
  static const Color dividerDark = Color(0xFF3E3E3E);

  /// Border colors
  static const Color borderLight = Color(0xFFE0E0E0);
  static const Color borderDark = Color(0xFF3E3E3E);

  // ========================================
  // GRADIENT COLORS
  // ========================================

  /// Primary gradient (Purple to Light Purple)
  static const Gradient primaryGradient = LinearGradient(
    colors: [primary, primaryLight],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  /// Secondary gradient (Gold to Light Gold)
  static const Gradient secondaryGradient = LinearGradient(
    colors: [secondaryDark, secondary],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  /// Success gradient
  static const Gradient successGradient = LinearGradient(
    colors: [successDark, success],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  /// Giving gradient (Church themed)
  static const Gradient givingGradient = LinearGradient(
    colors: [primary, Color(0xFF8B6FCC), secondary],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}
