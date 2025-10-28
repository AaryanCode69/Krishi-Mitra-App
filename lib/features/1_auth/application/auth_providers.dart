import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:krishi_mitra/core/api/dio_client.dart';
import 'package:krishi_mitra/core/constant/api_constants.dart';
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

// Base Dio Provider (without interceptors, for initial setup)
final baseDioProvider = Provider<Dio>((ref) {
  return Dio(BaseOptions(
    baseUrl: ApiConstants.baseUrl,
    connectTimeout: const Duration(seconds: 10),
    receiveTimeout: const Duration(seconds: 10),
    headers: {'Content-Type': 'application/json', 'Accept': 'application/json'},
  ));
});

// Refresh Dio Provider (for refresh token calls without auth header)
final refreshDioProvider = Provider<Dio>((ref) {
  return Dio(BaseOptions(
    baseUrl: ApiConstants.baseUrl,
    connectTimeout: const Duration(seconds: 10),
    receiveTimeout: const Duration(seconds: 10),
    headers: {'Content-Type': 'application/json', 'Accept': 'application/json'},
  ));
});

// Auth Repository Provider (created early to break circular dependency)
final authRepositoryProvider = Provider<AuthRepository>((ref) {
  final dio = ref.watch(baseDioProvider);
  final refreshDio = ref.watch(refreshDioProvider);
  return AuthRepository(dio: dio, refreshDio: refreshDio);
});

// Dio Client Provider (with interceptors)
final dioClientProvider = Provider<DioClient>((ref) {
  final secureStorageService = ref.watch(secureStorageServiceProvider);
  final authRepository = ref.watch(authRepositoryProvider);
  
  // Callback to trigger logout when refresh token expires
  void onTokenExpired() {
    Future.microtask(() {
      ref.read(authProvider.notifier).logout();
    });
  }
  
  return DioClient(
    secureStorageService: secureStorageService,
    authRepository: authRepository,
    onTokenExpired: onTokenExpired,
  );
});

// Dio Provider (configured with interceptors)
final dioProvider = Provider<Dio>((ref) {
  final dioClient = ref.watch(dioClientProvider);
  return dioClient.dio;
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
