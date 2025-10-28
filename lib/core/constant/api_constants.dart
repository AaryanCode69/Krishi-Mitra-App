/// API Configuration Constants
/// 
/// This file contains all API-related constants including base URLs
/// for different environments.

class ApiConstants {
  // Private constructor to prevent instantiation
  ApiConstants._();

  /// Base URL for the API
  /// Change this for different environments (development, staging, production)
  static const String baseUrl = 'https://cd24e4ea9e75.ngrok-free.app';

  /// API Endpoints
  static const String authEndpoint = '/api/auth';
  
  /// Get OTP endpoint
  /// Usage: ${ApiConstants.baseUrl}${ApiConstants.getOtpEndpoint}/{phoneNumber}
  static const String getOtpEndpoint = '$authEndpoint/getOtp';
  
  /// Verify OTP endpoint
  /// Usage: POST ${ApiConstants.baseUrl}${ApiConstants.verifyOtpEndpoint}
  static const String verifyOtpEndpoint = '$authEndpoint/verifyOtp';
}
