import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/network/dio_provider.dart';
import '../datasources/auth_api_client.dart';
import '../repositories/auth_repository.dart';

// ========================================
// DATA LAYER PROVIDERS
// ========================================

/// Provider for AuthApiClient
final authApiClientProvider = Provider<AuthApiClient>((ref) {
  final dioClient = ref.watch(dioClientProvider);
  return AuthApiClient(dioClient);
});

/// Provider for AuthRepository
final authRepositoryProvider = Provider<AuthRepository>((ref) {
  final apiClient = ref.watch(authApiClientProvider);
  final secureStorage = ref.watch(secureStorageProvider);
  return AuthRepository(apiClient, secureStorage);
});
