import 'package:dartz/dartz.dart';

import '../../../../core/errors/api_exception.dart';
import '../datasources/members_api_client.dart';
import '../models/member_model.dart';

/// Members repository - handles member management logic
/// Implements Either pattern for error handling
class MembersRepository {
  final MembersApiClient _apiClient;

  MembersRepository(this._apiClient);

  // ========================================
  // MEMBER OPERATIONS
  // ========================================

  /// Get members with pagination and filtering
  Future<Either<ApiException, PaginatedMembersResponse>> getMembers({
    int page = 1,
    int limit = 20,
    String? search,
    String? gender,
    String? membershipStatus,
    String? maritalStatus,
    String? joinedAfter,
    String? joinedBefore,
    String? sortBy,
    String? sortOrder,
  }) async {
    try {
      print('🚀 Repository: Calling API client...');
      final response = await _apiClient.getMembers(
        page: page,
        limit: limit,
        search: search,
        gender: gender,
        membershipStatus: membershipStatus,
        maritalStatus: maritalStatus,
        joinedAfter: joinedAfter,
        joinedBefore: joinedBefore,
        sortBy: sortBy,
        sortOrder: sortOrder,
      );

      print('✅ Repository: Got response with ${response.data.length} members');
      return Right(response);
    } on ApiException catch (e) {
      print('⚠️ Repository: ApiException - ${e.message}');
      return Left(e);
    } catch (e, stack) {
      print('❌ Repository: Unexpected error - $e');
      print('📚 Stack trace: $stack');
      return Left(ApiException(
        message: 'Failed to fetch members. Please try again.',
        statusCode: 0,
      ));
    }
  }

  /// Get single member by ID
  Future<Either<ApiException, MemberModel>> getMember(String id) async {
    try {
      final member = await _apiClient.getMember(id);
      return Right(member);
    } on ApiException catch (e) {
      return Left(e);
    } catch (e) {
      return Left(ApiException(
        message: 'Failed to fetch member details. Please try again.',
        statusCode: 0,
      ));
    }
  }

  /// Create new member
  Future<Either<ApiException, MemberModel>> createMember(
    Map<String, dynamic> data,
  ) async {
    try {
      final member = await _apiClient.createMember(data);
      return Right(member);
    } on ApiException catch (e) {
      return Left(e);
    } catch (e) {
      return Left(ApiException(
        message: 'Failed to create member. Please try again.',
        statusCode: 0,
      ));
    }
  }

  /// Update existing member
  Future<Either<ApiException, MemberModel>> updateMember(
    String id,
    Map<String, dynamic> data,
  ) async {
    try {
      final member = await _apiClient.updateMember(id, data);
      return Right(member);
    } on ApiException catch (e) {
      return Left(e);
    } catch (e) {
      return Left(ApiException(
        message: 'Failed to update member. Please try again.',
        statusCode: 0,
      ));
    }
  }

  /// Delete member (soft delete)
  Future<Either<ApiException, void>> deleteMember(String id) async {
    try {
      await _apiClient.deleteMember(id);
      return const Right(null);
    } on ApiException catch (e) {
      return Left(e);
    } catch (e) {
      return Left(ApiException(
        message: 'Failed to delete member. Please try again.',
        statusCode: 0,
      ));
    }
  }

  /// Restore soft-deleted member
  Future<Either<ApiException, MemberModel>> restoreMember(String id) async {
    try {
      final member = await _apiClient.restoreMember(id);
      return Right(member);
    } on ApiException catch (e) {
      return Left(e);
    } catch (e) {
      return Left(ApiException(
        message: 'Failed to restore member. Please try again.',
        statusCode: 0,
      ));
    }
  }

  /// Get current user's member profile
  Future<Either<ApiException, MemberModel>> getMyMemberProfile() async {
    try {
      final member = await _apiClient.getMyMemberProfile();
      return Right(member);
    } on ApiException catch (e) {
      return Left(e);
    } catch (e) {
      return Left(ApiException(
        message: 'Failed to fetch member profile. Please try again.',
        statusCode: 0,
      ));
    }
  }

  /// Update current user's member profile
  Future<Either<ApiException, MemberModel>> updateMyMemberProfile(
    Map<String, dynamic> data,
  ) async {
    try {
      final member = await _apiClient.updateMyMemberProfile(data);
      return Right(member);
    } on ApiException catch (e) {
      return Left(e);
    } catch (e) {
      return Left(ApiException(
        message: 'Failed to update member profile. Please try again.',
        statusCode: 0,
      ));
    }
  }

  /// Get member statistics
  Future<Either<ApiException, MemberStatsResponse>> getStats() async {
    try {
      final stats = await _apiClient.getStats();
      return Right(stats);
    } on ApiException catch (e) {
      return Left(e);
    } catch (e) {
      return Left(ApiException(
        message: 'Failed to fetch statistics. Please try again.',
        statusCode: 0,
      ));
    }
  }

  /// Export members to CSV
  Future<Either<ApiException, String>> exportMembers({
    String? search,
    String? gender,
    String? membershipStatus,
    String? maritalStatus,
  }) async {
    try {
      final csv = await _apiClient.exportMembers(
        search: search,
        gender: gender,
        membershipStatus: membershipStatus,
        maritalStatus: maritalStatus,
      );
      return Right(csv);
    } on ApiException catch (e) {
      return Left(e);
    } catch (e) {
      return Left(ApiException(
        message: 'Failed to export members. Please try again.',
        statusCode: 0,
      ));
    }
  }

  /// Send invite to member for app signup
  Future<Either<ApiException, SendInviteResponse>> sendInvite(
    String memberId,
    String method, {
    String? customMessage,
  }) async {
    try {
      final data = {
        'method': method,
        if (customMessage != null) 'customMessage': customMessage,
      };

      final response = await _apiClient.sendInvite(memberId, data);
      return Right(response);
    } on ApiException catch (e) {
      return Left(e);
    } catch (e) {
      return Left(ApiException(
        message: 'Failed to send invite. Please try again.',
        statusCode: 0,
      ));
    }
  }

  /// Resend invite to member
  Future<Either<ApiException, SendInviteResponse>> resendInvite(
    String memberId,
    String method, {
    String? customMessage,
  }) async {
    try {
      final data = {
        'method': method,
        if (customMessage != null) 'customMessage': customMessage,
      };

      final response = await _apiClient.resendInvite(memberId, data);
      return Right(response);
    } on ApiException catch (e) {
      return Left(e);
    } catch (e) {
      return Left(ApiException(
        message: 'Failed to resend invite. Please try again.',
        statusCode: 0,
      ));
    }
  }
}
