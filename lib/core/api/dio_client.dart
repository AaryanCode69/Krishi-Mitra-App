import 'package:dio/dio.dart';
import 'package:krishi_mitra/core/api/refresh_token_interceptor.dart';
import 'package:krishi_mitra/core/constant/api_constants.dart';
import 'package:krishi_mitra/core/services/secure_storage_service.dart';
import 'package:krishi_mitra/features/1_auth/data/auth_repository.dart';

/// Configured Dio client with interceptors
class DioClient {
  final SecureStorageService _secureStorageService;
  final AuthRepository? _authRepository;
  final Function()? _onTokenExpired;
  late final Dio _dio;

  DioClient({
    required SecureStorageService secureStorageService,
    AuthRepository? authRepository,
    Function()? onTokenExpired,
  }) : _secureStorageService = secureStorageService,
       _authRepository = authRepository,
       _onTokenExpired = onTokenExpired {
    // Main Dio instance
    _dio = Dio(_baseOptions);

    // Add auth interceptor first
    _dio.interceptors.add(_authInterceptor());

    // Add refresh token interceptor if repository and callback are provided
    if (_authRepository != null && _onTokenExpired != null) {
      _dio.interceptors.add(
        RefreshTokenInterceptor(
          secureStorageService: _secureStorageService,
          authRepository: _authRepository,
          dio: _dio,
          onTokenExpired: _onTokenExpired,
        ),
      );
    }
  }

  /// Base options for Dio
  BaseOptions get _baseOptions => BaseOptions(
    baseUrl: ApiConstants.baseUrl,
    connectTimeout: const Duration(seconds: 10),
    receiveTimeout: const Duration(seconds: 10),
    headers: {'Content-Type': 'application/json', 'Accept': 'application/json'},
  );

  /// Auth interceptor to add Authorization header
  InterceptorsWrapper _authInterceptor() {
    return InterceptorsWrapper(
      onRequest: (options, handler) async {
        // Check if the request path is not an auth path
        final isAuthPath = options.path.contains('/api/auth/');

        if (!isAuthPath) {
          // Attempt to read access token
          final accessToken = await _secureStorageService.getAccessToken();

          if (accessToken != null && accessToken.isNotEmpty) {
            // Add Authorization header
            options.headers['Authorization'] = 'Bearer $accessToken';
          }
        }

        // Continue with the request
        handler.next(options);
      },
      // onError is now handled by RefreshTokenInterceptor
    );
  }

  /// Get the configured Dio instance
  Dio get dio => _dio;
}
