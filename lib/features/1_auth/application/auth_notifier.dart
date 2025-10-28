import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:krishi_mitra/core/services/secure_storage_service.dart';
import 'package:krishi_mitra/features/1_auth/application/auth_state.dart';
import 'package:krishi_mitra/features/1_auth/data/auth_repository.dart';
import 'package:krishi_mitra/features/1_auth/domain/exceptions/otp_verification_failure.dart';
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
      final decodedToken = JwtDecoder.decode(loginResponse.accessToken);
      final profileComplete = decodedToken['profileComplete'] as bool? ?? false;

      // Set state to success with profileComplete value
      state = AuthState.success(
        profileCompleteValue: profileComplete,
        userId: loginResponse.userId,
      );
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
}
