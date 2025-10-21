import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:krishi_mitra/core/constant/colors_theme.dart';

class MyCropListItem extends StatelessWidget {
  const MyCropListItem({
    super.key,
    required this.cropName,
    required this.status,
    required this.statusColor,
    required this.timestamp,
    required this.badgeText,
    required this.onTap,
  });

  final String cropName;
  final String status;
  final Color statusColor;
  final String timestamp;
  final String badgeText;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: homeCardBackground,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            // Crop icon
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: primaryGreen.withOpacity(0.2),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(
                Icons.grass,
                color: primaryGreen,
                size: 28,
              ),
            ),
            const SizedBox(width: 12),
            // Crop info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    cropName,
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    status,
                    style: GoogleFonts.poppins(
                      fontSize: 12,
                      color: mutedTextColor,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    timestamp,
                    style: GoogleFonts.poppins(
                      fontSize: 10,
                      color: mutedTextColor,
                    ),
                  ),
                ],
              ),
            ),
            // Status badge
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: statusColor,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                badgeText,
                style: GoogleFonts.poppins(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
