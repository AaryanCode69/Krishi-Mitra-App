import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:krishi_mitra/core/services/secure_storage_service.dart';
import 'package:krishi_mitra/features/1_auth/application/auth_state.dart';
import 'package:krishi_mitra/features/1_auth/data/auth_repository.dart';
import 'package:krishi_mitra/features/1_auth/domain/exceptions/otp_verification_failure.dart';
import 'package:krishi_mitra/features/1_auth/domain/exceptions/profile_update_failure.dart';
import 'package:krishi_mitra/features/1_auth/domain/user_profile_update_request.dart';
import 'package:krishi_mitra/features/1_auth/domain/verify_otp_request.dart';

/// Auth Notifier for managing authentication state
class AuthNotifier extends StateNotifier<AuthState> {
  final AuthRepository _authRepository;
  final SecureStorageService _secureStorageService;

  AuthNotifier({
    required AuthRepository authRepository,
    required SecureStorageService secureStorageService,
  })  : _authRepository = authRepository,
        _secureStorageService = secureStorageService,
        super(const AuthState.initial());

  /// Verify OTP and handle authentication
  Future<void> verifyOtp(String phoneNumber, String otp) async {
    // Set state to loading
    state = const AuthState.loading();

    try {
      // Create request object
      final requestData = VerifyOtpRequest(
        phoneNumber: phoneNumber,
        otp: otp,
      );

      // Call repository to verify OTP
      final loginResponse = await _authRepository.verifyOtp(requestData);

      // Store tokens securely
      await _secureStorageService.saveTokens(
        accessToken: loginResponse.accessToken,
        refreshToken: loginResponse.refreshToken,
      );

      // Decode access token to extract profileComplete claim
      print('🔐 [Auth Notifier] Decoding JWT token...');
      final decodedToken = JwtDecoder.decode(loginResponse.accessToken);
      print('🔐 [Auth Notifier] Decoded token: $decodedToken');
      
      final profileComplete = decodedToken['profileComplete'] as bool? ?? false;
      print('🔐 [Auth Notifier] Profile complete value: $profileComplete');
      print('🔐 [Auth Notifier] User ID: ${loginResponse.userId}');

      // Set state to success with profileComplete value
      state = AuthState.success(
        profileCompleteValue: profileComplete,
        userId: loginResponse.userId,
      );
      
      print('✅ [Auth Notifier] State set to success with profileComplete: $profileComplete');
    } on OtpVerificationFailure catch (e) {
      // Handle OTP verification failure
      state = AuthState.error(e.message);
    } catch (e) {
      // Handle any other errors
      state = AuthState.error('An unexpected error occurred: ${e.toString()}');
    }
  }

  /// Reset state to initial
  void reset() {
    state = const AuthState.initial();
  }

  /// Logout user
  Future<void> logout() async {
    await _secureStorageService.deleteAllTokens();
    state = const AuthState.initial();
  }

  /// Complete user profile after OTP verification
  /// 
  /// Returns true if profile update is successful, false otherwise
  Future<bool> completeUserProfile({
    required String fullName,
    required String city,
    required String state,
    required String district,
  }) async {
    // Set state to indicate profile update is loading
    this.state = this.state.copyWith(
      isUpdatingProfile: true,
      clearProfileUpdateError: true,
    );

    try {
      // Create profile update request
      final profileData = UserProfileUpdateRequest(
        fullName: fullName,
        city: city,
        state: state,
        district: district,
      );

      print('Calling repository.completeUserProfile...'); // Debug log

      // Call repository to complete profile
      await _authRepository.completeUserProfile(profileData);

      print('Repository call successful!'); // Debug log

      // Set state to indicate loading finished successfully
      this.state = this.state.copyWith(
        isUpdatingProfile: false,
        profileComplete: true,
        clearProfileUpdateError: true,
      );

      print('State updated to success'); // Debug log

      return true;
    } on ProfileUpdateFailure catch (e) {
      // Handle profile update failure
      print('ProfileUpdateFailure caught: ${e.message}'); // Debug log
      this.state = this.state.copyWith(
        isUpdatingProfile: false,
        profileUpdateError: e.message,
      );
      return false;
    } catch (e) {
      // Handle any other errors
      print('Unexpected error caught: ${e.toString()}'); // Debug log
      print('Error type: ${e.runtimeType}'); // Debug log
      this.state = this.state.copyWith(
        isUpdatingProfile: false,
        profileUpdateError: 'An unexpected error occurred: ${e.toString()}',
      );
      return false;
    }
  }

  /// Clear profile update error
  void clearProfileUpdateError() {
    state = state.copyWith(clearProfileUpdateError: true);
  }
}
