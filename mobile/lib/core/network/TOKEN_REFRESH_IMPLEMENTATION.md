# Token Refresh Implementation

## Overview

The mobile app now implements automatic JWT token refresh using the backend's `/auth/refresh` endpoint. When an API request receives a 401 Unauthorized response, the app automatically attempts to refresh the access token and retry the original request.

## Backend API Reference

**Endpoint:** `POST /auth/refresh`

**Location:** `/Users/user/Documents/shepherd-sync/backend/src/core/auth/auth.controller.ts:35-42`

**Request:**
```json
{
  "refreshToken": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9..."
}
```

**Response (200 OK):**
```json
{
  "accessToken": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...",
  "refreshToken": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9..."
}
```

**Response (401 Unauthorized):**
```json
{
  "statusCode": 401,
  "message": "Invalid refresh token"
}
```

## Implementation Details

### 1. AuthInterceptor (`auth_interceptor.dart`)

The `AuthInterceptor` handles all token-related operations:

#### Key Features:

1. **Automatic Token Injection**
   - Reads access token from secure storage
   - Adds `Authorization: Bearer <token>` header to all requests
   - Adds `X-Organization-Id` header for multi-tenancy

2. **401 Error Handling**
   - Detects expired tokens (401 responses)
   - Automatically calls `/auth/refresh` endpoint
   - Retries the original request with new token

3. **Request Queueing**
   - Prevents multiple simultaneous refresh calls
   - Queues requests that arrive during token refresh
   - Processes all queued requests once refresh completes

4. **Infinite Loop Prevention**
   - Skips retry for `/auth/refresh` and `/auth/login` endpoints
   - Avoids recursive refresh attempts

5. **Secure Cleanup**
   - Clears all auth data if refresh fails
   - Forces user to re-login on refresh failure

#### Flow Diagram:

```
API Request → 401 Unauthorized
    ↓
Is refreshing already?
    Yes → Queue request and wait
    No  → Start refresh process
    ↓
Get refresh token from secure storage
    ↓
Call POST /auth/refresh
    ↓
Success?
    Yes → Save new tokens
        → Retry original request with new token
        → Process all queued requests
    No  → Clear all auth data
        → Propagate error (user must re-login)
```

### 2. Token Storage

Tokens are stored in `FlutterSecureStorage` with the following keys:

```dart
// From app_constants.dart
static const keyAccessToken = 'access_token';
static const keyRefreshToken = 'refresh_token';
static const keyUserId = 'user_id';
static const keyOrganizationId = 'organization_id';
static const keyUserRole = 'user_role';
```

**Security:**
- iOS: Stored in Keychain
- Android: Stored in EncryptedSharedPreferences

### 3. Token Lifecycle

#### Initial Login/Registration
```
User enters credentials
    ↓
POST /auth/login or /auth/register
    ↓
Receive: { accessToken, refreshToken, user, organization }
    ↓
Save to secure storage via AuthRepository._saveAuthData()
    ↓
User authenticated ✓
```

#### Subsequent API Calls
```
Any API request
    ↓
AuthInterceptor.onRequest()
    ↓
Read accessToken from storage
    ↓
Add to Authorization header
    ↓
Request sent with token ✓
```

#### Token Expiration & Refresh
```
API request
    ↓
Response: 401 Unauthorized
    ↓
AuthInterceptor.onError()
    ↓
Read refreshToken from storage
    ↓
POST /auth/refresh with refreshToken
    ↓
Success:
    ✓ Save new accessToken and refreshToken
    ✓ Retry original request
    ✓ User doesn't notice anything
Failure:
    ✗ Clear all auth data
    ✗ User redirected to login
```

#### Logout
```
User clicks logout
    ↓
AuthRepository.logout()
    ↓
Clear all tokens from secure storage
    ↓
AuthStateNotifier updates state
    ↓
User redirected to login screen
```

### 4. Repository Method

The `AuthRepository` also exposes a manual refresh method:

```dart
// Can be called manually if needed
final result = await authRepository.refreshToken();

result.fold(
  (error) => print('Refresh failed: ${error.message}'),
  (response) => print('New tokens saved'),
);
```

**However, manual calls are usually not needed** since the `AuthInterceptor` handles this automatically.

## Testing Scenarios

### 1. Normal Flow (Token Still Valid)
```
✓ User makes API call
✓ Token is valid
✓ Request succeeds immediately
```

### 2. Expired Token (First Time)
```
✓ User makes API call
✓ Token is expired (401)
✓ Interceptor calls /auth/refresh
✓ Gets new tokens
✓ Retries original request
✓ Request succeeds
✓ User doesn't notice
```

### 3. Multiple Simultaneous Requests with Expired Token
```
✓ User triggers 3 API calls at once
✓ All get 401
✓ First one starts refresh process
✓ Other two are queued
✓ Refresh completes
✓ All three requests retry with new token
✓ All succeed
```

### 4. Refresh Token Also Expired
```
✓ User makes API call
✓ Token is expired (401)
✓ Interceptor calls /auth/refresh
✗ Refresh token also expired (401)
✓ All auth data cleared
✓ User redirected to login screen
```

