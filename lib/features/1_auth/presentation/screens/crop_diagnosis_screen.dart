import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:krishi_mitra/features/2_home/presentation/widgets/home_bottom_nav.dart';

class CropDiagnosisScreen extends StatelessWidget {
  const CropDiagnosisScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: const Color(0xFF1A1A1A),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1A1A1A),
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
          'Crop Health Check',
          style: GoogleFonts.roboto(
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
          
          return SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(minHeight: screenHeight),
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: screenWidth * 0.06,
                  vertical: screenHeight * 0.02,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(height: screenHeight * 0.02),
                    
                    // Instruction Text
                    Text(
                      'Place the leaf inside the frame and tap to scan',
                      style: GoogleFonts.roboto(
                        color: Colors.white70,
                        fontSize: screenWidth * 0.04,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    
                    SizedBox(height: screenHeight * 0.04),
                    
                    // Camera Frame
                    Container(
                      width: double.infinity,
                      height: screenHeight * 0.35,
                      constraints: BoxConstraints(
                        maxHeight: 350,
                        minHeight: 200,
                      ),
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: const Color(0xFF4CAF50),
                          width: 2,
                          style: BorderStyle.solid,
                        ),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: CustomPaint(
                        painter: DashedBorderPainter(),
                        child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                width: screenWidth * 0.15,
                                height: screenWidth * 0.15,
                                constraints: const BoxConstraints(
                                  maxWidth: 60,
                                  maxHeight: 60,
                                  minWidth: 40,
                                  minHeight: 40,
                                ),
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color: Colors.white54,
                                    width: 2,
                                  ),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Icon(
                                  Icons.agriculture,
                                  color: Colors.white54,
                                  size: screenWidth * 0.08,
                                ),
                              ),
                              SizedBox(height: screenHeight * 0.02),
                              Text(
                                'Place leaf inside the frame',
                                style: GoogleFonts.roboto(
                                  color: Colors.white54,
                                  fontSize: screenWidth * 0.035,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    
                    SizedBox(height: screenHeight * 0.04),
                    
                    // Open Camera Button
                    SizedBox(
                      width: double.infinity,
                      height: 56,
                      child: ElevatedButton(
                        onPressed: () {
                          context.push('/crop-analysis');
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF4CAF50),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(28),
                          ),
                          elevation: 0,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(
                              Icons.camera_alt,
                              color: Colors.white,
                              size: 24,
                            ),
                            const SizedBox(width: 12),
                            Text(
                              'Open Camera',
                              style: GoogleFonts.roboto(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    
                    SizedBox(height: screenHeight * 0.02),
                    
                    // Upload from Gallery Button
                    TextButton(
                      onPressed: () {
                        context.push('/crop-analysis');
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(
                            Icons.photo_library,
                            color: Colors.white54,
                            size: 20,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            'Upload from Gallery',
                            style: GoogleFonts.roboto(
                              color: Colors.white54,
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                    
                    SizedBox(height: screenHeight * 0.02),
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

class DashedBorderPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFF4CAF50)
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    const dashWidth = 8.0;
    const dashSpace = 6.0;
    
    // Top border
    double startX = 0;
    while (startX < size.width) {
      canvas.drawLine(
        Offset(startX, 0),
        Offset(startX + dashWidth, 0),
        paint,
      );
      startX += dashWidth + dashSpace;
    }
    
    // Right border
    double startY = 0;
    while (startY < size.height) {
      canvas.drawLine(
        Offset(size.width, startY),
        Offset(size.width, startY + dashWidth),
        paint,
      );
      startY += dashWidth + dashSpace;
    }
    
    // Bottom border
    startX = size.width;
    while (startX > 0) {
      canvas.drawLine(
        Offset(startX, size.height),
        Offset(startX - dashWidth, size.height),
        paint,
      );
      startX -= dashWidth + dashSpace;
    }
    
    // Left border
    startY = size.height;
    while (startY > 0) {
      canvas.drawLine(
        Offset(0, startY),
        Offset(0, startY - dashWidth),
        paint,
      );
      startY -= dashWidth + dashSpace;
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
