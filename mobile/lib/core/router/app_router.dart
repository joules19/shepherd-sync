import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shepherd_sync_mobile/features/dashboard/presentation/screens/dashboard_screen.dart';

import '../../features/auth/presentation/screens/login_screen.dart';
import '../../features/auth/presentation/screens/register_screen.dart';
import '../../features/auth/presentation/screens/forgot_password_screen.dart';
import '../../features/auth/presentation/providers/auth_state_provider.dart';
import '../../features/onboarding/presentation/screens/onboarding_screen.dart';
import '../../features/onboarding/presentation/providers/onboarding_provider.dart';
import '../constants/app_routes.dart';
import '../widgets/custom_button.dart';
import 'router_notifier.dart';

/// GoRouter configuration with authentication and onboarding guards
final goRouterProvider = Provider<GoRouter>((ref) {
  // Use watch for routerNotifier to trigger refreshes
  final routerNotifier = ref.watch(routerNotifierProvider);

  return GoRouter(
    debugLogDiagnostics: true,
    initialLocation: AppRoutes.splash,
    refreshListenable: routerNotifier,

    // Redirect logic for onboarding and authentication
    redirect: (context, state) {
      // Read (not watch) auth state inside redirect to avoid recreating router
      final authState = ref.read(authStateProvider);
      final onboardingCompleted = ref.read(onboardingProvider);

      final isAuthenticated = authState.isAuthenticated;
      final isLoading = authState.isLoading;
      final location = state.matchedLocation;

      // Debug logging
      debugPrint(
        '🔀 Router redirect: location=$location, auth=$isAuthenticated, loading=$isLoading',
      );

      // Define public routes upfront
      final publicRoutes = [
        AppRoutes.login,
        AppRoutes.register,
        AppRoutes.forgotPassword,
        AppRoutes.splash,
        AppRoutes.onboarding,
      ];
      final isPublicRoute = publicRoutes.contains(location);

      // Show splash screen only during initial load, not during login/register
      if (isLoading && !isPublicRoute) {
        return AppRoutes.splash;
      }

      // After loading completes, redirect from splash to appropriate screen
      if (!isLoading && location == AppRoutes.splash) {
        // First time user - show onboarding
        if (!onboardingCompleted) {
          return AppRoutes.onboarding;
        }
        // Onboarding completed - show login or dashboard
        return isAuthenticated ? AppRoutes.dashboard : AppRoutes.login;
      }

      // If onboarding not completed, redirect to onboarding (except from splash)
      if (!onboardingCompleted &&
          location != AppRoutes.onboarding &&
          location != AppRoutes.splash) {
        return AppRoutes.onboarding;
      }

      // If not authenticated and trying to access protected route, redirect to login
      if (!isAuthenticated && !isPublicRoute) {
        return AppRoutes.login;
      }

      // If authenticated and on auth screens, redirect to dashboard
      if (isAuthenticated &&
          isPublicRoute &&
          location != AppRoutes.splash &&
          location != AppRoutes.onboarding) {
        debugPrint(
          '✅ Redirecting to dashboard (authenticated user on auth screen)',
        );
        return AppRoutes.dashboard;
      }

      // No redirect needed
      debugPrint('➡️  No redirect needed');
      return null;
    },

    routes: [
      // Splash Screen
      GoRoute(
        path: AppRoutes.splash,
        name: 'splash',
        builder: (context, state) {
          // Return actual splash screen to avoid blank screen
          // Import SplashScreen from main.dart or redirect immediately
          // For now, show a loading indicator
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        },
      ),

      // Onboarding Routes
      GoRoute(
        path: AppRoutes.onboarding,
        name: 'onboarding',
        pageBuilder: (context, state) => CustomTransitionPage(
          key: state.pageKey,
          child: const OnboardingScreen(),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return FadeTransition(opacity: animation, child: child);
          },
        ),
      ),

      // Authentication Routes
      GoRoute(
        path: AppRoutes.login,
        name: 'login',
        pageBuilder: (context, state) => CustomTransitionPage(
          key: state.pageKey,
          child: const LoginScreen(),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return FadeTransition(opacity: animation, child: child);
          },
        ),
      ),

      GoRoute(
        path: AppRoutes.register,
        name: 'register',
        pageBuilder: (context, state) => CustomTransitionPage(
          key: state.pageKey,
          child: const RegisterScreen(),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return SlideTransition(
              position: Tween<Offset>(
                begin: const Offset(1, 0),
                end: Offset.zero,
              ).animate(animation),
              child: child,
            );
          },
        ),
      ),

      GoRoute(
        path: AppRoutes.forgotPassword,
        name: 'forgot-password',
        pageBuilder: (context, state) => CustomTransitionPage(
          key: state.pageKey,
          child: const ForgotPasswordScreen(),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return SlideTransition(
              position: Tween<Offset>(
                begin: const Offset(1, 0),
                end: Offset.zero,
              ).animate(animation),
              child: child,
            );
          },
        ),
      ),

      // Dashboard (placeholder for now)
      GoRoute(
        path: AppRoutes.dashboard,
        name: 'dashboard',
        builder: (context, state) => const DashboardScreen(),
      ),

      // Events (placeholder)
      GoRoute(
        path: AppRoutes.events,
        name: 'events',
        builder: (context, state) =>
            const Scaffold(body: Center(child: Text('Events - Coming Soon'))),
      ),

      // Giving (placeholder)
      GoRoute(
        path: AppRoutes.giving,
        name: 'giving',
        builder: (context, state) =>
            const Scaffold(body: Center(child: Text('Giving - Coming Soon'))),
      ),

      // Profile (placeholder)
      GoRoute(
        path: AppRoutes.profile,
        name: 'profile',
        builder: (context, state) =>
            const Scaffold(body: Center(child: Text('Profile - Coming Soon'))),
      ),
    ],

    // Error handling
    errorBuilder: (context, state) => Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 48, color: Colors.red),
            const SizedBox(height: 16),
            Text(
              'Page not found: ${state.matchedLocation}',
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => context.go(AppRoutes.dashboard),
              child: const Text('Go to Dashboard'),
            ),
          ],
        ),
      ),
    ),
  );
});

/// Temporary dashboard placeholder
class DashboardPlaceholder extends ConsumerWidget {
  const DashboardPlaceholder({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authStateProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              await ref.read(authStateProvider.notifier).logout();
              if (context.mounted) {
                context.go(AppRoutes.login);
              }
            },
          ),
        ],
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.dashboard, size: 64),
              const SizedBox(height: 16),
              Text(
                'Welcome, ${authState.user?.firstName ?? "User"}!',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const SizedBox(height: 8),
              Text(
                authState.organization?.name ?? '',
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              const SizedBox(height: 32),
              const Text('Dashboard Coming Soon'),

              const SizedBox(height: 48),
              const Divider(),
              const SizedBox(height: 16),
              const Text(
                'Debug Options',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),

              // Reset Onboarding Button
              SizedBox(
                width: 250,
                child: CustomButton(
                  text: 'Reset Onboarding',
                  icon: const Icon(Icons.refresh, color: Colors.white),
                  onPressed: () async {
                    await ref
                        .read(onboardingProvider.notifier)
                        .resetOnboarding();
                    await ref.read(authStateProvider.notifier).logout();
                    if (context.mounted) {
                      context.go(AppRoutes.onboarding);
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
