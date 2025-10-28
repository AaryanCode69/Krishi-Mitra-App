import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:krishi_mitra/features/1_auth/data/auth_service.dart';

import 'create_account/create_account_notifier.dart';
import 'create_account/create_account_state.dart';
import 'otp_verification/otp_verification_notifier.dart';
import 'otp_verification/otp_verification_state.dart';

// Auth Service Provider
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
