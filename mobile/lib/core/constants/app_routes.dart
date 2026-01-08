/// Application route constants
///
/// All routes are defined here to avoid magic strings throughout the app.
/// Use with GoRouter: context.go(AppRoutes.dashboard)
class AppRoutes {
  // Private constructor to prevent instantiation
  AppRoutes._();

  // ========================================
  // AUTHENTICATION ROUTES
  // ========================================

  /// Splash screen - shown while checking auth status
  static const String splash = '/';

  /// Login screen - email/password authentication
  static const String login = '/login';

  /// Registration screen - new organization signup
  static const String register = '/register';

  /// Forgot password screen - password reset
  static const String forgotPassword = '/forgot-password';

  /// Reset password screen - set new password with token
  static const String resetPassword = '/reset-password';

  // ========================================
  // MAIN APP ROUTES
  // ========================================

  /// Dashboard - main landing page after login
  static const String dashboard = '/dashboard';

  /// Events listing
  static const String events = '/events';

  /// Event detail - requires eventId parameter
  static String eventDetail(String eventId) => '/events/$eventId';

  /// Event registration - requires eventId parameter
  static String eventRegister(String eventId) => '/events/$eventId/register';

  /// My event registrations
  static const String myEvents = '/my-events';

  /// Event QR ticket - requires registrationId parameter
  static String eventTicket(String registrationId) =>
      '/my-events/$registrationId/ticket';

  // ========================================
  // GIVING ROUTES
  // ========================================

  /// Giving/Donation screen
  static const String giving = '/giving';

  /// Donation history
  static const String donationHistory = '/giving/history';

  /// Donation receipt - requires donationId parameter
  static String donationReceipt(String donationId) =>
      '/giving/history/$donationId';

  /// Payment methods management
  static const String paymentMethods = '/giving/payment-methods';

  /// Recurring donations management
  static const String recurringDonations = '/giving/recurring';

  // ========================================
  // ATTENDANCE ROUTES (USHER)
  // ========================================

  /// QR scanner for attendance
  static const String attendanceScanner = '/attendance/scanner';

  /// Manual check-in
  static const String attendanceManual = '/attendance/manual';

  /// Offline queue
  static const String attendanceQueue = '/attendance/queue';

  /// Attendance statistics
  static const String attendanceStats = '/attendance/stats';

  // ========================================
  // MEDIA ROUTES
  // ========================================

  /// Media gallery
  static const String media = '/media';

  /// Media detail/lightbox - requires mediaId parameter
  static String mediaDetail(String mediaId) => '/media/$mediaId';

  /// Upload media (Admin/Pastor only)
  static const String mediaUpload = '/media/upload';

  // ========================================
  // PROFILE & SETTINGS ROUTES
  // ========================================

  /// User profile
  static const String profile = '/profile';

  /// Edit profile
  static const String editProfile = '/profile/edit';

  /// Children management (Parents only)
  static const String children = '/profile/children';

  /// Add/Edit child
  static String editChild(String? childId) =>
      childId == null ? '/profile/children/add' : '/profile/children/$childId';

  /// Settings
  static const String settings = '/settings';

  /// Notification settings
  static const String notificationSettings = '/settings/notifications';

  // ========================================
  // COMMUNICATIONS ROUTES
  // ========================================

  /// Announcements list
  static const String announcements = '/announcements';

  /// Announcement detail - requires announcementId parameter
  static String announcementDetail(String announcementId) =>
      '/announcements/$announcementId';

  /// Notification center
  static const String notifications = '/notifications';

  // ========================================
  // ANALYTICS ROUTES (ADMIN)
  // ========================================

  /// Analytics dashboard
  static const String analytics = '/analytics';

  /// Giving reports
  static const String analyticsGiving = '/analytics/giving';

  /// Attendance reports
  static const String analyticsAttendance = '/analytics/attendance';

  /// Member engagement
  static const String analyticsEngagement = '/analytics/engagement';

  // ========================================
  // ADMIN ROUTES
  // ========================================

  /// Member management
  static const String members = '/admin/members';

  /// Add/Edit member
  static String editMember(String? memberId) =>
      memberId == null ? '/admin/members/add' : '/admin/members/$memberId';

  /// Organization settings
  static const String organizationSettings = '/admin/organization';

  // ========================================
  // ONBOARDING ROUTES
  // ========================================

  /// Onboarding screens (first time users)
  static const String onboarding = '/onboarding';
}
