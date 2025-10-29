import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:krishi_mitra/core/constant/colors_theme.dart';
import 'package:krishi_mitra/features/3_crop_diagnosis/application/crop_analysis_providers.dart';
import 'package:krishi_mitra/features/3_crop_diagnosis/domain/crop_submission_response_dto.dart';
import 'package:krishi_mitra/features/3_crop_diagnosis/presentation/widgets/health_indicator.dart';
import 'package:krishi_mitra/shared/widgets/common_elevated_button.dart';

class ResultScreen extends ConsumerWidget {
  const ResultScreen({
    super.key,
    required this.result,
  });

  final CropSubmissionResponseDTO result;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isHealthy = result.diseaseName.toLowerCase() == 'healthy';

    return Scaffold(
      backgroundColor: const Color(0xFF121212),
      appBar: AppBar(
        backgroundColor: const Color(0xFF121212),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => context.pop(),
        ),
        title: Text(
          'Analysis Result',
          style: GoogleFonts.poppins(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Analyzed crop image
              _buildCropImage(),
              const SizedBox(height: 24),
              
              // Disease information and confidence score
              _buildDiseaseInfo(isHealthy),
              const SizedBox(height: 24),
              
              // Remedy recommendations
              _buildRemedySection(isHealthy),
              const SizedBox(height: 32),
              
              // Action buttons
              _buildActionButtons(context, ref),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCropImage() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: AspectRatio(
        aspectRatio: 16 / 9,
        child: CachedNetworkImage(
          imageUrl: result.imageUrl,
          fit: BoxFit.cover,
          placeholder: (context, url) => Container(
            color: Colors.grey[900],
            child: const Center(
              child: CircularProgressIndicator(
                color: primaryGreen,
              ),
            ),
          ),
          errorWidget: (context, url, error) => Container(
            color: Colors.grey[900],
            child: const Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.error_outline,
                  color: Colors.red,
                  size: 48,
                ),
                SizedBox(height: 8),
                Text(
                  'Failed to load image',
                  style: TextStyle(color: Colors.white70),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDiseaseInfo(bool isHealthy) {
    final confidencePercentage = (result.confidenceScore * 100).toStringAsFixed(1);
    
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.grey[900],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Colors.grey[800]!,
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  result.diseaseName,
                  style: GoogleFonts.poppins(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              HealthIndicator(isHealthy: isHealthy),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Icon(
                Icons.analytics_outlined,
                color: primaryGreen,
                size: 20,
              ),
              const SizedBox(width: 8),
              Text(
                'Confidence Score: ',
                style: GoogleFonts.poppins(
                  color: Colors.white70,
                  fontSize: 16,
                ),
              ),
              Text(
                '$confidencePercentage%',
                style: GoogleFonts.poppins(
                  color: primaryGreen,
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildRemedySection(bool isHealthy) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.grey[900],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Colors.grey[800]!,
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                isHealthy ? Icons.celebration : Icons.medical_services,
                color: primaryGreen,
                size: 24,
              ),
              const SizedBox(width: 12),
              Text(
                isHealthy ? 'Great News!' : 'Recommended Treatment',
                style: GoogleFonts.poppins(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            isHealthy
                ? 'Your crop is healthy! Keep up the good work with your current care routine. Continue monitoring your crops regularly to maintain their health.'
                : result.remedy,
            style: GoogleFonts.poppins(
              color: Colors.white70,
              fontSize: 14,
              height: 1.6,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons(BuildContext context, WidgetRef ref) {
    return Column(
      children: [
        CommonElevatedButton(
          onTouch: () {
            // Reset the analysis state
            ref.read(cropAnalysisProvider.notifier).reset();
            // Navigate back to upload screen
            context.go('/crop-upload');
          },
          color: primaryGreen,
          width: double.infinity,
          height: 56,
          child: Text(
            'Analyze Another',
            style: GoogleFonts.poppins(
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        const SizedBox(height: 12),
        SizedBox(
          width: double.infinity,
          height: 56,
          child: OutlinedButton(
            onPressed: () {
              // Reset the analysis state
              ref.read(cropAnalysisProvider.notifier).reset();
              // Navigate to home screen
              context.go('/home');
            },
            style: OutlinedButton.styleFrom(
              foregroundColor: primaryGreen,
              side: const BorderSide(color: primaryGreen, width: 2),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: Text(
              'Back to Home',
              style: GoogleFonts.poppins(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
