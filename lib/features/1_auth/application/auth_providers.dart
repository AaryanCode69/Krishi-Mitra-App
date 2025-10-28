import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:krishi_mitra/core/api/dio_client.dart';
import 'package:krishi_mitra/core/services/secure_storage_service.dart';
import 'package:krishi_mitra/features/1_auth/application/auth_notifier.dart';
import 'package:krishi_mitra/features/1_auth/application/auth_state.dart';
import 'package:krishi_mitra/features/1_auth/data/auth_repository.dart';
import 'package:krishi_mitra/features/1_auth/data/auth_service.dart';

import 'create_account/create_account_notifier.dart';
import 'create_account/create_account_state.dart';
import 'otp_verification/otp_verification_notifier.dart';
import 'otp_verification/otp_verification_state.dart';

// Secure Storage Service Provider
final secureStorageServiceProvider = Provider<SecureStorageService>((ref) {
  return SecureStorageService();
});

// Dio Client Provider (with interceptors)
final dioClientProvider = Provider<DioClient>((ref) {
  final secureStorageService = ref.watch(secureStorageServiceProvider);
  return DioClient(secureStorageService: secureStorageService);
});

// Dio Provider
final dioProvider = Provider<Dio>((ref) {
  final dioClient = ref.watch(dioClientProvider);
  return dioClient.dio;
});

// Auth Repository Provider
final authRepositoryProvider = Provider<AuthRepository>((ref) {
  final dio = ref.watch(dioProvider);
  return AuthRepository(dio: dio);
});

// Auth Provider (Main authentication state management)
final authProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  final authRepository = ref.watch(authRepositoryProvider);
  final secureStorageService = ref.watch(secureStorageServiceProvider);
  
  return AuthNotifier(
    authRepository: authRepository,
    secureStorageService: secureStorageService,
  );
});

// Auth Service Provider (for sending OTP)
final authServiceProvider = Provider<AuthService>((ref) {
  return AuthService();
});

final otpVerificationProvider =
    StateNotifierProvider.autoDispose<
      OtpVerificationNotifier,
      OtpVerificationState
    >((ref) {
      return OtpVerificationNotifier();
    });

final createAccountProvider =
    StateNotifierProvider.autoDispose<
      CreateAccountNotifier,
      CreateAccountState
    >((ref) {
      return CreateAccountNotifier(ref);
    });
