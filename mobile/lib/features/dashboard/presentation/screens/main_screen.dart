import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/widgets/floating_nav_bar.dart';
import 'dashboard_screen.dart';

/// Main screen wrapper that contains the bottom navigation bar
/// This is the container for all main app screens (Dashboard, Events, Give, Profile)
class MainScreen extends ConsumerStatefulWidget {
  const MainScreen({super.key});

  @override
  ConsumerState<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends ConsumerState<MainScreen> {
  int _currentIndex = 0;

  // List of screens for each tab
  late final List<Widget> _screens;

  @override
  void initState() {
    super.initState();
    _screens = [
      const DashboardScreen(), // Home
      const _PlaceholderScreen(title: 'Events'), // Events (Coming soon)
      const _PlaceholderScreen(title: 'Give'), // Giving (Coming soon)
      const _PlaceholderScreen(title: 'Profile'), // Profile (Coming soon)
    ];
  }

  void _onNavTap(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Main content with tab screens
          IndexedStack(
            index: _currentIndex,
            children: _screens,
          ),

          // Floating Navigation Bar
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: FloatingNavBar(
              currentIndex: _currentIndex,
              onTap: _onNavTap,
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
}

/// Placeholder screen for tabs that are coming soon
class _PlaceholderScreen extends StatelessWidget {
  const _PlaceholderScreen({required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.construction_rounded,
              size: 64,
              color: Colors.grey[400],
            ),
            const SizedBox(height: 16),
            Text(
              '$title - Coming Soon',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 8),
            Text(
              'This feature is under development',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Colors.grey[600],
                  ),
            ),
          ],
        ),
      ),
    );
  }
}
