/// Custom exception for refresh token expiration
class RefreshTokenExpiredFailure implements Exception {
  final String message;

  const RefreshTokenExpiredFailure(this.message);

  @override
  String toString() => 'RefreshTokenExpiredFailure: $message';
}
