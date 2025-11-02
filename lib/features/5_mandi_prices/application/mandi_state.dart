import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../domain/mandi_price.dart';

/// State class for Mandi Prices feature
class MandiState {
  final AsyncValue<List<MandiPrice>> prices;
  final String selectedState;
  final bool isLoading;

  const MandiState({
    required this.prices,
    required this.selectedState,
    required this.isLoading,
  });

  /// Initial state factory
  factory MandiState.initial() {
    return const MandiState(
      prices: AsyncValue.data([]),
      selectedState: 'Tamil Nadu',
      isLoading: false,
    );
  }

  /// Copy with method for immutable state updates
  MandiState copyWith({
    AsyncValue<List<MandiPrice>>? prices,
    String? selectedState,
    bool? isLoading,
  }) {
    return MandiState(
      prices: prices ?? this.prices,
      selectedState: selectedState ?? this.selectedState,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}
