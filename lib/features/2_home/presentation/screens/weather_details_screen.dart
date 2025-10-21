import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:krishi_mitra/core/constant/colors_theme.dart';
import 'package:krishi_mitra/features/2_home/application/home_providers.dart';
import 'package:krishi_mitra/features/2_home/presentation/widgets/home_bottom_nav.dart';
import 'package:krishi_mitra/features/2_home/presentation/widgets/weather_card.dart';
import 'package:krishi_mitra/shared/widgets/common_text_widget.dart';

class WeatherDetailsScreen extends ConsumerWidget {
  const WeatherDetailsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final summary = ref.watch(weatherSummaryProvider);
    final hourlyForecast = List.generate(
      6,
      (index) => ('${6 + index * 2}:00', index.isEven ? 'Sunny' : 'Cloudy'),
    );

    return Scaffold(
      backgroundColor: darkBackground,
      appBar: AppBar(
        backgroundColor: darkBackground,
        elevation: 0,
        title: const CommonTextWidget(
          data: 'Weather Forecast',
          textColor: onDarkTextColor,
          fontSize: 20,
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        children: [
          WeatherCard(
            temperature: summary.temperature,
            location: summary.location,
            onForecastTap: () {},
          ),
          const SizedBox(height: 24),
          const CommonTextWidget(
            data: 'Today\'s Outlook',
            textColor: onDarkTextColor,
            fontSize: 18,
          ),
          const SizedBox(height: 12),
          ...hourlyForecast.map(
            (entry) => Container(
              margin: const EdgeInsets.only(bottom: 12),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              decoration: BoxDecoration(
                color: darkCard,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                children: [
                  Icon(
                    entry.$2 == 'Sunny'
                        ? Icons.wb_sunny_outlined
                        : Icons.cloud_outlined,
                    color: primaryGreen,
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Text(
                      entry.$2,
                      style: const TextStyle(
                        color: onDarkTextColor,
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  Text(
                    entry.$1,
                    style: const TextStyle(
                      color: mutedTextColor,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: HomeBottomNav(
        currentIndex: 0,
        onTap: (index) {
          // TODO: Handle navigation
        },
      ),
    );
  }
}
