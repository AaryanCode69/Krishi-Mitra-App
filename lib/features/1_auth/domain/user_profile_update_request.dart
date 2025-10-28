/// Data Transfer Object for User Profile Update Request
class UserProfileUpdateRequest {
  final String fullName;
  final String city;
  final String state;
  final String district;

  const UserProfileUpdateRequest({
    required this.fullName,
    required this.city,
    required this.state,
    required this.district,
  });

  /// Convert to JSON for API request
  Map<String, dynamic> toJson() {
    return {
      'fullName': fullName,
      'city': city,
      'state': state,
      'district': district,
    };
  }
}
