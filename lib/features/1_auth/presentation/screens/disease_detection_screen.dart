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
      resizeToAvoidBottomInset: true,
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
      body: LayoutBuilder(
        builder: (context, constraints) {
          final screenWidth = constraints.maxWidth;
          final screenHeight = constraints.maxHeight;
          
          return SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.all(screenWidth * 0.06),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Crop Image
                  ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: Container(
                      width: double.infinity,
                      height: (screenHeight * 0.35).clamp(200.0, 300.0),
                      color: darkCard,
                      child: Icon(
                        Icons.image,
                        size: (screenWidth * 0.2).clamp(60.0, 100.0),
                        color: mutedTextColor,
                      ),
                    ),
                  ),
                  
                  SizedBox(height: screenHeight * 0.03),
                  
                  // Disease Name and Badges
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    crossAxisAlignment: WrapCrossAlignment.center,
                    children: [
                      Text(
                        'Leaf Blight',
                        style: GoogleFonts.poppins(
                          color: onDarkTextColor,
                          fontSize: (screenWidth * 0.07).clamp(20.0, 28.0),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: screenWidth * 0.03,
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
                            fontSize: (screenWidth * 0.03).clamp(10.0, 12.0),
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: screenWidth * 0.03,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: warningAmber.withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
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
                                fontSize: (screenWidth * 0.03).clamp(10.0, 12.0),
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  
                  SizedBox(height: screenHeight * 0.015),
                  
                  // Confidence
                  Text(
                    '95% Certain',
                    style: GoogleFonts.poppins(
                      color: primaryGreen,
                      fontSize: (screenWidth * 0.04).clamp(14.0, 16.0),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  
                  SizedBox(height: screenHeight * 0.04),
                  
                  // Recommended Actions
                  Text(
                    'Recommended Actions',
                    style: GoogleFonts.poppins(
                      color: onDarkTextColor,
                      fontSize: (screenWidth * 0.045).clamp(16.0, 18.0),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  
                  SizedBox(height: screenHeight * 0.02),
                  
                  // Action Items
                  _buildActionItem(
                    context,
                    icon: Icons.medication,
                    iconColor: primaryGreen,
                    text: 'Apply fungicide as per recommended dosage.',
                  ),
                  
                  SizedBox(height: screenHeight * 0.02),
                  
                  _buildActionItem(
                    context,
                    icon: Icons.visibility,
                    iconColor: primaryGreen,
                    text: 'Monitor the crop regularly for further symptoms.',
                  ),
                  
                  SizedBox(height: screenHeight * 0.02),
                  
                  _buildActionItem(
                    context,
                    icon: Icons.people,
                    iconColor: primaryGreen,
                    text: 'Consult with an agricultural expert if the condition worsens.',
                  ),
                  
                  SizedBox(height: screenHeight * 0.03),
                ],
              ),
            ),
          );
        },
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
              context.push('/history');
              break;
          }
        },
      ),
    );
  }

  Widget _buildActionItem(
    BuildContext context, {
    required IconData icon,
    required Color iconColor,
    required String text,
  }) {
    final screenWidth = MediaQuery.of(context).size.width;
    
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: (screenWidth * 0.1).clamp(36.0, 44.0),
          height: (screenWidth * 0.1).clamp(36.0, 44.0),
          decoration: BoxDecoration(
            color: iconColor.withValues(alpha: 0.15),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            icon,
            color: iconColor,
            size: (screenWidth * 0.05).clamp(18.0, 22.0),
          ),
        ),
        SizedBox(width: screenWidth * 0.04),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(top: 8),
            child: Text(
              text,
              style: GoogleFonts.poppins(
                color: mutedTextColor,
                fontSize: (screenWidth * 0.035).clamp(12.0, 14.0),
                height: 1.5,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
