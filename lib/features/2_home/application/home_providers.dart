import 'package:flutter_riverpod/flutter_riverpod.dart';

class WeatherSummary {
  const WeatherSummary({
    required this.temperature,
    required this.location,
  });

  final String temperature;
  final String location;
}

class MandiPriceSummary {
  const MandiPriceSummary({
    required this.primaryCommodity,
    required this.primaryPrice,
    required this.secondaryCommodity,
    required this.secondaryPrice,
  });

  final String primaryCommodity;
  final String primaryPrice;
  final String secondaryCommodity;
  final String secondaryPrice;
}

final weatherSummaryProvider = Provider<WeatherSummary>((ref) {
  return const WeatherSummary(
    temperature: '28°C',
    location: 'Vellore, TN',
  );
});

final mandiPriceSummaryProvider = Provider<MandiPriceSummary>((ref) {
  return const MandiPriceSummary(
    primaryCommodity: 'Groundnut',
    primaryPrice: '₹5,500',
    secondaryCommodity: 'Rice',
    secondaryPrice: '₹2,200',
  );
});

final homeNavIndexProvider = StateProvider<int>((ref) => 0);
