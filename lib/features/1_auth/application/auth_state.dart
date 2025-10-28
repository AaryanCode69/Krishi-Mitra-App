/// Authentication state status
enum AuthStatus {
  initial,
  loading,
  success,
  error,
}

/// Authentication state
class AuthState {
  final AuthStatus status;
  final String? errorMessage;
  final bool? profileComplete;
  final String? userId;
  final bool isUpdatingProfile;
  final String? profileUpdateError;

  const AuthState({
    this.status = AuthStatus.initial,
    this.errorMessage,
    this.profileComplete,
    this.userId,
    this.isUpdatingProfile = false,
    this.profileUpdateError,
  });

  /// Create initial state
  const AuthState.initial()
      : status = AuthStatus.initial,
        errorMessage = null,
        profileComplete = null,
        userId = null,
        isUpdatingProfile = false,
        profileUpdateError = null;

  /// Create loading state
  const AuthState.loading()
      : status = AuthStatus.loading,
        errorMessage = null,
        profileComplete = null,
        userId = null,
        isUpdatingProfile = false,
        profileUpdateError = null;

  /// Create success state
  const AuthState.success({
    required bool profileCompleteValue,
    String? userId,
  })  : status = AuthStatus.success,
        profileComplete = profileCompleteValue,
        userId = userId,
        errorMessage = null,
        isUpdatingProfile = false,
        profileUpdateError = null;

  /// Create error state
  const AuthState.error(String message)
      : status = AuthStatus.error,
        errorMessage = message,
        profileComplete = null,
        userId = null,
        isUpdatingProfile = false,
        profileUpdateError = null;

  /// Copy with method for state updates
  AuthState copyWith({
    AuthStatus? status,
    String? errorMessage,
    bool? profileComplete,
    String? userId,
    bool? isUpdatingProfile,
    String? profileUpdateError,
    bool clearError = false,
    bool clearProfileUpdateError = false,
  }) {
    return AuthState(
      status: status ?? this.status,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
      profileComplete: profileComplete ?? this.profileComplete,
      userId: userId ?? this.userId,
      isUpdatingProfile: isUpdatingProfile ?? this.isUpdatingProfile,
      profileUpdateError: clearProfileUpdateError 
          ? null 
          : (profileUpdateError ?? this.profileUpdateError),
    );
  }
}
