import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:krishi_mitra/core/constant/colors_theme.dart';
import 'package:krishi_mitra/features/2_home/application/home_providers.dart';
import 'package:krishi_mitra/features/2_home/presentation/widgets/home_bottom_nav.dart';
import 'package:krishi_mitra/shared/widgets/common_text_widget.dart';

class MandiPricesScreen extends ConsumerWidget {
  const MandiPricesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final summary = ref.watch(mandiPriceSummaryProvider);
    final prices = [
      (summary.primaryCommodity, summary.primaryPrice, 'Up 2.5% today'),
      (summary.secondaryCommodity, summary.secondaryPrice, 'Stable pricing'),
      ('Cotton', '₹6,800', 'Slight dip'),
      ('Tur Dal', '₹8,400', 'Demand rising'),
    ];

    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: darkBackground,
      appBar: AppBar(
        backgroundColor: darkBackground,
        elevation: 0,
        title: const CommonTextWidget(
          data: 'Mandi Prices',
          textColor: onDarkTextColor,
          fontSize: 20,
        ),
      ),
      body: ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        itemCount: prices.length,
        separatorBuilder: (_, __) => const SizedBox(height: 12),
        itemBuilder: (context, index) {
          final (commodity, rate, note) = prices[index];
          return Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
            decoration: BoxDecoration(
              color: darkCard,
              borderRadius: BorderRadius.circular(18),
              border: Border.all(color: Colors.white.withValues(alpha: 0.04)),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        commodity,
                        style: const TextStyle(
                          color: onDarkTextColor,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        note,
                        style: const TextStyle(
                          color: mutedTextColor,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                Text(
                  rate,
                  style: const TextStyle(
                    color: primaryGreen,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          );
        },
      ),
      bottomNavigationBar: HomeBottomNav(
        currentIndex: 2,
        onTap: (index) {
          switch (index) {
            case 0:
              context.go('/home');
              break;
            case 1:
              context.push('/scan');
              break;
            case 2:
              context.go('/market-prices');
              break;
            case 3:
              context.push('/crops');
              break;
          }
        },
      ),
    );
  }
}
