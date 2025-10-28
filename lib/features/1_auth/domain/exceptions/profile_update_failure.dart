/// Custom exception for profile update failures
class ProfileUpdateFailure implements Exception {
  final String message;

  const ProfileUpdateFailure(this.message);

  @override
  String toString() => 'ProfileUpdateFailure: $message';
}
