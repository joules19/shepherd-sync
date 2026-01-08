/// Custom exception for API errors
/// Provides consistent error handling across the app
class ApiException implements Exception {
  final String message;
  final int statusCode;
  final Map<String, dynamic>? errors;

  ApiException({
    required this.message,
    required this.statusCode,
    this.errors,
  });

  @override
  String toString() {
    if (errors != null && errors!.isNotEmpty) {
      return 'ApiException($statusCode): $message\nErrors: $errors';
    }
    return 'ApiException($statusCode): $message';
  }

  /// Check if error is due to network issues
  bool get isNetworkError => statusCode == 0;

  /// Check if error is due to authentication
  bool get isAuthError => statusCode == 401;

  /// Check if error is due to authorization
  bool get isForbiddenError => statusCode == 403;

  /// Check if error is a validation error
  bool get isValidationError => statusCode == 422 || (errors != null && errors!.isNotEmpty);

  /// Check if error is a server error
  bool get isServerError => statusCode >= 500;
}
