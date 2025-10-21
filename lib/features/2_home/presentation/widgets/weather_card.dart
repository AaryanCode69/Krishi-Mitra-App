import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:krishi_mitra/core/constant/colors_theme.dart';

class WeatherCard extends StatelessWidget {
  const WeatherCard({
    super.key,
    required this.temperature,
    required this.location,
    required this.onForecastTap,
  });

  final String temperature;
  final String location;
  final VoidCallback onForecastTap;

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
            'Weather',
            style: GoogleFonts.poppins(
              fontSize: 12,
              color: mutedTextColor,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            temperature,
            style: GoogleFonts.poppins(
              fontSize: 32,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            location,
            style: GoogleFonts.poppins(
              fontSize: 12,
              color: mutedTextColor,
            ),
          ),
          const SizedBox(height: 12),
          GestureDetector(
            onTap: onForecastTap,
            child: Text(
              '3-Day Forecast →',
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
