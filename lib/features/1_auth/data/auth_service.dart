import 'package:dio/dio.dart';
import 'package:krishi_mitra/core/constant/api_constants.dart';

/// Authentication Service
/// 
/// Handles all authentication-related API calls including
/// sending OTP, verifying OTP, etc.
class AuthService {
  final Dio _dio;

  AuthService({Dio? dio}) : _dio = dio ?? Dio() {
    _dio.options.baseUrl = ApiConstants.baseUrl;
    _dio.options.connectTimeout = const Duration(seconds: 10);
    _dio.options.receiveTimeout = const Duration(seconds: 10);
  }

  /// Sends OTP to the provided phone number
  /// 
  /// [phoneNumber] should be a 10-digit number without country code
  /// Returns true if OTP was sent successfully (200 OK), false otherwise
  Future<bool> sendOtp(String phoneNumber) async {
    try {
      // Prepend +91 country code
      final fullPhoneNumber = '+91$phoneNumber';
      
      // Construct the endpoint URL
      final endpoint = '${ApiConstants.getOtpEndpoint}/$fullPhoneNumber';
      
      // Make GET request
      final response = await _dio.get(endpoint);
      
      // Check if response is successful (200 OK)
      if (response.statusCode == 200) {
        return true;
      }
      
      return false;
    } on DioException catch (e) {
      // Handle Dio-specific errors
      if (e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.receiveTimeout) {
        // Timeout error
        return false;
      } else if (e.type == DioExceptionType.connectionError) {
        // No internet connection
        return false;
      } else if (e.response != null) {
        // Server returned an error response
        return false;
      }
      
      return false;
    } catch (e) {
      // Handle any other errors
      return false;
    }
  }

  /// Gets the full phone number with country code
  /// 
  /// [phoneNumber] should be a 10-digit number without country code
  /// Returns the phone number with +91 prefix
  String getFullPhoneNumber(String phoneNumber) {
    return '+91$phoneNumber';
  }
}
