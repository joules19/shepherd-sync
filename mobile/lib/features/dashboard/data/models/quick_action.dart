import 'package:flutter/material.dart';

/// Quick action card for dashboard
class QuickAction {
  final String title;
  final String subtitle;
  final IconData icon;
  final Color color;
  final String route;

  const QuickAction({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.color,
    required this.route,
  });
}

/// Quick actions based on user role
class QuickActions {
  QuickActions._();

  /// Admin quick actions
  static const List<QuickAction> admin = [
    QuickAction(
      title: 'Members',
      subtitle: 'Manage church members',
      icon: Icons.people_rounded,
      color: Color(0xFF713784), // Purple
      route: '/admin/members',
    ),
    QuickAction(
      title: 'Events',
      subtitle: 'Create & manage events',
      icon: Icons.event_rounded,
      color: Color(0xFF8B5CF6), // Light purple
      route: '/events',
    ),
    QuickAction(
      title: 'Analytics',
      subtitle: 'View reports & insights',
      icon: Icons.analytics_rounded,
      color: Color(0xFFA78BFA), // Lighter purple
      route: '/analytics',
    ),
    QuickAction(
      title: 'Settings',
      subtitle: 'Organization settings',
      icon: Icons.settings_rounded,
      color: Color(0xFF10B981), // Green
      route: '/admin/organization',
    ),
  ];

  /// Pastor quick actions
  static const List<QuickAction> pastor = [
    QuickAction(
      title: 'Members',
      subtitle: 'View & connect',
      icon: Icons.people_rounded,
      color: Color(0xFF713784),
      route: '/admin/members',
    ),
    QuickAction(
      title: 'Events',
      subtitle: 'Upcoming church events',
      icon: Icons.event_rounded,
      color: Color(0xFF8B5CF6),
      route: '/events',
    ),
    QuickAction(
      title: 'Announcements',
      subtitle: 'Send updates',
      icon: Icons.campaign_rounded,
      color: Color(0xFFF59E0B), // Orange
      route: '/announcements',
    ),
    QuickAction(
      title: 'Media',
      subtitle: 'Sermons & photos',
      icon: Icons.perm_media_rounded,
      color: Color(0xFFEC4899), // Pink
      route: '/media',
    ),
  ];

  /// Usher quick actions
  static const List<QuickAction> usher = [
    QuickAction(
      title: 'QR Scanner',
      subtitle: 'Check-in members',
      icon: Icons.qr_code_scanner_rounded,
      color: Color(0xFF713784),
      route: '/attendance/scanner',
    ),
    QuickAction(
      title: 'Manual Check-In',
      subtitle: 'Search & check-in',
      icon: Icons.person_search_rounded,
      color: Color(0xFF8B5CF6),
      route: '/attendance/manual',
    ),
    QuickAction(
      title: 'Offline Queue',
      subtitle: 'Pending sync',
      icon: Icons.cloud_upload_rounded,
      color: Color(0xFFF59E0B),
      route: '/attendance/queue',
    ),
    QuickAction(
      title: 'Statistics',
      subtitle: 'Attendance reports',
      icon: Icons.bar_chart_rounded,
      color: Color(0xFF10B981),
      route: '/attendance/stats',
    ),
  ];

  /// Member quick actions
  static const List<QuickAction> member = [
    QuickAction(
      title: 'Give',
      subtitle: 'Support the ministry',
      icon: Icons.volunteer_activism_rounded,
      color: Color(0xFF10B981), // Green
      route: '/giving',
    ),
    QuickAction(
      title: 'Events',
      subtitle: 'Register for events',
      icon: Icons.event_rounded,
      color: Color(0xFF8B5CF6),
      route: '/events',
    ),
    QuickAction(
      title: 'Media Gallery',
      subtitle: 'Photos & videos',
      icon: Icons.photo_library_rounded,
      color: Color(0xFFF59E0B),
      route: '/media',
    ),
    QuickAction(
      title: 'Profile',
      subtitle: 'Your information',
      icon: Icons.person_rounded,
      color: Color(0xFF713784),
      route: '/profile',
    ),
  ];

  /// Parent quick actions
  static const List<QuickAction> parent = [
    QuickAction(
      title: 'Children',
      subtitle: 'Manage your kids',
      icon: Icons.family_restroom_rounded,
      color: Color(0xFFEC4899), // Pink
      route: '/profile/children',
    ),
    QuickAction(
      title: 'Events',
      subtitle: 'Family activities',
      icon: Icons.event_rounded,
      color: Color(0xFF8B5CF6),
      route: '/events',
    ),
    QuickAction(
      title: 'Give',
      subtitle: 'Support the ministry',
      icon: Icons.volunteer_activism_rounded,
      color: Color(0xFF10B981),
      route: '/giving',
    ),
    QuickAction(
      title: 'Attendance',
      subtitle: 'Kids check-in history',
      icon: Icons.checklist_rounded,
      color: Color(0xFF713784),
      route: '/profile',
    ),
  ];

  /// Get quick actions by role
  static List<QuickAction> getByRole(String role) {
    switch (role.toLowerCase()) {
      case 'admin':
        return admin;
      case 'pastor':
        return pastor;
      case 'usher':
        return usher;
      case 'parent':
        return parent;
      case 'member':
      default:
        return member;
    }
  }
}
