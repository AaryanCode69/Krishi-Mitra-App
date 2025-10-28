import 'package:dio/dio.dart';
import 'package:krishi_mitra/core/constant/api_constants.dart';
import 'package:krishi_mitra/features/1_auth/domain/exceptions/otp_verification_failure.dart';
import 'package:krishi_mitra/features/1_auth/domain/exceptions/profile_update_failure.dart';
import 'package:krishi_mitra/features/1_auth/domain/exceptions/refresh_token_expired_failure.dart';
import 'package:krishi_mitra/features/1_auth/domain/login_response.dart';
import 'package:krishi_mitra/features/1_auth/domain/user_profile_update_request.dart';
import 'package:krishi_mitra/features/1_auth/domain/verify_otp_request.dart';

/// Repository for authentication-related operations
class AuthRepository {
  final Dio _dio;
  final Dio _refreshDio; // Separate Dio instance for refresh calls

  AuthRepository({required Dio dio, required Dio refreshDio})
      : _dio = dio,
        _refreshDio = refreshDio;

  /// Verifies OTP and returns login response with tokens
  /// 
  /// Throws [OtpVerificationFailure] if verification fails
  Future<LoginResponse> verifyOtp(VerifyOtpRequest requestData) async {
    try {
      // Make POST request to verify OTP endpoint
      final response = await _dio.post(
        ApiConstants.verifyOtpEndpoint,
        data: requestData.toJson(),
      );

      // Check if response is successful (200 OK)
      if (response.statusCode == 200) {
        // Parse response data
        final responseData = response.data as Map<String, dynamic>;
        return LoginResponse.fromJson(responseData);
      }

      // If status code is not 200, throw exception
      throw const OtpVerificationFailure('Invalid OTP or request failed');
    } on DioException catch (e) {
      // Handle Dio-specific errors
      if (e.response != null) {
        // Server returned an error response
        final statusCode = e.response!.statusCode;
        final errorMessage = e.response!.data?['message'] ?? 
                           e.response!.data?['error'] ?? 
                           'Invalid OTP or request failed';
        
        if (statusCode == 400 || statusCode == 401) {
          throw OtpVerificationFailure(errorMessage);
        } else if (statusCode == 404) {
          throw const OtpVerificationFailure('Service not found');
        } else if (statusCode! >= 500) {
          throw const OtpVerificationFailure('Server error. Please try again later');
        }
        
        throw OtpVerificationFailure(errorMessage);
      } else if (e.type == DioExceptionType.connectionTimeout ||
                 e.type == DioExceptionType.receiveTimeout) {
        throw const OtpVerificationFailure('Connection timeout. Please check your internet');
      } else if (e.type == DioExceptionType.connectionError) {
        throw const OtpVerificationFailure('No internet connection');
      }
      
      throw const OtpVerificationFailure('An error occurred. Please try again');
    } catch (e) {
      // Handle any other errors
      throw OtpVerificationFailure('Unexpected error: ${e.toString()}');
    }
  }

  /// Completes user profile after OTP verification
  /// 
  /// Requires valid access token in Authorization header (handled by Dio interceptor)
  /// Throws [ProfileUpdateFailure] if update fails
  Future<void> completeUserProfile(UserProfileUpdateRequest profileData) async {
    try {
      // Make POST request to complete profile endpoint
      // The Dio interceptor will automatically add the Authorization header
      final response = await _dio.post(
        ApiConstants.completeProfileEndpoint,
        data: profileData.toJson(),
      );

      // Check if response is successful (200 OK or 201 Created)
      if (response.statusCode != null && 
          response.statusCode! >= 200 && 
          response.statusCode! < 300) {
        // Profile updated successfully (any 2xx status code)
        return;
      }

      // If status code is not in 2xx range, throw exception
      throw const ProfileUpdateFailure('Failed to update profile');
    } on DioException catch (e) {
      // Handle Dio-specific errors
      if (e.response != null) {
        // Server returned an error response
        final statusCode = e.response!.statusCode;
        final errorMessage = e.response!.data?['message'] ?? 
                           e.response!.data?['error'] ?? 
                           'Failed to update profile';
        
        if (statusCode == 400) {
          throw ProfileUpdateFailure('Invalid profile data: $errorMessage');
        } else if (statusCode == 401) {
          throw const ProfileUpdateFailure('Unauthorized. Please login again');
        } else if (statusCode == 404) {
          throw const ProfileUpdateFailure('Service not found');
        } else if (statusCode! >= 500) {
          throw const ProfileUpdateFailure('Server error. Please try again later');
        }
        
        throw ProfileUpdateFailure(errorMessage);
      } else if (e.type == DioExceptionType.connectionTimeout ||
                 e.type == DioExceptionType.receiveTimeout) {
        throw const ProfileUpdateFailure('Connection timeout. Please check your internet');
      } else if (e.type == DioExceptionType.connectionError) {
        throw const ProfileUpdateFailure('No internet connection');
      }
      
      throw const ProfileUpdateFailure('An error occurred. Please try again');
    } catch (e) {
      // Handle any other errors
      throw ProfileUpdateFailure('Unexpected error: ${e.toString()}');
    }
  }

  /// Refreshes the access token using the refresh token
  /// 
  /// Uses a separate Dio instance without Authorization header
  /// Throws [RefreshTokenExpiredFailure] if refresh token is invalid/expired
  Future<LoginResponse> refreshToken(String refreshToken) async {
    try {
      // Make POST request to refresh token endpoint
      // Use _refreshDio to avoid adding Authorization header
      final response = await _refreshDio.post(
        '${ApiConstants.refreshTokenEndpoint}?refreshToken=$refreshToken',
      );

      // Check if response is successful (200 OK)
      if (response.statusCode != null &&
          response.statusCode! >= 200 &&
          response.statusCode! < 300) {
        // Parse response data
        final responseData = response.data as Map<String, dynamic>;
        return LoginResponse.fromJson(responseData);
      }

      // If status code is not in 2xx range, throw exception
      throw const RefreshTokenExpiredFailure('Failed to refresh token');
    } on DioException catch (e) {
      // Handle Dio-specific errors
      if (e.response != null) {
        // Server returned an error response
        final statusCode = e.response!.statusCode;

        // 401 or 403 means refresh token is invalid/expired
        if (statusCode == 401 || statusCode == 403) {
          throw const RefreshTokenExpiredFailure(
              'Refresh token expired or invalid');
        }

        final errorMessage = e.response!.data?['message'] ??
            e.response!.data?['error'] ??
            'Failed to refresh token';

        if (statusCode == 404) {
          throw const RefreshTokenExpiredFailure('Service not found');
        } else if (statusCode! >= 500) {
          throw const RefreshTokenExpiredFailure(
              'Server error. Please try again later');
        }

        throw RefreshTokenExpiredFailure(errorMessage);
      } else if (e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.receiveTimeout) {
        throw const RefreshTokenExpiredFailure(
            'Connection timeout. Please check your internet');
      } else if (e.type == DioExceptionType.connectionError) {
        throw const RefreshTokenExpiredFailure('No internet connection');
      }

      throw const RefreshTokenExpiredFailure(
          'An error occurred. Please try again');
    } catch (e) {
      // Handle any other errors
      throw RefreshTokenExpiredFailure('Unexpected error: ${e.toString()}');
    }
  }
}
