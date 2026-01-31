import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../core/constants/app_routes.dart';
import '../../../auth/presentation/providers/auth_state_provider.dart';
import '../../../onboarding/presentation/providers/onboarding_provider.dart';
import '../../data/models/quick_action.dart';
import '../../data/models/dashboard_stats.dart';
import '../../data/models/announcement.dart';
import '../../data/models/upcoming_event.dart';
import '../widgets/quick_action_grid.dart';
import '../widgets/stats_overview.dart';
import '../widgets/announcements_carousel.dart';
import '../widgets/upcoming_events_section.dart';

/// Dashboard content screen (without nav bar)
class DashboardScreen extends ConsumerStatefulWidget {
  const DashboardScreen({super.key});

  @override
  ConsumerState<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends ConsumerState<DashboardScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  bool _isRefreshing = false;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOut),
    );

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  Future<void> _handleRefresh() async {
    setState(() => _isRefreshing = true);
    // TODO: Fetch fresh data from API
    await Future.delayed(const Duration(seconds: 2));
    setState(() => _isRefreshing = false);
  }

  Future<void> _handleLogout() async {
    // Show confirmation bottom sheet
    final confirmed = await _showConfirmationSheet(
      title: 'Logout',
      message: 'Are you sure you want to logout?',
      confirmText: 'Logout',
      confirmColor: AppColors.error,
      icon: Icons.logout_rounded,
    );

    if (confirmed == true && mounted) {
      // Perform logout
      await ref.read(authStateProvider.notifier).logout();

      // Navigation will be handled automatically by router
      if (mounted) {
        context.go(AppRoutes.login);
      }
    }
  }

  Future<void> _handleResetOnboarding() async {
    // Show confirmation bottom sheet
    final confirmed = await _showConfirmationSheet(
      title: 'Reset Onboarding',
      message:
          'This will reset onboarding and logout. Are you sure?\n\n(This is for testing only)',
      confirmText: 'Reset',
      confirmColor: AppColors.error,
      icon: Icons.refresh_rounded,
    );

    if (confirmed == true && mounted) {
      // Reset onboarding and logout
      await ref.read(onboardingProvider.notifier).resetOnboarding();
      await ref.read(authStateProvider.notifier).logout();

      if (mounted) {
        context.go(AppRoutes.onboarding);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authStateProvider);
    final user = authState.user;
    final organization = authState.organization;

    if (user == null) {
      return const Scaffold(body: Center(child: Text('No user data')));
    }

    // Get role-based quick actions
    final quickActions = QuickActions.getByRole(user.role);

    // Mock data (TODO: Replace with real API data)
    final mockStats = const DashboardStats(
      giving: GivingStats(
        totalThisMonth: 45600,
        totalThisYear: 523000,
        totalAllTime: 2145000,
        donationsThisMonth: 156,
        percentageChange: 12.5,
      ),
      attendance: AttendanceStats(
        totalThisWeek: 342,
        totalThisMonth: 1456,
        averagePerService: 285,
        percentageChange: 8.3,
        last7Days: [210, 0, 245, 0, 298, 312, 342],
      ),
      events: EventStats(
        upcomingEvents: 7,
        totalRegistrations: 245,
        eventsThisMonth: 12,
      ),
      members: MemberStats(
        totalMembers: 856,
        newThisMonth: 23,
        activeMembers: 734,
        growthRate: 4.2,
      ),
    );

    final mockAnnouncements = [
      Announcement(
        id: '1',
        title: 'Sunday Service Update',
        message: 'Join us this Sunday at 10 AM for a special worship service.',
        category: 'event',
        createdAt: DateTime.now().subtract(const Duration(hours: 2)),
      ),
      Announcement(
        id: '2',
        title: 'Youth Camp Registration',
        message:
            'Register now for our annual youth camp! Limited spots available.',
        category: 'urgent',
        createdAt: DateTime.now().subtract(const Duration(days: 1)),
      ),
      Announcement(
        id: '3',
        title: 'Prayer Meeting Tonight',
        message: 'Join us tonight at 7 PM for our weekly prayer meeting.',
        category: 'general',
        createdAt: DateTime.now().subtract(const Duration(hours: 5)),
      ),
    ];

    final mockEvents = [
      UpcomingEvent(
        id: '1',
        title: 'Sunday Worship Service',
        description: 'Join us for worship and fellowship',
        startDate: DateTime.now().add(const Duration(days: 2)),
        endDate: DateTime.now().add(const Duration(days: 2, hours: 2)),
        location: 'Main Sanctuary',
        registeredCount: 234,
        maxCapacity: 500,
        isRegistered: true,
      ),
      UpcomingEvent(
        id: '2',
        title: 'Youth Night',
        description: 'Fun activities for teens',
        startDate: DateTime.now().add(const Duration(days: 5)),
        endDate: DateTime.now().add(const Duration(days: 5, hours: 3)),
        location: 'Youth Hall',
        registeredCount: 87,
        maxCapacity: 100,
        isRegistered: false,
      ),
      UpcomingEvent(
        id: '3',
        title: 'Community Outreach',
        description: 'Serving our neighborhood',
        startDate: DateTime.now().add(const Duration(days: 7)),
        endDate: DateTime.now().add(const Duration(days: 7, hours: 4)),
        location: 'Community Center',
        registeredCount: 45,
        maxCapacity: 60,
        isRegistered: false,
      ),
    ];

    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      body: RefreshIndicator(
        onRefresh: _handleRefresh,
        color: AppColors.primary,
        child: CustomScrollView(
          slivers: [
            // Modern Compact App Bar
            SliverAppBar(
              expandedHeight: 120,
              floating: true,
              pinned: true,
              snap: true,
              elevation: 0,
              backgroundColor: Colors.transparent,
              flexibleSpace: FlexibleSpaceBar(
                background: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        AppColors.primary,
                        AppColors.primary.withValues(alpha: 0.8),
                      ],
                    ),
                  ),
                  child: SafeArea(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppConstants.spacingLG,
                        vertical: AppConstants.spacingSM,
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          // Top Row: Avatar, Greeting/Name, Actions
                          FadeTransition(
                            opacity: _fadeAnimation,
                            child: Row(
                              children: [
                                // Profile Avatar with gradient border (tappable)
                                GestureDetector(
                                  onTap: () => context.push(AppRoutes.profile),
                                  child: Container(
                                    padding: const EdgeInsets.all(2),
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      gradient: LinearGradient(
                                        colors: [
                                          Colors.white.withValues(alpha: 0.3),
                                          Colors.white.withValues(alpha: 0.1),
                                        ],
                                      ),
                                    ),
                                    child: CircleAvatar(
                                      radius: 22,
                                      backgroundColor: Colors.white.withValues(
                                        alpha: 0.2,
                                      ),
                                      backgroundImage: user.avatar != null
                                          ? NetworkImage(user.avatar!)
                                          : null,
                                      child: user.avatar == null
                                          ? Text(
                                              '${user.firstName[0]}${user.lastName[0]}',
                                              style: AppTextStyles.bodyLarge
                                                  .copyWith(
                                                    color: Colors.white,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                            )
                                          : null,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: AppConstants.spacingSM),
                                // Greeting and Name
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text(
                                        _getGreeting(),
                                        style: AppTextStyles.bodySmall.copyWith(
                                          color: Colors.white.withValues(
                                            alpha: 0.85,
                                          ),
                                          fontWeight: FontWeight.w500,
                                          fontSize: 11,
                                        ),
                                      ),
                                      const SizedBox(height: 1),
                                      Text(
                                        '${user.firstName} ${user.lastName}',
                                        style: AppTextStyles.headlineMedium
                                            .copyWith(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold,
                                              height: 1.1,
                                            ),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ],
                                  ),
                                ),
                                // Notification Icon
                                IconButton(
                                  padding: const EdgeInsets.all(8),
                                  constraints: const BoxConstraints(),
                                  onPressed: () {
                                    // TODO: Navigate to notifications
                                  },
                                  icon: Stack(
                                    children: [
                                      const Icon(
                                        Icons.notifications_outlined,
                                        color: Colors.white,
                                        size: 24,
                                      ),
                                      // Badge indicator
                                      Positioned(
                                        right: 0,
                                        top: 0,
                                        child: Container(
                                          width: 8,
                                          height: 8,
                                          decoration: BoxDecoration(
                                            color: AppColors.secondary,
                                            shape: BoxShape.circle,
                                            border: Border.all(
                                              color: AppColors.primary,
                                              width: 1.5,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                // Menu
                                PopupMenuButton<String>(
                                  padding: const EdgeInsets.all(8),
                                  icon: const Icon(
                                    Icons.more_vert_rounded,
                                    color: Colors.white,
                                    size: 24,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                  offset: const Offset(0, 50),
                                  onSelected: (value) async {
                                    if (value == 'logout') {
                                      await _handleLogout();
                                    } else if (value == 'reset_onboarding') {
                                      await _handleResetOnboarding();
                                    }
                                  },
                                  itemBuilder: (context) => [
                                    const PopupMenuItem(
                                      value: 'logout',
                                      child: Row(
                                        children: [
                                          Icon(Icons.logout_rounded, size: 20),
                                          SizedBox(width: 12),
                                          Text('Logout'),
                                        ],
                                      ),
                                    ),
                                    const PopupMenuItem(
                                      value: 'reset_onboarding',
                                      child: Row(
                                        children: [
                                          Icon(Icons.refresh_rounded, size: 20),
                                          SizedBox(width: 12),
                                          Text('Reset Onboarding'),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 8),
                          // Organization badge - subtle and compact
                          FadeTransition(
                            opacity: _fadeAnimation,
                            child: Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 10,
                                    vertical: 4,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Colors.white.withValues(alpha: 0.15),
                                    borderRadius: BorderRadius.circular(16),
                                    border: Border.all(
                                      color: Colors.white.withValues(
                                        alpha: 0.2,
                                      ),
                                      width: 1,
                                    ),
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Image.asset(
                                        'assets/images/shepherdsync-high-resolution-logo.png',
                                        width: 30,
                                        height: 30,
                                        fit: BoxFit.contain,
                                      ),
                                      const SizedBox(width: 5),
                                      Text(
                                        organization?.name ?? '',
                                        style: AppTextStyles.bodySmall.copyWith(
                                          color: Colors.white.withValues(
                                            alpha: 0.9,
                                          ),
                                          fontWeight: FontWeight.w600,
                                          fontSize: 11,
                                        ),
                                      ),
                                    ],
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
              ),
            ),

            // Content
            SliverPadding(
              padding: const EdgeInsets.only(
                top: AppConstants.spacingLG,
                bottom: 100, // Space for floating nav bar
              ),
              sliver: SliverList(
                delegate: SliverChildListDelegate([
                  // Quick Actions
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppConstants.spacingLG,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Quick Actions',
                          style: AppTextStyles.headlineMedium.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: AppConstants.spacingSM),
                        QuickActionGrid(actions: quickActions),
                      ],
                    ),
                  ),

                  const SizedBox(height: AppConstants.spacingLG),

                  // Statistics Overview (handles its own padding)
                  StatsOverview(stats: mockStats),

                  const SizedBox(height: AppConstants.spacingLG),

                  // Announcements Carousel (handles its own padding)
                  AnnouncementsCarousel(announcements: mockAnnouncements),

                  const SizedBox(height: AppConstants.spacingLG),

                  // Upcoming Events
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppConstants.spacingLG,
                    ),
                    child: UpcomingEventsSection(events: mockEvents),
                  ),
                ]),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _getGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) return 'Good Morning';
    if (hour < 17) return 'Good Afternoon';
    return 'Good Evening';
  }

  Future<bool?> _showConfirmationSheet({
    required String title,
    required String message,
    required String confirmText,
    Color? confirmColor,
    IconData? icon,
  }) {
    return showModalBottomSheet<bool>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(AppConstants.spacingLG),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Draggable handle
                Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                const SizedBox(height: AppConstants.spacingLG),

                // Icon
                if (icon != null)
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: (confirmColor ?? Colors.red).withValues(alpha: 0.1),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      icon,
                      size: 32,
                      color: confirmColor ?? Colors.red,
                    ),
                  ),

                if (icon != null) const SizedBox(height: AppConstants.spacingLG),

                // Title
                Text(
                  title,
                  style: AppTextStyles.headlineMedium.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: AppConstants.spacingSM),

                // Message
                Text(
                  message,
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: Colors.grey[600],
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: AppConstants.spacingLG),

                // Action buttons - stacked vertically
                Column(
                  children: [
                    // Primary action
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () => Navigator.pop(context, true),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: confirmColor ?? Colors.red,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(
                            vertical: AppConstants.spacingMD,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          elevation: 0,
                        ),
                        child: Text(
                          confirmText,
                          style: const TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: AppConstants.spacingMD),

                    // Cancel action
                    SizedBox(
                      width: double.infinity,
                      child: OutlinedButton(
                        onPressed: () => Navigator.pop(context, false),
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(
                            vertical: AppConstants.spacingMD,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          side: BorderSide(color: Colors.grey[300]!),
                        ),
                        child: Text(
                          'Cancel',
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 16,
                            color: Colors.grey[700],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
