import 'package:flutter_riverpod/flutter_riverpod.dart';

class OtpVerificationState {
  const OtpVerificationState({
    this.status = const AsyncData(null),
    this.errorMessage,
  });

  final AsyncValue<void> status;
  final String? errorMessage;

  OtpVerificationState copyWith({
    AsyncValue<void>? status,
    String? errorMessage,
    bool resetError = false,
  }) {
    return OtpVerificationState(
      status: status ?? this.status,
      errorMessage: resetError ? null : (errorMessage ?? this.errorMessage),
    );
  }
}
