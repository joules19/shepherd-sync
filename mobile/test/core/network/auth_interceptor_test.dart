import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:shepherd_sync_mobile/core/constants/app_constants.dart';
import 'package:shepherd_sync_mobile/core/network/auth_interceptor.dart';

// Mock classes
class MockSecureStorage extends Mock implements FlutterSecureStorage {}

class MockDio extends Mock implements Dio {}

class MockRequestOptions extends Mock implements RequestOptions {}

class MockRequestInterceptorHandler extends Mock
    implements RequestInterceptorHandler {}

class MockErrorInterceptorHandler extends Mock
    implements ErrorInterceptorHandler {}

class MockResponse extends Mock implements Response {}

void main() {
  late AuthInterceptor authInterceptor;
  late MockSecureStorage mockSecureStorage;
  late MockDio mockDio;

  setUpAll(() {
    // Register fallback values for mocktail
    registerFallbackValue(RequestOptions(path: ''));
    registerFallbackValue(
      DioException(
        requestOptions: RequestOptions(path: ''),
      ),
    );
  });

  setUp(() {
    mockSecureStorage = MockSecureStorage();
    mockDio = MockDio();
    authInterceptor = AuthInterceptor(mockSecureStorage, mockDio);
  });

  group('AuthInterceptor - onRequest', () {
    test('should add Authorization header when access token exists', () async {
      // Arrange
      const accessToken = 'test_access_token';
      const organizationId = 'test_org_id';
      final options = RequestOptions(path: '/api/test');
      final handler = MockRequestInterceptorHandler();

      when(() => mockSecureStorage.read(key: AppConstants.keyAccessToken))
          .thenAnswer((_) async => accessToken);
      when(() => mockSecureStorage.read(key: AppConstants.keyOrganizationId))
          .thenAnswer((_) async => organizationId);
      when(() => handler.next(any())).thenReturn(null);

      // Act
      await authInterceptor.onRequest(options, handler);

      // Assert
      expect(options.headers['Authorization'], 'Bearer $accessToken');
      expect(options.headers['X-Organization-Id'], organizationId);
      verify(() => handler.next(options)).called(1);
    });

    test('should not add Authorization header when no token exists', () async {
      // Arrange
      final options = RequestOptions(path: '/api/test');
      final handler = MockRequestInterceptorHandler();

      when(() => mockSecureStorage.read(key: AppConstants.keyAccessToken))
          .thenAnswer((_) async => null);
      when(() => mockSecureStorage.read(key: AppConstants.keyOrganizationId))
          .thenAnswer((_) async => null);
      when(() => handler.next(any())).thenReturn(null);

      // Act
      await authInterceptor.onRequest(options, handler);

      // Assert
      expect(options.headers['Authorization'], isNull);
      verify(() => handler.next(options)).called(1);
    });
  });

  group('AuthInterceptor - onError (401 handling)', () {
    test('should not retry for /auth/refresh endpoint', () async {
      // Arrange
      final options = RequestOptions(path: '/auth/refresh');
      final response = Response(
        requestOptions: options,
        statusCode: 401,
      );
      final error = DioException(
        requestOptions: options,
        response: response,
      );
      final handler = MockErrorInterceptorHandler();

      when(() => handler.next(any())).thenReturn(null);

      // Act
      await authInterceptor.onError(error, handler);

      // Assert
      verify(() => handler.next(error)).called(1);
      verifyNever(
        () => mockSecureStorage.read(key: AppConstants.keyRefreshToken),
      );
    });

    test('should not retry for /auth/login endpoint', () async {
      // Arrange
      final options = RequestOptions(path: '/auth/login');
      final response = Response(
        requestOptions: options,
        statusCode: 401,
      );
      final error = DioException(
        requestOptions: options,
        response: response,
      );
      final handler = MockErrorInterceptorHandler();

      when(() => handler.next(any())).thenReturn(null);

      // Act
      await authInterceptor.onError(error, handler);

      // Assert
      verify(() => handler.next(error)).called(1);
      verifyNever(
        () => mockSecureStorage.read(key: AppConstants.keyRefreshToken),
      );
    });

    test('should propagate error when no refresh token exists', () async {
      // Arrange
      final options = RequestOptions(path: '/api/members');
      final response = Response(
        requestOptions: options,
        statusCode: 401,
      );
      final error = DioException(
        requestOptions: options,
        response: response,
      );
      final handler = MockErrorInterceptorHandler();

      when(() => mockSecureStorage.read(key: AppConstants.keyRefreshToken))
          .thenAnswer((_) async => null);
      when(() => handler.next(any())).thenReturn(null);

      // Act
      await authInterceptor.onError(error, handler);

      // Assert
      verify(() => handler.next(error)).called(1);
    });

    test('should propagate non-401 errors without attempting refresh',
        () async {
      // Arrange
      final options = RequestOptions(path: '/api/members');
      final response = Response(
        requestOptions: options,
        statusCode: 500,
      );
      final error = DioException(
        requestOptions: options,
        response: response,
      );
      final handler = MockErrorInterceptorHandler();

      when(() => handler.next(any())).thenReturn(null);

      // Act
      await authInterceptor.onError(error, handler);

      // Assert
      verify(() => handler.next(error)).called(1);
      verifyNever(
        () => mockSecureStorage.read(key: AppConstants.keyRefreshToken),
      );
    });
  });

  group('AuthInterceptor - token cleanup', () {
    test('should clear all auth data on refresh failure', () async {
      // Arrange
      final options = RequestOptions(path: '/api/members');
      final response = Response(
        requestOptions: options,
        statusCode: 401,
      );
      final error = DioException(
        requestOptions: options,
        response: response,
      );
      final handler = MockErrorInterceptorHandler();

      when(() => mockSecureStorage.read(key: AppConstants.keyRefreshToken))
          .thenAnswer((_) async => 'invalid_refresh_token');
      when(() => mockSecureStorage.delete(key: any(named: 'key')))
          .thenAnswer((_) async => {});
      when(() => handler.next(any())).thenReturn(null);

      // Mock Dio to throw error on refresh
      when(() => mockDio.options).thenReturn(BaseOptions());
      when(
        () => mockDio.post(
          any(),
          data: any(named: 'data'),
        ),
      ).thenThrow(
        DioException(
          requestOptions: RequestOptions(path: '/auth/refresh'),
          response: Response(
            requestOptions: RequestOptions(path: '/auth/refresh'),
            statusCode: 401,
          ),
        ),
      );

      // Act
      await authInterceptor.onError(error, handler);

      // Assert
      verify(() => mockSecureStorage.delete(key: AppConstants.keyAccessToken))
          .called(1);
      verify(
        () => mockSecureStorage.delete(key: AppConstants.keyRefreshToken),
      ).called(1);
      verify(() => mockSecureStorage.delete(key: AppConstants.keyUserId))
          .called(1);
      verify(
        () => mockSecureStorage.delete(key: AppConstants.keyOrganizationId),
      ).called(1);
      verify(() => mockSecureStorage.delete(key: AppConstants.keyUserRole))
          .called(1);
    });
  });
}
