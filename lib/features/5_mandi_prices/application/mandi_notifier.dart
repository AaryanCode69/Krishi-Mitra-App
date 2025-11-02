import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/mandi_repository.dart';
import '../domain/exceptions/mandi_price_exception.dart';
import 'mandi_state.dart';

/// Notifier for managing Mandi Prices state
class MandiNotifier extends StateNotifier<MandiState> {
  final MandiRepository _repository;

  /// List of available Indian states for market price queries
  static const List<String> availableStates = [
    'Tamil Nadu',
    'Kerala',
    'Karnataka',
    'Andhra Pradesh',
    'Telangana',
    'Maharashtra',
    'Punjab',
    'Uttar Pradesh',
    'Madhya Pradesh',
  ];

  MandiNotifier({required MandiRepository repository})
      : _repository = repository,
        super(MandiState.initial());

  /// Updates the selected state
  void selectState(String newState) {
    state = state.copyWith(selectedState: newState);
  }

  /// Fetches market prices for the currently selected state
  Future<void> fetchPrices() async {
    // Set loading state
    state = state.copyWith(isLoading: true);

    try {
      // Call repository to fetch prices
      final prices = await _repository.fetchMandiPrices(state.selectedState);

      // Update state with data
      state = state.copyWith(
        prices: AsyncValue.data(prices),
        isLoading: false,
      );
    } on MandiPriceException catch (e) {
      // Handle mandi price specific errors
      state = state.copyWith(
        prices: AsyncValue.error(e, StackTrace.current),
        isLoading: false,
      );
    } catch (e, stackTrace) {
      // Handle unexpected errors
      state = state.copyWith(
        prices: AsyncValue.error(e, stackTrace),
        isLoading: false,
      );
    }
  }
}
