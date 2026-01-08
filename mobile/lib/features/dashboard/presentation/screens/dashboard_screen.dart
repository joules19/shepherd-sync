import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../core/constants/app_routes.dart';
import '../../../../core/widgets/floating_nav_bar.dart';
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

/// Exceptional dashboard screen with floating nav bar and premium UI
class DashboardScreen extends ConsumerStatefulWidget {
  const DashboardScreen({super.key});

  @override
  ConsumerState<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends ConsumerState<DashboardScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  int _currentNavIndex = 0;
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
    // Show confirmation dialog
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Logout'),
        content: const Text('Are you sure you want to logout?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            style: TextButton.styleFrom(foregroundColor: AppColors.error),
            child: const Text('Logout'),
          ),
        ],
      ),
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
    // Show confirmation dialog
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Reset Onboarding'),
        content: const Text(
          'This will reset onboarding and logout. Are you sure?\n\n(This is for testing only)',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            style: TextButton.styleFrom(foregroundColor: AppColors.error),
            child: const Text('Reset'),
          ),
        ],
      ),
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
      body: Stack(
        children: [
          // Main content with RefreshIndicator
          RefreshIndicator(
            onRefresh: _handleRefresh,
            color: AppColors.primary,
            child: CustomScrollView(
              slivers: [
                // App Bar
                SliverAppBar(
                  expandedHeight: 200,
                  floating: false,
                  pinned: true,
                  backgroundColor: AppColors.primary,
                  actions: [
                    // Settings/Logout Menu
                    PopupMenuButton<String>(
                      icon: const Icon(Icons.more_vert, color: Colors.white),
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
                              Icon(Icons.logout, size: 20),
                              SizedBox(width: 12),
                              Text('Logout'),
                            ],
                          ),
                        ),
                        const PopupMenuItem(
                          value: 'reset_onboarding',
                          child: Row(
                            children: [
                              Icon(Icons.refresh, size: 20),
                              SizedBox(width: 12),
                              Text('Reset Onboarding (Test)'),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                  flexibleSpace: FlexibleSpaceBar(
                    background: Container(
                      decoration: const BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [Color(0xFF713784), Color(0xFF8B5CF6)],
                        ),
                      ),
                      child: SafeArea(
                        child: Padding(
                          padding: const EdgeInsets.all(AppConstants.spacingLG),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              // Greeting
                              FadeTransition(
                                opacity: _fadeAnimation,
                                child: Text(
                                  _getGreeting(),
                                  style: AppTextStyles.bodyLarge.copyWith(
                                    color: Colors.white.withValues(alpha: 0.9),
                                  ),
                                ),
                              ),
                              const SizedBox(height: AppConstants.spacingXS),
                              // User name
                              FadeTransition(
                                opacity: _fadeAnimation,
                                child: Text(
                                  '${user.firstName} ${user.lastName}',
                                  style: AppTextStyles.displayMedium.copyWith(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              const SizedBox(height: AppConstants.spacingXS),
                              // Organization
                              FadeTransition(
                                opacity: _fadeAnimation,
                                child: Row(
                                  children: [
                                    Image.asset(
                                      'assets/images/shepherdsync-high-resolution-logo.png',
                                      width: 16,
                                      height: 16,
                                      fit: BoxFit.contain,
                                    ),
                                    const SizedBox(
                                      width: AppConstants.spacingXS,
                                    ),
                                    Text(
                                      organization?.name ?? '',
                                      style: AppTextStyles.bodyMedium.copyWith(
                                        color: Colors.white.withValues(
                                          alpha: 0.9,
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
                            const SizedBox(height: AppConstants.spacingXS),
                            QuickActionGrid(actions: quickActions),
                          ],
                        ),
                      ),

                      const SizedBox(height: AppConstants.spacingXL),

                      // Statistics Overview
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: AppConstants.spacingLG,
                        ),
                        child: StatsOverview(stats: mockStats),
                      ),

                      const SizedBox(height: AppConstants.spacingXL),

                      // Announcements Carousel
                      AnnouncementsCarousel(announcements: mockAnnouncements),

                      const SizedBox(height: AppConstants.spacingXL),

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

          // Floating Navigation Bar
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: FloatingNavBar(
              currentIndex: _currentNavIndex,
              onTap: (index) {
                setState(() => _currentNavIndex = index);
                // TODO: Handle navigation
              },
              items: const [
                FloatingNavBarItem(
                  label: 'Home',
                  icon: Icons.home_outlined,
                  activeIcon: Icons.home_rounded,
                ),
                FloatingNavBarItem(
                  label: 'Events',
                  icon: Icons.event_outlined,
                  activeIcon: Icons.event_rounded,
                ),
                FloatingNavBarItem(
                  label: 'Give',
                  icon: Icons.volunteer_activism_outlined,
                  activeIcon: Icons.volunteer_activism_rounded,
                ),
                FloatingNavBarItem(
                  label: 'Profile',
                  icon: Icons.person_outlined,
                  activeIcon: Icons.person_rounded,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _getGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) return 'Good Morning';
    if (hour < 17) return 'Good Afternoon';
    return 'Good Evening';
  }
}
