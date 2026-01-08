import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Key for storing onboarding completion status
const String _onboardingCompletedKey = 'onboarding_completed';

/// Provider for SharedPreferences instance
final sharedPreferencesProvider = Provider<SharedPreferences>((ref) {
  throw UnimplementedError('SharedPreferences must be overridden');
});

/// State notifier for managing onboarding state
class OnboardingNotifier extends StateNotifier<bool> {
  OnboardingNotifier(this._prefs) : super(false) {
    _checkOnboardingStatus();
  }

  final SharedPreferences _prefs;

  /// Check if user has completed onboarding
  void _checkOnboardingStatus() {
    final completed = _prefs.getBool(_onboardingCompletedKey) ?? false;
    state = completed;
  }

  /// Mark onboarding as completed
  Future<void> completeOnboarding() async {
    await _prefs.setBool(_onboardingCompletedKey, true);
    state = true;
  }

  /// Reset onboarding (for testing/development)
  Future<void> resetOnboarding() async {
    await _prefs.setBool(_onboardingCompletedKey, false);
    state = false;
  }
}

/// Provider for onboarding completion status
/// Returns true if onboarding is completed, false otherwise
final onboardingProvider =
    StateNotifierProvider<OnboardingNotifier, bool>((ref) {
  final prefs = ref.watch(sharedPreferencesProvider);
  return OnboardingNotifier(prefs);
});
