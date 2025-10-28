import 'package:dio/dio.dart';
import 'package:krishi_mitra/core/constant/api_constants.dart';
import 'package:krishi_mitra/features/1_auth/domain/exceptions/otp_verification_failure.dart';
import 'package:krishi_mitra/features/1_auth/domain/login_response.dart';
import 'package:krishi_mitra/features/1_auth/domain/verify_otp_request.dart';

/// Repository for authentication-related operations
class AuthRepository {
  final Dio _dio;

  AuthRepository({required Dio dio}) : _dio = dio;

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
}
