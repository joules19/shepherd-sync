import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';
import '../models/dashboard_data.dart';

part 'dashboard_api_client.g.dart';

@RestApi()
abstract class DashboardApiClient {
  factory DashboardApiClient(Dio dio, {String baseUrl}) = _DashboardApiClient;

  @GET('/giving/stats')
  Future<GivingStats> getGivingStats({
    @Query("start") String? start,
    @Query("end") String? end,
  });

  @GET('/members/stats')
  Future<MemberStats> getMemberStats();

  @GET('/events/stats')
  Future<EventStats> getEventStats();

  @GET('/events')
  Future<PaginatedResult<UpcomingEvent>> getUpcomingEvents(
    @Query("startAfter") String startAfter,
    @Query("sortBy") String sortBy,
    @Query("sortOrder") String sortOrder,
    @Query("limit") int limit,
  );
}