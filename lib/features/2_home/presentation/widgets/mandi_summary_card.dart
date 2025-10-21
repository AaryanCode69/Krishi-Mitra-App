import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:krishi_mitra/core/constant/colors_theme.dart';

class MandiSummaryCard extends StatelessWidget {
  const MandiSummaryCard({
    super.key,
    required this.primaryCrop,
    required this.primaryPrice,
    required this.secondaryCrop,
    required this.secondaryPrice,
    required this.onViewAllTap,
  });

  final String primaryCrop;
  final String primaryPrice;
  final String secondaryCrop;
  final String secondaryPrice;
  final VoidCallback onViewAllTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: homeCardBackground,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'Mandi Prices',
            style: GoogleFonts.poppins(
              fontSize: 12,
              color: mutedTextColor,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            '$primaryCrop: $primaryPrice',
            style: GoogleFonts.poppins(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            '$secondaryCrop: $secondaryPrice',
            style: GoogleFonts.poppins(
              fontSize: 12,
              color: mutedTextColor,
            ),
          ),
          const SizedBox(height: 12),
          GestureDetector(
            onTap: onViewAllTap,
            child: Text(
              'View All →',
              style: GoogleFonts.poppins(
                fontSize: 12,
                color: primaryGreen,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
