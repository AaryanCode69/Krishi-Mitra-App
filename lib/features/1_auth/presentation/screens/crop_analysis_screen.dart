import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:krishi_mitra/core/constant/colors_theme.dart';
import 'package:krishi_mitra/features/2_home/presentation/widgets/home_bottom_nav.dart';

class CropAnalysisScreen extends StatefulWidget {
  const CropAnalysisScreen({super.key});

  @override
  State<CropAnalysisScreen> createState() => _CropAnalysisScreenState();
}

class _CropAnalysisScreenState extends State<CropAnalysisScreen> {
  @override
  void initState() {
    super.initState();
    // Simulate analysis completion after 3 seconds
    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) {
        context.push('/disease-detection');
      }
    });
  }

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
          'Crop Analysis',
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
          final screenHeight = constraints.maxHeight;
          final screenWidth = constraints.maxWidth;
          final circleSize = (screenWidth * 0.45).clamp(150.0, 200.0);
          final iconSize = circleSize * 0.65;
          
          return Center(
            child: SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: screenWidth * 0.06,
                  vertical: screenHeight * 0.02,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Animated crop icon with circular progress
                    Stack(
                      alignment: Alignment.center,
                      children: [
                        // Circular progress indicator
                        SizedBox(
                          width: circleSize,
                          height: circleSize,
                          child: CircularProgressIndicator(
                            strokeWidth: 6,
                            valueColor: const AlwaysStoppedAnimation<Color>(
                              primaryGreen,
                            ),
                            backgroundColor: primaryGreen.withValues(alpha: 0.2),
                          ),
                        ),
                        // Crop icon
                        Container(
                          width: iconSize,
                          height: iconSize,
                          decoration: BoxDecoration(
                            color: primaryGreen.withValues(alpha: 0.15),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            Icons.grass,
                            color: primaryGreen,
                            size: iconSize * 0.5,
                          ),
                        ),
                      ],
                    ),
                    
                    SizedBox(height: screenHeight * 0.06),
                    
                    // Main message
                    Text(
                      'Analyzing your crop, please wait...',
                      style: GoogleFonts.poppins(
                        color: onDarkTextColor,
                        fontSize: (screenWidth * 0.055).clamp(18.0, 24.0),
                        fontWeight: FontWeight.w600,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    
                    SizedBox(height: screenHeight * 0.02),
                    
                    // Subtitle
                    Text(
                      'Our AI is working its magic to give you the best insights.',
                      style: GoogleFonts.poppins(
                        color: mutedTextColor,
                        fontSize: (screenWidth * 0.035).clamp(12.0, 16.0),
                        height: 1.5,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    
                    SizedBox(height: screenHeight * 0.06),
                    
                    // Progress bar
                    Container(
                      width: double.infinity,
                      height: 8,
                      decoration: BoxDecoration(
                        color: darkCard,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: FractionallySizedBox(
                        alignment: Alignment.centerLeft,
                        widthFactor: 0.6,
                        child: Container(
                          decoration: BoxDecoration(
                            color: primaryGreen,
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
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
              context.push('/crops');
              break;
          }
        },
      ),
    );
  }
}
