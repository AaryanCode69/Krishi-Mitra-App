import 'package:flutter_riverpod/flutter_riverpod.dart';

class CreateAccountState {
  const CreateAccountState({
    this.status = const AsyncData(null),
    this.formError,
    this.selectedState,
  });

  final AsyncValue<void> status;
  final String? formError;
  final String? selectedState;

  CreateAccountState copyWith({
    AsyncValue<void>? status,
    String? formError,
    String? selectedState,
    bool resetError = false,
    bool resetSelectedState = false,
  }) {
    return CreateAccountState(
      status: status ?? this.status,
      formError: resetError ? null : (formError ?? this.formError),
      selectedState:
          resetSelectedState ? null : (selectedState ?? this.selectedState),
    );
  }
}
