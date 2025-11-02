import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:krishi_mitra/core/constant/colors_theme.dart';
import '../../domain/mandi_price.dart';

/// Widget that displays market price information for a single commodity
class MandiPriceCard extends StatelessWidget {
  const MandiPriceCard({
    super.key,
    required this.mandiPrice,
  });

  final MandiPrice mandiPrice;

  @override
  Widget build(BuildContext context) {
    return Card(
      color: homeCardBackground,
      margin: const EdgeInsets.only(bottom: 12.0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Commodity name (prominent)
            Text(
              mandiPrice.commodity,
              style: GoogleFonts.poppins(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 8.0),
            // Market name
            Text(
              mandiPrice.market,
              style: GoogleFonts.poppins(
                fontSize: 14,
                color: primaryGreen,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 8.0),
            // District name
            Text(
              'District: ${mandiPrice.district}',
              style: GoogleFonts.poppins(
                fontSize: 12,
                color: mutedTextColor,
              ),
            ),
            const SizedBox(height: 4.0),
            // Arrival date
            Text(
              'Date: ${mandiPrice.arrivalDate}',
              style: GoogleFonts.poppins(
                fontSize: 12,
                color: mutedTextColor,
              ),
            ),
            const SizedBox(height: 16.0),
            // Price row
            Row(
              children: [
                Expanded(
                  child: _PriceItem(
                    label: 'Min',
                    price: mandiPrice.minPrice,
                  ),
                ),
                Expanded(
                  child: _PriceItem(
                    label: 'Max',
                    price: mandiPrice.maxPrice,
                  ),
                ),
                Expanded(
                  child: _PriceItem(
                    label: 'Modal',
                    price: mandiPrice.modalPrice,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

/// Helper widget to display individual price items
class _PriceItem extends StatelessWidget {
  const _PriceItem({
    required this.label,
    required this.price,
  });

  final String label;
  final int price;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.poppins(
            fontSize: 11,
            color: mutedTextColor,
          ),
        ),
        const SizedBox(height: 4.0),
        Text(
          '₹$price',
          style: GoogleFonts.poppins(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: primaryGreen,
          ),
        ),
      ],
    );
  }
}
