import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../data/models/auth_models.dart';
import '../../data/models/user_model.dart';
import '../../data/models/organization_model.dart';
import '../../data/providers/auth_providers.dart';
import '../../data/repositories/auth_repository.dart';

part 'auth_state_provider.freezed.dart';

// ========================================
// AUTH STATE
// ========================================

@freezed
class AuthState with _$AuthState {
  const factory AuthState({
    UserModel? user,
    OrganizationModel? organization,
    @Default(false) bool isLoading,
    @Default(false) bool isAuthenticated,
    String? error,
  }) = _AuthState;
}

// ========================================
// AUTH STATE NOTIFIER
// ========================================

class AuthStateNotifier extends StateNotifier<AuthState> {
  final AuthRepository _authRepository;

  AuthStateNotifier(this._authRepository) : super(const AuthState()) {
    // Check auth status on initialization
    _checkAuthStatus();
  }

  /// Check if user is already logged in
  Future<void> _checkAuthStatus() async {
    state = state.copyWith(isLoading: true);

    try {
      final isLoggedIn = await _authRepository.isLoggedIn();

      if (isLoggedIn) {
        // Fetch current user profile
        final result = await _authRepository.getCurrentUser();

        result.fold(
          (error) {
            // Token might be expired, clear auth state
            state = const AuthState(isAuthenticated: false, isLoading: false);
          },
          (user) {
            // User is authenticated
            state = AuthState(
              user: user,
              isAuthenticated: true,
              isLoading: false,
            );
          },
        );
      } else {
        state = const AuthState(isAuthenticated: false, isLoading: false);
      }
    } catch (e) {
      state = const AuthState(isAuthenticated: false, isLoading: false);
    }
  }

  /// Login with email and password
  Future<void> login(String email, String password) async {
    state = state.copyWith(isLoading: true, error: null);

    final request = LoginRequest(email: email, password: password);
    final result = await _authRepository.login(request);

    result.fold(
      (error) {
        debugPrint('❌ Login failed: ${error.message}');
        state = state.copyWith(
          isLoading: false,
          error: error.message,
          isAuthenticated: false,
        );
      },
      (response) {
        debugPrint('✅ Login successful: ${response.user.email}');
        state = state.copyWith(
          user: response.user,
          organization: response.organization,
          isAuthenticated: true,
          isLoading: false,
          error: null,
        );
        debugPrint('🔐 Auth state updated: isAuthenticated=${state.isAuthenticated}');
      },
    );
  }

  /// Register new organization and admin user
  Future<void> register({
    required String organizationName,
    required String subdomain,
    required String firstName,
    required String lastName,
    required String email,
    required String password,
    String? phone,
  }) async {
    state = state.copyWith(isLoading: true, error: null);

    final request = RegisterRequest(
      organizationName: organizationName,
      subdomain: subdomain,
      firstName: firstName,
      lastName: lastName,
      email: email,
      password: password,
      phone: phone,
    );

    final result = await _authRepository.register(request);

    result.fold(
      (error) {
        state = state.copyWith(
          isLoading: false,
          error: error.message,
          isAuthenticated: false,
        );
      },
      (response) {
        state = state.copyWith(
          user: response.user,
          organization: response.organization,
          isAuthenticated: true,
          isLoading: false,
          error: null,
        );
      },
    );
  }

  /// Logout user
  Future<void> logout() async {
    await _authRepository.logout();
    state = const AuthState(isAuthenticated: false);
  }

  /// Clear error message
  void clearError() {
    state = state.copyWith(error: null);
  }

  /// Refresh current user data
  Future<void> refreshUser() async {
    final result = await _authRepository.getCurrentUser();

    result.fold(
      (error) {
        // Handle error silently or show notification
      },
      (user) {
        state = state.copyWith(user: user);
      },
    );
  }
}

// ========================================
// PROVIDER
// ========================================

final authStateProvider = StateNotifierProvider<AuthStateNotifier, AuthState>(
  (ref) {
    final authRepository = ref.watch(authRepositoryProvider);
    return AuthStateNotifier(authRepository);
  },
);
