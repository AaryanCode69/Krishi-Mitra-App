import 'package:flutter/material.dart';
import 'package:krishi_mitra/core/constant/colors_theme.dart';

class HealthIndicator extends StatelessWidget {
  const HealthIndicator({
    super.key,
    required this.isHealthy,
  });

  final bool isHealthy;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: isHealthy
            ? primaryGreen.withValues(alpha: 0.2)
            : Colors.red.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isHealthy ? primaryGreen : Colors.red,
          width: 1.5,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            isHealthy ? Icons.check_circle : Icons.warning,
            color: isHealthy ? primaryGreen : Colors.red,
            size: 20,
          ),
          const SizedBox(width: 8),
          Text(
            isHealthy ? 'Healthy' : 'Disease Detected',
            style: TextStyle(
              color: isHealthy ? primaryGreen : Colors.red,
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
