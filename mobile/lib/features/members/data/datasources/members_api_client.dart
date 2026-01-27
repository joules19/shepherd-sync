import '../../../../core/network/dio_client.dart';
import '../models/member_model.dart';

/// Members API client
/// Reference: backend/src/modules/members/members.controller.ts
class MembersApiClient {
  final DioClient _dioClient;

  MembersApiClient(this._dioClient);

  /// Get all members with filtering and pagination
  /// GET /members
  /// Reference: backend/src/modules/members/members.controller.ts line 61-73
  Future<PaginatedMembersResponse> getMembers({
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
      final queryParams = <String, dynamic>{
        'page': page,
        'limit': limit,
        if (search != null) 'search': search,
        if (gender != null) 'gender': gender,
        if (membershipStatus != null) 'membershipStatus': membershipStatus,
        if (maritalStatus != null) 'maritalStatus': maritalStatus,
        if (joinedAfter != null) 'joinedAfter': joinedAfter,
        if (joinedBefore != null) 'joinedBefore': joinedBefore,
        if (sortBy != null) 'sortBy': sortBy,
        if (sortOrder != null) 'sortOrder': sortOrder,
      };

      final response = await _dioClient.get(
        '/members',
        queryParameters: queryParams,
      );

      final responseData = response.data as Map<String, dynamic>;
      print('🔍 Raw API Response: $responseData');

      // Backend returns { data: [], meta: { total, page, limit, totalPages, ... } }
      // Transform to match our model structure
      final transformed = {
        'data': responseData['data'],
        'total': responseData['meta']['total'],
        'page': responseData['meta']['page'],
        'limit': responseData['meta']['limit'],
        'totalPages': responseData['meta']['totalPages'],
      };
      print('🔄 Transformed: $transformed');

      try {
        final result = PaginatedMembersResponse.fromJson(transformed);
        print('✅ Parse successful: ${result.data.length} members');
        return result;
      } catch (parseError, stack) {
        print('❌ Parse error: $parseError');
        print('📚 Stack trace: $stack');
        rethrow;
      }
    } catch (e) {
      print('💥 API Client Error: $e');
      rethrow;
    }
  }

  /// Get member by ID
  /// GET /members/:id
  /// Reference: backend/src/modules/members/members.controller.ts line 95-109
  Future<MemberModel> getMember(String id) async {
    try {
      final response = await _dioClient.get('/members/$id');

      return MemberModel.fromJson(response.data as Map<String, dynamic>);
    } catch (e) {
      rethrow;
    }
  }

  /// Create new member
  /// POST /members
  /// Reference: backend/src/modules/members/members.controller.ts line 41-49
  Future<MemberModel> createMember(Map<String, dynamic> data) async {
    try {
      final response = await _dioClient.post(
        '/members',
        data: data,
      );

      return MemberModel.fromJson(response.data as Map<String, dynamic>);
    } catch (e) {
      rethrow;
    }
  }

  /// Update member
  /// PATCH /members/:id
  /// Reference: backend/src/modules/members/members.controller.ts line 111-124
  Future<MemberModel> updateMember(String id, Map<String, dynamic> data) async {
    try {
      final response = await _dioClient.patch(
        '/members/$id',
        data: data,
      );

      return MemberModel.fromJson(response.data as Map<String, dynamic>);
    } catch (e) {
      rethrow;
    }
  }

  /// Delete member (soft delete)
  /// DELETE /members/:id
  /// Reference: backend/src/modules/members/members.controller.ts line 126-135
  Future<void> deleteMember(String id) async {
    try {
      await _dioClient.delete('/members/$id');
    } catch (e) {
      rethrow;
    }
  }

  /// Restore soft-deleted member
  /// POST /members/:id/restore
  /// Reference: backend/src/modules/members/members.controller.ts line 137-148
  Future<MemberModel> restoreMember(String id) async {
    try {
      final response = await _dioClient.post('/members/$id/restore');

      return MemberModel.fromJson(response.data as Map<String, dynamic>);
    } catch (e) {
      rethrow;
    }
  }

  /// Get member statistics
  /// GET /members/stats
  /// Reference: backend/src/modules/members/members.controller.ts line 75-82
  Future<MemberStatsResponse> getStats() async {
    try {
      final response = await _dioClient.get('/members/stats');

      return MemberStatsResponse.fromJson(
        response.data as Map<String, dynamic>,
      );
    } catch (e) {
      rethrow;
    }
  }

  /// Export members to CSV
  /// GET /members/export
  /// Reference: backend/src/modules/members/members.controller.ts line 84-93
  Future<String> exportMembers({
    String? search,
    String? gender,
    String? membershipStatus,
    String? maritalStatus,
  }) async {
    try {
      final queryParams = <String, dynamic>{
        if (search != null) 'search': search,
        if (gender != null) 'gender': gender,
        if (membershipStatus != null) 'membershipStatus': membershipStatus,
        if (maritalStatus != null) 'maritalStatus': maritalStatus,
      };

      final response = await _dioClient.get(
        '/members/export',
        queryParameters: queryParams,
      );

      return response.data as String;
    } catch (e) {
      rethrow;
    }
  }
}