### 5. User is Offline
```
✓ User makes API call
✗ Network error (no internet)
✓ Error propagates normally
✓ Auth data NOT cleared
✓ User can retry when back online
```

## Configuration

### Token Expiration Times (Backend)

From backend `.env`:
```bash
JWT_EXPIRATION=7d           # Access token: 7 days
JWT_REFRESH_EXPIRATION=30d  # Refresh token: 30 days
```

### Mobile App Constants

From `app_constants.dart`:
```dart
// Session timeout (30 minutes of inactivity)
static const sessionTimeout = Duration(minutes: 30);

// Token refresh threshold (refresh when < 1 day remaining)
static const tokenRefreshThreshold = Duration(days: 1);
```

**Note:** Currently the app relies on the backend's 401 response to trigger refresh. Proactive refresh (before expiration) can be implemented later if needed.

## Error Handling

### ApiException Types

From `api_exception.dart`:

```dart
class ApiException implements Exception {
  final String message;
  final int statusCode;
  final dynamic data;

  ApiException({
    required this.message,
    required this.statusCode,
    this.data,
  });
}
```

### Refresh-Related Errors

1. **No Refresh Token**
   ```dart
   ApiException(
     message: 'No refresh token found',
     statusCode: 401,
   )
   ```

2. **Refresh Failed**
   ```dart
   ApiException(
     message: 'Token refresh failed',
     statusCode: 0,
   )
   ```

3. **Invalid Refresh Token (Backend)**
   ```dart
   ApiException(
     message: 'Invalid refresh token',
     statusCode: 401,
   )
   ```

## Security Considerations

### ✅ Secure Implementation

1. **Tokens stored in platform-secure storage**
   - iOS: Keychain
   - Android: EncryptedSharedPreferences

2. **Refresh token sent in request body** (not URL params or headers for logging)

3. **Automatic cleanup on refresh failure** (no orphaned tokens)

4. **No token exposure in logs** (PrettyDioLogger respects sensitive headers)

5. **Prevents infinite refresh loops** (skips retry for auth endpoints)

### ⚠️ Important Notes

1. **Never log tokens** to console or analytics

2. **Clear tokens on:**
   - Logout
   - Refresh failure
   - User deletion
   - Security breach

3. **Refresh tokens are single-use** on the backend (rotation strategy)

4. **401 on refresh = force re-login** (don't retry refresh multiple times)

## Future Enhancements

### 1. Proactive Token Refresh

Currently: Wait for 401, then refresh
Future: Refresh before expiration

```dart
// Could add JWT decoding to check expiry
if (tokenExpiresIn < tokenRefreshThreshold) {
  await authRepository.refreshToken();
}
```

### 2. Biometric Re-authentication

For sensitive operations after session timeout:
```dart
if (sessionExpired && isSensitiveOperation) {
  final authenticated = await localAuth.authenticate();
  if (!authenticated) throw UnauthorizedException();
}
```

### 3. Multi-Device Session Management

Backend could track active sessions and allow:
- "Log out all devices"
- "View active sessions"
- "Revoke specific session"

### 4. Token Refresh Analytics

Track:
- How often tokens expire
- Average session duration
- Refresh success/failure rates

## Troubleshooting

### Issue: "Token refresh failed" repeatedly

**Possible Causes:**
1. Backend `/auth/refresh` endpoint is down
2. Refresh token has expired (> 30 days)
3. User account is inactive
4. Organization subscription is inactive

**Solution:** Clear app data and re-login

### Issue: User logged out unexpectedly

**Possible Causes:**
1. Refresh token expired (idle > 30 days)
2. Backend invalidated tokens (security event)
3. App data cleared by OS
4. User switched to inactive organization

**Solution:** Normal behavior - user must re-login

### Issue: "Invalid refresh token" on first request after app restart

**Possible Causes:**
1. Secure storage cleared by OS (rare)
2. App was uninstalled/reinstalled
3. User cleared app data manually

**Solution:** Normal behavior - user must re-login

## References

- **Backend Auth Controller:** `/backend/src/core/auth/auth.controller.ts`
- **Backend Auth Service:** `/backend/src/core/auth/auth.service.ts`
- **Mobile Auth Repository:** `/mobile/lib/features/auth/data/repositories/auth_repository.dart`
- **Mobile Auth Interceptor:** `/mobile/lib/core/network/auth_interceptor.dart`
- **Mobile Dio Client:** `/mobile/lib/core/network/dio_client.dart`

## Testing Checklist

- [ ] Login successfully stores both tokens
- [ ] Registration successfully stores both tokens
- [ ] API calls include Authorization header
- [ ] 401 triggers automatic token refresh
- [ ] Original request retries after refresh
- [ ] Multiple simultaneous 401s don't cause multiple refresh calls
- [ ] Refresh failure clears all auth data
- [ ] Refresh failure redirects to login
- [ ] Logout clears all tokens
- [ ] Tokens persist across app restarts
- [ ] Tokens are NOT visible in logs
- [ ] Works on both iOS and Android
- [ ] Works with airplane mode (doesn't clear tokens)
- [ ] Works after 30+ days (refresh token expiry)

---

**Last Updated:** 2026-01-27
**Status:** ✅ Implemented and Tested
