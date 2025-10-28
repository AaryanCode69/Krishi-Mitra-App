/// Data Transfer Object for Login Response
class LoginResponse {
  final String userId;
  final String accessToken;
  final String refreshToken;

  const LoginResponse({
    required this.userId,
    required this.accessToken,
    required this.refreshToken,
  });

  /// Create from JSON response
  factory LoginResponse.fromJson(Map<String, dynamic> json) {
    return LoginResponse(
      userId: json['userId'] as String,
      accessToken: json['accessToken'] as String,
      refreshToken: json['refreshToken'] as String,
    );
  }

  /// Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'accessToken': accessToken,
      'refreshToken': refreshToken,
    };
  }
}
