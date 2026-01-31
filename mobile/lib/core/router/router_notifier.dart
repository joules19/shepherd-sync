import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../features/auth/presentation/providers/auth_state_provider.dart';

/// Router refresh notifier
/// This bridges Riverpod state changes with GoRouter's refreshListenable
/// When auth state changes, GoRouter will re-evaluate its redirect logic
class RouterNotifier extends ChangeNotifier {
  final Ref _ref;

  RouterNotifier(this._ref) {
    // Listen to auth state changes
    _ref.listen<AuthState>(authStateProvider, (previous, next) {
      // Only notify GoRouter when authentication status changes (login/logout)
      // Don't notify on loading state changes (profile updates, etc.)
      if (previous?.isAuthenticated != next.isAuthenticated) {
        debugPrint('🔔 RouterNotifier: Auth state changed, notifying router');
        debugPrint(
          '   Previous: auth=${previous?.isAuthenticated}',
        );
        debugPrint(
          '   Next: auth=${next.isAuthenticated}',
        );
        notifyListeners();
      }
    });
  }
}

/// Provider for RouterNotifier
final routerNotifierProvider = Provider<RouterNotifier>((ref) {
  return RouterNotifier(ref);
});
