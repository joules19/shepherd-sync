/// Application-wide constants for Shepherd Sync
class AppConstants {
  AppConstants._(); // Private constructor

  // ========================================
  // APP INFORMATION
  // ========================================

  static const String appName = 'Shepherd Sync';
  static const String appTagline = 'Empowering Churches, Connecting Communities';
  static const String appVersion = '1.0.0';

  // ========================================
  // API CONFIGURATION
  // ========================================

  /// Base URL for the API (will be overridden by .env)
  static const String apiBaseUrl = 'http://localhost:3000/api/v1';

  /// API Timeouts
  static const Duration apiConnectTimeout = Duration(seconds: 30);
  static const Duration apiReceiveTimeout = Duration(seconds: 60);

  // ========================================
  // STORAGE KEYS
  // ========================================

  /// Secure storage keys (for FlutterSecureStorage)
  static const String keyAccessToken = 'access_token';
  static const String keyRefreshToken = 'refresh_token';
  static const String keyUserId = 'user_id';
  static const String keyOrganizationId = 'organization_id';
  static const String keyUserRole = 'user_role';

  /// Hive box names
  static const String hiveBoxPreferences = 'preferences';
  static const String hiveBoxCache = 'cache';
  static const String hiveBoxOfflineQueue = 'offline_queue';

  /// Preference keys
  static const String keyThemeMode = 'theme_mode';
  static const String keyLanguage = 'language';
  static const String keyBiometricEnabled = 'biometric_enabled';
  static const String keyNotificationsEnabled = 'notifications_enabled';
  static const String keyAutoSyncEnabled = 'auto_sync_enabled';

  // ========================================
  // UI CONSTANTS
  // ========================================

  /// Spacing (8dp grid system)
  static const double spacingXS = 4.0;
  static const double spacingSM = 8.0;
  static const double spacingMD = 16.0;
  static const double spacingLG = 24.0;
  static const double spacingXL = 32.0;
  static const double spacingXXL = 48.0;

  /// Border Radius
  static const double radiusXS = 4.0;
  static const double radiusSM = 8.0;
  static const double radiusMD = 12.0;
  static const double radiusLG = 16.0;
  static const double radiusXL = 20.0;
  static const double radiusFull = 999.0;

  /// Icon Sizes
  static const double iconSizeXS = 16.0;
  static const double iconSizeSM = 20.0;
  static const double iconSizeMD = 24.0;
  static const double iconSizeLG = 32.0;
  static const double iconSizeXL = 48.0;

  /// Button Heights
  static const double buttonHeightSM = 36.0;
  static const double buttonHeightMD = 48.0;
  static const double buttonHeightLG = 56.0;

  /// App Bar Height
  static const double appBarHeight = 56.0;

  /// Bottom Nav Bar Height
  static const double bottomNavBarHeight = 60.0;

  /// Card Elevation
  static const double elevationNone = 0.0;
  static const double elevationSM = 2.0;
  static const double elevationMD = 4.0;
  static const double elevationLG = 8.0;
  static const double elevationXL = 16.0;

  // ========================================
  // ANIMATION DURATIONS
  // ========================================

  static const Duration animationFast = Duration(milliseconds: 150);
  static const Duration animationNormal = Duration(milliseconds: 300);
  static const Duration animationSlow = Duration(milliseconds: 500);

  // ========================================
  // PAGINATION
  // ========================================

  static const int defaultPageSize = 20;
  static const int maxPageSize = 100;

  // ========================================
  // FILE UPLOAD LIMITS
  // ========================================

  /// 10MB for images
  static const int maxImageSize = 10 * 1024 * 1024;

  /// 100MB for videos
  static const int maxVideoSize = 100 * 1024 * 1024;

  /// Allowed image extensions
  static const List<String> allowedImageExtensions = [
    'jpg',
    'jpeg',
    'png',
    'gif',
    'webp'
  ];

  /// Allowed video extensions
  static const List<String> allowedVideoExtensions = [
    'mp4',
    'mov',
    'avi',
    'mkv'
  ];

