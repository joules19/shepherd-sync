import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../data/models/member_model.dart';
import '../../data/providers/members_providers.dart';
import '../../data/repositories/members_repository.dart';

part 'members_state_provider.freezed.dart';

/// Members list state
@freezed
class MembersState with _$MembersState {
  const factory MembersState({
    @Default([]) List<MemberModel> members,
    @Default(false) bool isLoading,
    @Default(false) bool isLoadingMore,
    @Default(1) int currentPage,
    @Default(0) int totalPages,
    @Default(0) int total,
    String? error,
    String? searchQuery,
    String? selectedGender,
    String? selectedMembershipStatus,
    String? selectedMaritalStatus,
  }) = _MembersState;
}

/// Members list state notifier
class MembersNotifier extends StateNotifier<MembersState> {
  MembersNotifier(this._repository) : super(const MembersState());

  final MembersRepository _repository;

  /// Fetch members with current filters
  Future<void> fetchMembers({bool refresh = false}) async {
    if (refresh) {
      state = state.copyWith(
        isLoading: true,
        error: null,
        currentPage: 1,
        members: [],
      );
    } else {
      state = state.copyWith(isLoading: true, error: null);
    }

    final result = await _repository.getMembers(
      page: state.currentPage,
      limit: 20,
      search: state.searchQuery,
      gender: state.selectedGender,
      membershipStatus: state.selectedMembershipStatus,
      maritalStatus: state.selectedMaritalStatus,
      sortBy: 'firstName',
      sortOrder: 'asc',
    );

    result.fold(
      (error) => state = state.copyWith(
        isLoading: false,
        error: error.message,
      ),
      (response) => state = state.copyWith(
        isLoading: false,
        members: response.data,
        total: response.total,
        totalPages: response.totalPages,
        currentPage: response.page,
      ),
    );
  }

  /// Load more members (pagination)
  Future<void> loadMore() async {
    if (state.isLoadingMore || state.currentPage >= state.totalPages) return;

    state = state.copyWith(isLoadingMore: true);

    final result = await _repository.getMembers(
      page: state.currentPage + 1,
      limit: 20,
      search: state.searchQuery,
      gender: state.selectedGender,
      membershipStatus: state.selectedMembershipStatus,
      maritalStatus: state.selectedMaritalStatus,
      sortBy: 'firstName',
      sortOrder: 'asc',
    );

    result.fold(
      (error) => state = state.copyWith(isLoadingMore: false),
      (response) => state = state.copyWith(
        isLoadingMore: false,
        members: [...state.members, ...response.data],
        currentPage: response.page,
      ),
    );
  }

  /// Search members
  void search(String query) {
    state = state.copyWith(searchQuery: query.isEmpty ? null : query);
    fetchMembers(refresh: true);
  }

  /// Filter by gender
  void filterByGender(String? gender) {
    state = state.copyWith(selectedGender: gender);
    fetchMembers(refresh: true);
  }

  /// Filter by membership status
  void filterByMembershipStatus(String? status) {
    state = state.copyWith(selectedMembershipStatus: status);
    fetchMembers(refresh: true);
  }

  /// Filter by marital status
  void filterByMaritalStatus(String? status) {
    state = state.copyWith(selectedMaritalStatus: status);
    fetchMembers(refresh: true);
  }

  /// Clear all filters
  void clearFilters() {
    state = state.copyWith(
      searchQuery: null,
      selectedGender: null,
      selectedMembershipStatus: null,
      selectedMaritalStatus: null,
    );
    fetchMembers(refresh: true);
  }

  /// Delete member
  Future<bool> deleteMember(String id) async {
    final result = await _repository.deleteMember(id);

    return result.fold(
      (error) {
        state = state.copyWith(error: error.message);
        return false;
      },
      (_) {
        // Remove member from list
        state = state.copyWith(
          members: state.members.where((m) => m.id != id).toList(),
        );
        return true;
      },
    );
  }

  /// Restore deleted member
  Future<bool> restoreMember(String id) async {
    final result = await _repository.restoreMember(id);

    return result.fold(
      (error) {
        state = state.copyWith(error: error.message);
        return false;
      },
      (member) {
        // Add restored member to list
        state = state.copyWith(
          members: [...state.members, member],
        );
        return true;
      },
    );
  }
}

/// Members state provider
final membersProvider = StateNotifierProvider<MembersNotifier, MembersState>(
  (ref) {
    return MembersNotifier(ref.watch(membersRepositoryProvider));
  },
);

/// Member statistics provider
final memberStatsProvider = FutureProvider((ref) async {
  final repository = ref.watch(membersRepositoryProvider);
  final result = await repository.getStats();

  return result.fold(
    (error) => throw Exception(error.message),
    (stats) => stats,
  );
});

/// Single member detail provider
final memberDetailProvider = FutureProvider.family<MemberModel, String>(
  (ref, memberId) async {
    final repository = ref.watch(membersRepositoryProvider);
    final result = await repository.getMember(memberId);

    return result.fold(
      (error) => throw Exception(error.message),
      (member) => member,
    );
  },
);
