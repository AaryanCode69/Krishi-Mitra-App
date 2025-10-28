/// Custom exception for OTP verification failures
class OtpVerificationFailure implements Exception {
  final String message;

  const OtpVerificationFailure(this.message);

  @override
  String toString() => 'OtpVerificationFailure: $message';
}
