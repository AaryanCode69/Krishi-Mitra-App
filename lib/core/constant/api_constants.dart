/// API Configuration Constants
///
/// This file contains all API-related constants including base URLs
/// for different environments.

class ApiConstants {
  // Private constructor to prevent instantiation
  ApiConstants._();

  /// Base URL for the API
  /// Change this for different environments (development, staging, production)
  static const String baseUrl = 'https://70f3f21f9d28.ngrok-free.app';

  /// API Endpoints
  static const String authEndpoint = '/api/auth';

  /// Get OTP endpoint
  /// Usage: ${ApiConstants.baseUrl}${ApiConstants.getOtpEndpoint}/{phoneNumber}
  static const String getOtpEndpoint = '$authEndpoint/getOtp';

  /// Verify OTP endpoint
  /// Usage: POST ${ApiConstants.baseUrl}${ApiConstants.verifyOtpEndpoint}
  static const String verifyOtpEndpoint = '$authEndpoint/verifyOtp';

  /// Complete user profile endpoint
  /// Usage: POST ${ApiConstants.baseUrl}${ApiConstants.completeProfileEndpoint}
  /// Requires Authorization header with Bearer token
  static const String completeProfileEndpoint = '/signUp/register';

  /// Refresh token endpoint
  /// Usage: POST ${ApiConstants.baseUrl}${ApiConstants.refreshTokenEndpoint}?refreshToken={token}
  /// Does NOT require Authorization header
  static const String refreshTokenEndpoint = '$authEndpoint/refresh';

  /// Mandi prices endpoint
  /// Usage: GET ${ApiConstants.baseUrl}${ApiConstants.mandiPricesEndpoint}/{stateName}
  /// Example: GET http://localhost:8080/api/mandi/Tamil%20Nadu
  /// Requires Authorization header with Bearer token
  static const String mandiPricesEndpoint = '/api/mandi';
}
