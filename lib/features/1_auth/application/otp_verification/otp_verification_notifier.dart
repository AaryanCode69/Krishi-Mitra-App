import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'otp_verification_state.dart';

class OtpVerificationNotifier extends StateNotifier<OtpVerificationState> {
  OtpVerificationNotifier()
    : _otpController = TextEditingController(),
      _formKey = GlobalKey<FormState>(),
      super(const OtpVerificationState());

  final TextEditingController _otpController;
  final GlobalKey<FormState> _formKey;

  TextEditingController get otpController => _otpController;
  GlobalKey<FormState> get formKey => _formKey;

  String? validateOtp(String? value) {
    return null;
  }

  void onOtpChanged(String value) {
    if (state.errorMessage != null) {
      state = state.copyWith(resetError: true);
    }
  }

  Future<void> verifyOtp(BuildContext context) async {
    if (!context.mounted) return;
    GoRouter.of(context).push('/create-account');
  }

  Future<void> resendCode(BuildContext context) async {
    if (!context.mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('We have resent the OTP to your number.')),
    );
  }

  @override
  void dispose() {
    _otpController.dispose();
    super.dispose();
  }
}