  // ========================================
  // QR CODE CONFIGURATION
  // ========================================

  static const int qrCodeSize = 300;
  static const int qrCodePadding = 20;

  // ========================================
  // SESSION CONFIGURATION
  // ========================================

  /// Session timeout (30 minutes of inactivity)
  static const Duration sessionTimeout = Duration(minutes: 30);

  /// Token refresh threshold (refresh when 5 minutes remaining)
  static const Duration tokenRefreshThreshold = Duration(minutes: 5);

  // ========================================
  // OFFLINE SYNC
  // ========================================

  /// Max offline queue size
  static const int maxOfflineQueueSize = 1000;

  /// Sync retry attempts
  static const int syncRetryAttempts = 3;

  /// Sync retry delay
  static const Duration syncRetryDelay = Duration(seconds: 5);

  // ========================================
  // NOTIFICATIONS
  // ========================================

  /// Notification channel IDs (Android)
  static const String notificationChannelIdGeneral = 'general';
  static const String notificationChannelIdEvents = 'events';
  static const String notificationChannelIdGiving = 'giving';
  static const String notificationChannelIdAnnouncements = 'announcements';

  // ========================================
  // VALIDATION RULES
  // ========================================

  /// Password minimum length
  static const int passwordMinLength = 8;

  /// Password maximum length
  static const int passwordMaxLength = 128;

  /// Name minimum length
  static const int nameMinLength = 2;

  /// Name maximum length
  static const int nameMaxLength = 50;

  // ========================================
  // SUPPORTED LANGUAGES
  // ========================================

  static const List<String> supportedLanguages = ['en'];

  // ========================================
  // DATE FORMATS
  // ========================================

  static const String dateFormatShort = 'MMM d, y'; // Jan 8, 2026
  static const String dateFormatLong = 'MMMM d, y'; // January 8, 2026
  static const String dateFormatFull = 'EEEE, MMMM d, y'; // Wednesday, January 8, 2026
  static const String timeFormat = 'h:mm a'; // 2:30 PM
  static const String dateTimeFormat = 'MMM d, y • h:mm a'; // Jan 8, 2026 • 2:30 PM

  // ========================================
  // CURRENCY
  // ========================================

  static const String currencySymbol = '\$';
  static const String currencyCode = 'USD';
  static const int currencyDecimalPlaces = 2;

  // ========================================
  // ERROR MESSAGES
  // ========================================

  static const String errorGeneric = 'Something went wrong. Please try again.';
  static const String errorNetwork = 'No internet connection. Please check your network.';
  static const String errorTimeout = 'Request timed out. Please try again.';
  static const String errorUnauthorized = 'Session expired. Please login again.';
  static const String errorForbidden = 'You don\'t have permission to perform this action.';
  static const String errorNotFound = 'Resource not found.';
  static const String errorServerError = 'Server error. Please try again later.';

  // ========================================
  // SUCCESS MESSAGES
  // ========================================

  static const String successGeneric = 'Success!';
  static const String successSaved = 'Saved successfully';
  static const String successDeleted = 'Deleted successfully';
  static const String successUpdated = 'Updated successfully';

  // ========================================
  // STRIPE CONFIGURATION
  // ========================================

  /// Stripe publishable key (will be overridden by .env)
  static const String stripePublishableKey = '';

  /// Stripe merchant identifier (iOS)
  static const String stripeMerchantIdentifier = 'merchant.com.shepherdsync';

  // ========================================
  // EXTERNAL LINKS
  // ========================================

  static const String websiteUrl = 'https://shepherdsync.com';
  static const String termsUrl = 'https://shepherdsync.com/terms';
  static const String privacyUrl = 'https://shepherdsync.com/privacy';
  static const String supportEmail = 'support@shepherdsync.com';

  // ========================================
  // SOCIAL MEDIA
  // ========================================

  static const String twitterHandle = '@shepherdsync';
  static const String facebookPage = 'shepherdsync';
  static const String instagramHandle = '@shepherdsync';
}
