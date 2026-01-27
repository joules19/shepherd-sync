import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/network/dio_provider.dart';
import '../datasources/members_api_client.dart';
import '../repositories/members_repository.dart';

/// Members API client provider
final membersApiClientProvider = Provider<MembersApiClient>((ref) {
  final dioClient = ref.watch(dioClientProvider);
  return MembersApiClient(dioClient);
});

/// Members repository provider
final membersRepositoryProvider = Provider<MembersRepository>((ref) {
  final apiClient = ref.watch(membersApiClientProvider);
  return MembersRepository(apiClient);
});
