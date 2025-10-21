import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:krishi_mitra/core/constant/colors_theme.dart';
import 'package:krishi_mitra/features/2_home/presentation/widgets/home_bottom_nav.dart';

class DiseaseDetectionScreen extends StatelessWidget {
  const DiseaseDetectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: darkBackground,
      appBar: AppBar(
        backgroundColor: darkBackground,
        elevation: 0,
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
        ),
        title: Text(
          'Disease Detection',
          style: GoogleFonts.poppins(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.w500,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Crop Image
              ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Container(
                  width: double.infinity,
                  height: 280,
                  color: darkCard,
                  child: const Icon(
                    Icons.image,
                    size: 80,
                    color: mutedTextColor,
                  ),
                ),
              ),
              
              const SizedBox(height: 24),
              
              // Disease Name and Badges
              Row(
                children: [
                  Expanded(
                    child: Text(
                      'Leaf Blight',
                      style: GoogleFonts.poppins(
                        color: onDarkTextColor,
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: warningAmber.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      'Leaf Blight',
                      style: GoogleFonts.poppins(
                        color: warningAmber,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: warningAmber.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.circle,
                          size: 8,
                          color: warningAmber,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          'Moderate',
                          style: GoogleFonts.poppins(
                            color: warningAmber,
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              
              const SizedBox(height: 12),
              
              // Confidence
              Text(
                '95% Certain',
                style: GoogleFonts.poppins(
                  color: primaryGreen,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              
              const SizedBox(height: 32),
              
              // Recommended Actions
              Text(
                'Recommended Actions',
                style: GoogleFonts.poppins(
                  color: onDarkTextColor,
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
              
              const SizedBox(height: 16),
              
              // Action Items
              _buildActionItem(
                icon: Icons.medication,
                iconColor: primaryGreen,
                text: 'Apply fungicide as per recommended dosage.',
              ),
              
              const SizedBox(height: 16),
              
              _buildActionItem(
                icon: Icons.visibility,
                iconColor: primaryGreen,
                text: 'Monitor the crop regularly for further symptoms.',
              ),
              
              const SizedBox(height: 16),
              
              _buildActionItem(
                icon: Icons.people,
                iconColor: primaryGreen,
                text: 'Consult with an agricultural expert if the condition worsens.',
              ),
              
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
      bottomNavigationBar: HomeBottomNav(
        currentIndex: 1,
        onTap: (index) {
          switch (index) {
            case 0:
              context.go('/home');
              break;
            case 1:
              context.go('/scan');
              break;
            case 2:
              context.push('/market-prices');
              break;
            case 3:
              context.push('/crops');
              break;
          }
        },
      ),
    );
  }

  Widget _buildActionItem({
    required IconData icon,
    required Color iconColor,
    required String text,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: iconColor.withValues(alpha: 0.15),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            icon,
            color: iconColor,
            size: 20,
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(top: 8),
            child: Text(
              text,
              style: GoogleFonts.poppins(
                color: mutedTextColor,
                fontSize: 14,
                height: 1.5,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
