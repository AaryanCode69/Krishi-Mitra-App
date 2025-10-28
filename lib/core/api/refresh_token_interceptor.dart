import 'package:dio/dio.dart';
import 'package:krishi_mitra/core/constant/api_constants.dart';
import 'package:krishi_mitra/core/services/secure_storage_service.dart';
import 'package:krishi_mitra/features/1_auth/data/auth_repository.dart';
import 'package:krishi_mitra/features/1_auth/domain/exceptions/refresh_token_expired_failure.dart';

/// Interceptor to handle automatic token refresh on 401 errors
class RefreshTokenInterceptor extends Interceptor {
  final SecureStorageService _secureStorageService;
  final AuthRepository _authRepository;
  final Dio _dio;
  final Function() _onTokenExpired; // Callback to trigger logout

  bool _isRefreshing = false;
  final List<_RequestRetry> _requestsToRetry = [];

  RefreshTokenInterceptor({
    required SecureStorageService secureStorageService,
    required AuthRepository authRepository,
    required Dio dio,
    required Function() onTokenExpired,
  })  : _secureStorageService = secureStorageService,
        _authRepository = authRepository,
        _dio = dio,
        _onTokenExpired = onTokenExpired;

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    // Check if error is 401 Unauthorized
    if (err.response?.statusCode == 401) {
      print('401 Unauthorized detected'); // Debug log

      // Prevent infinite loop: Don't refresh if the failed request was the refresh endpoint
      if (err.requestOptions.path.contains(ApiConstants.refreshTokenEndpoint)) {
        print('Refresh token endpoint failed, triggering logout'); // Debug log
        _onTokenExpired();
        return handler.next(err);
      }

      // If already refreshing, queue this request
      if (_isRefreshing) {
        print('Already refreshing, queuing request'); // Debug log
        _requestsToRetry.add(_RequestRetry(err.requestOptions, handler));
        return;
      }

      _isRefreshing = true;

      try {
        // Get stored refresh token
        final storedRefreshToken =
            await _secureStorageService.getRefreshToken();

        if (storedRefreshToken == null || storedRefreshToken.isEmpty) {
          print('No refresh token found, triggering logout'); // Debug log
          _isRefreshing = false;
          _onTokenExpired();
          return handler.reject(err);
        }

        print('Attempting to refresh token...'); // Debug log

        // Attempt to refresh the token
        final loginResponse =
            await _authRepository.refreshToken(storedRefreshToken);

        print('Token refresh successful!'); // Debug log

        // Save new tokens
        await _secureStorageService.saveTokens(
          accessToken: loginResponse.accessToken,
          refreshToken: loginResponse.refreshToken,
        );

        print('New tokens saved'); // Debug log

        // Retry the original failed request with new token
        final newAccessToken = loginResponse.accessToken;
        err.requestOptions.headers['Authorization'] = 'Bearer $newAccessToken';

        print('Retrying original request...'); // Debug log

        // Retry the original request
        final response = await _dio.fetch(err.requestOptions);

        print('Original request succeeded after refresh'); // Debug log

        _isRefreshing = false;

        // Retry all queued requests
        await _retryQueuedRequests(newAccessToken);

        // Resolve with the successful response
        return handler.resolve(response);
      } on RefreshTokenExpiredFailure catch (e) {
        print('Refresh token expired: ${e.message}'); // Debug log
        _isRefreshing = false;
        _requestsToRetry.clear();
        _onTokenExpired();
        return handler.reject(err);
      } catch (e) {
        print('Error during token refresh: $e'); // Debug log
        _isRefreshing = false;
        _requestsToRetry.clear();
        _onTokenExpired();
        return handler.reject(err);
      }
    }

    // If not a 401 error, pass it along
    return handler.next(err);
  }

  /// Retry all queued requests with the new access token
  Future<void> _retryQueuedRequests(String newAccessToken) async {
    print('Retrying ${_requestsToRetry.length} queued requests'); // Debug log

    for (final retry in _requestsToRetry) {
      try {
        retry.requestOptions.headers['Authorization'] =
            'Bearer $newAccessToken';
        final response = await _dio.fetch(retry.requestOptions);
        retry.handler.resolve(response);
      } catch (e) {
        retry.handler.reject(
          DioException(
            requestOptions: retry.requestOptions,
            error: e,
          ),
        );
      }
    }

    _requestsToRetry.clear();
  }
}

/// Helper class to store requests that need to be retried
class _RequestRetry {
  final RequestOptions requestOptions;
  final ErrorInterceptorHandler handler;

  _RequestRetry(this.requestOptions, this.handler);
}
