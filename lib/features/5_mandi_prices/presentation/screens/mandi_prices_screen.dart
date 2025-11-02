import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:krishi_mitra/core/constant/colors_theme.dart';
import '../../application/mandi_notifier.dart';
import '../../application/mandi_providers.dart';
import '../../domain/exceptions/mandi_price_exception.dart';
import '../widgets/mandi_price_card.dart';

/// Screen that displays market prices for agricultural commodities
class MandiPricesScreen extends ConsumerWidget {
  const MandiPricesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final mandiState = ref.watch(mandiProvider);
    final mandiNotifier = ref.read(mandiProvider.notifier);

    return Scaffold(
      backgroundColor: homeBackground,
      appBar: AppBar(
        title: Text(
          'Market Prices',
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
        backgroundColor: darkSurface,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // State selector dropdown
            DropdownButtonFormField<String>(
              value: mandiState.selectedState,
              decoration: InputDecoration(
                labelText: 'Select State',
                labelStyle: GoogleFonts.poppins(
                  color: mutedTextColor,
                ),
                filled: true,
                fillColor: darkCard,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
              ),
              dropdownColor: darkCard,
              style: GoogleFonts.poppins(
                color: Colors.white,
                fontSize: 14,
              ),
              items: MandiNotifier.availableStates.map((String state) {
                return DropdownMenuItem<String>(
                  value: state,
                  child: Text(state),
                );
              }).toList(),
              onChanged: (String? newValue) {
                if (newValue != null) {
                  mandiNotifier.selectState(newValue);
                }
              },
            ),
            const SizedBox(height: 16.0),
            // Get Prices button
            ElevatedButton(
              onPressed: mandiState.isLoading ? null : () {
                mandiNotifier.fetchPrices();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: primaryGreen,
                disabledBackgroundColor: primaryGreen.withValues(alpha: 0.6),
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: mandiState.isLoading
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2.5,
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                    )
                  : Text(
                      'Get Prices',
                      style: GoogleFonts.poppins(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
            ),
            const SizedBox(height: 24.0),
            // Results area
            Expanded(
              child: mandiState.prices.when(
                data: (prices) {
                  if (prices.isEmpty) {
                    return Center(
                      child: Text(
                        'Select a state and tap "Get Prices" to view market prices',
                        textAlign: TextAlign.center,
                        style: GoogleFonts.poppins(
                          color: mutedTextColor,
                          fontSize: 14,
                        ),
                      ),
                    );
                  }
                  return ListView.builder(
                    itemCount: prices.length,
                    itemBuilder: (context, index) {
                      return MandiPriceCard(mandiPrice: prices[index]);
                    },
                  );
                },
                loading: () => const Center(
                  child: CircularProgressIndicator(
                    color: primaryGreen,
                  ),
                ),
                error: (error, stackTrace) {
                  String errorMessage = 'An error occurred. Please try again.';
                  
                  if (error is MandiPriceException) {
                    errorMessage = error.message;
                  } else {
                    errorMessage = error.toString();
                  }
                  
                  return Center(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.error_outline,
                            color: Colors.red.shade300,
                            size: 48,
                          ),
                          const SizedBox(height: 16),
                          Text(
                            errorMessage,
                            textAlign: TextAlign.center,
                            style: GoogleFonts.poppins(
                              color: Colors.red.shade300,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: _buildBottomNav(context),
    );
  }

  Widget _buildBottomNav(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: darkCard,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.2),
            blurRadius: 8,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        child: SizedBox(
          height: 60,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildNavItem(
                context: context,
                icon: Icons.home,
                label: 'Home',
                route: '/home',
                isActive: false,
              ),
              _buildNavItem(
                context: context,
                icon: Icons.qr_code_scanner,
                label: 'Scan',
                route: '/scan',
                isActive: false,
              ),
              _buildNavItem(
                context: context,
                icon: Icons.currency_rupee,
                label: 'Prices',
                route: '/prices',
                isActive: true,
              ),
              _buildNavItem(
                context: context,
                icon: Icons.history,
                label: 'History',
                route: '/history',
                isActive: false,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem({
    required BuildContext context,
    required IconData icon,
    required String label,
    required String route,
    required bool isActive,
  }) {
    final color = isActive ? primaryGreen : mutedTextColor;

    return GestureDetector(
      onTap: () {
        if (!isActive) {
          if (route == '/home') {
            context.go(route);
          } else {
            context.push(route);
          }
        }
      },
      behavior: HitTestBehavior.opaque,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 24,
              color: color,
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: GoogleFonts.poppins(
                fontSize: 12,
                color: color,
                fontWeight: isActive ? FontWeight.w600 : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
