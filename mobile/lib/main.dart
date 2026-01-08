import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'core/theme/app_theme.dart';
import 'core/constants/app_constants.dart';
import 'core/router/app_router.dart';
import 'features/onboarding/presentation/providers/onboarding_provider.dart';

/// Main entry point for Shepherd Sync mobile app
/// Premium church management system
void main() async {
  // Ensure Flutter bindings are initialized
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize core services
  await _initializeApp();

  // Initialize SharedPreferences
  final sharedPreferences = await SharedPreferences.getInstance();

  // Run the app
  runApp(
    // Riverpod Provider Scope for state management
    ProviderScope(
      overrides: [
        // Override SharedPreferences provider
        sharedPreferencesProvider.overrideWithValue(sharedPreferences),
      ],
      child: const ShepherdSyncApp(),
    ),
  );
}

/// Initialize all required services before app starts
Future<void> _initializeApp() async {
  try {
    // Load environment variables
    await dotenv.load(fileName: '.env');

    // Initialize Hive for local storage
    await Hive.initFlutter();

    // Open Hive boxes
    await Hive.openBox(AppConstants.hiveBoxPreferences);
    await Hive.openBox(AppConstants.hiveBoxCache);

    // Set preferred device orientations (portrait only for now)
    await SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);

    // Set system UI overlay style
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
        systemNavigationBarColor: Colors.white,
        systemNavigationBarIconBrightness: Brightness.dark,
      ),
    );
  } catch (e) {
    // Log initialization error
    debugPrint('⚠️ Initialization error: $e');
    // App will still run, but some features may not work
  }
}

/// Root application widget
class ShepherdSyncApp extends ConsumerStatefulWidget {
  const ShepherdSyncApp({super.key});

  @override
  ConsumerState<ShepherdSyncApp> createState() => _ShepherdSyncAppState();
}

class _ShepherdSyncAppState extends ConsumerState<ShepherdSyncApp> {
  bool _showSplash = true;

  @override
  void initState() {
    super.initState();
    _initializeAuthCheck();
  }

  /// Show splash screen while checking auth status
  Future<void> _initializeAuthCheck() async {
    // Wait for auth state to be checked (minimum 5 seconds for splash)
    await Future.wait([
      Future.delayed(const Duration(seconds: 3)),
      // Auth state check happens automatically in authStateProvider
    ]);

    if (mounted) {
      setState(() {
        _showSplash = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // Get the router from provider
    final router = ref.watch(goRouterProvider);

    // TODO: Watch theme mode provider (light/dark)
    // For now, using system theme
    final brightness = MediaQuery.platformBrightnessOf(context);
    final isDarkMode = brightness == Brightness.dark;

    // Show splash screen initially
    if (_showSplash) {
      return MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: AppTheme.light(),
        darkTheme: AppTheme.dark(),
        themeMode: isDarkMode ? ThemeMode.dark : ThemeMode.light,
        home: const SplashScreen(),
      );
    }

    // Main app with router
    return MaterialApp.router(
      // Router configuration
      routerConfig: router,

      // App title
      title: AppConstants.appName,

      // Disable debug banner in production
      debugShowCheckedModeBanner: false,

      // Theme configuration
      theme: AppTheme.light(),
      darkTheme: AppTheme.dark(),
      themeMode: isDarkMode ? ThemeMode.dark : ThemeMode.light,

      // Localization (English only for now)
      locale: const Locale('en', 'US'),
      supportedLocales: const [Locale('en', 'US')],

      // Builder for error handling and text scaling
      builder: (context, child) {
        // Ensure text scaling doesn't break UI
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(
            textScaler: TextScaler.linear(
              MediaQuery.textScalerOf(context).scale(1.0).clamp(0.8, 1.2),
            ),
          ),
          child: child!,
        );
      },
    );
  }
}

/// Beautiful splash screen with branding
/// Will show while app initializes and checks auth state
class SplashScreen extends StatefulWidget {
  const SplashScreen({
    super.key,
    this.enableAnimation = true, // Make animation configurable
  });

  final bool enableAnimation;

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;
  late Animation<double> _logoPopAnimation;

  @override
  void initState() {
    super.initState();

    // Set up animations
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );

    // Fade animation for overall content
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.4, curve: Curves.easeIn),
      ),
    );

    // Pop-in animation for logo - starts from small and bounces to full size
    _logoPopAnimation = Tween<double>(begin: 0.3, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.2, 0.8, curve: Curves.elasticOut),
      ),
    );

    // Scale animation for loading indicator
    _scaleAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.6, 1.0, curve: Curves.easeOut),
      ),
    );

    // Start animation only if enabled
    if (widget.enableAnimation) {
      _controller.forward();
    } else {
      // If animation disabled, jump to end
      _controller.value = 1.0;
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      body: Stack(
        children: [
          // Split background
          Row(
            children: [
              // Left side - Light purple
              Container(
                width: size.width / 2,
                color: const Color(
                  0xFFE8DEF8,
                ).withOpacity(0.4), // Light purple shade
              ),
              // Right side - Off white
              Container(
                width: size.width / 2,
                color: const Color(0xFFF8F9FA), // Off white
              ),
            ],
          ),

          // Content with animation - centered on screen
          Center(
            child: AnimatedBuilder(
              animation: _controller,
              builder: (context, child) {
                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // App Logo with pop-in animation
                    FadeTransition(
                      opacity: _fadeAnimation,
                      child: ScaleTransition(
                        scale: _logoPopAnimation,
                        child: Image.asset(
                          'assets/images/shepherdsync-high-resolution-logo.png',
                          width: 300,
                          height: 300,
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),

                    const SizedBox(height: 48),

                    // Loading indicator with delayed fade-in
                    FadeTransition(
                      opacity: _scaleAnimation,
                      child: const SizedBox(
                        width: 40,
                        height: 40,
                        child: CircularProgressIndicator.adaptive(
                          valueColor: AlwaysStoppedAnimation<Color>(
                            Color(0xFF713784), // Primary purple
                          ),
                          strokeWidth: 3,
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
