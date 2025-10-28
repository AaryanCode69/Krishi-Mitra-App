/// Data Transfer Object for OTP Verification Request
class VerifyOtpRequest {
  final String phoneNumber;
  final String otp;

  const VerifyOtpRequest({
    required this.phoneNumber,
    required this.otp,
  });

  /// Convert to JSON for API request
  Map<String, dynamic> toJson() {
    return {
      'phoneNumber': phoneNumber,
      'otp': otp,
    };
  }
}
