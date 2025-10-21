import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'create_account/create_account_notifier.dart';
import 'create_account/create_account_state.dart';
import 'otp_verification/otp_verification_notifier.dart';
import 'otp_verification/otp_verification_state.dart';

final otpVerificationProvider =
    StateNotifierProvider.autoDispose<OtpVerificationNotifier,
        OtpVerificationState>((ref) {
  return OtpVerificationNotifier();
});

final createAccountProvider =
    StateNotifierProvider.autoDispose<CreateAccountNotifier,
        CreateAccountState>((ref) {
  return CreateAccountNotifier(ref);
});
