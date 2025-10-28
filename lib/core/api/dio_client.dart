import 'package:dio/dio.dart';
import 'package:krishi_mitra/core/constant/api_constants.dart';
import 'package:krishi_mitra/core/services/secure_storage_service.dart';

/// Configured Dio client with interceptors
class DioClient {
  final SecureStorageService _secureStorageService;
  late final Dio _dio;

  DioClient({required SecureStorageService secureStorageService})
    : _secureStorageService = secureStorageService {
    _dio = Dio(_baseOptions);
    _dio.interceptors.add(_authInterceptor());
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
      onError: (error, handler) async {
        // Handle 401 Unauthorized errors (token expired)
        if (error.response?.statusCode == 401) {
          // TODO: Implement token refresh logic here
          // For now, just pass the error
        }

        handler.next(error);
      },
    );
  }

  /// Get the configured Dio instance
  Dio get dio => _dio;
}
