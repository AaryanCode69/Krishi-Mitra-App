import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:krishi_mitra/core/constant/colors_theme.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _navigateToPhoneInput();
  }

  Future<void> _navigateToPhoneInput() async {
    await Future.delayed(const Duration(seconds: 3));
    if (mounted) {
      context.go('/phone-input');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // App Logo
            Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                color: primaryGreen.withValues(alpha: 0.2),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.grass,
                size: 70,
                color: primaryGreen,
              ),
            ),
            
            const SizedBox(height: 32),
            
            // App Name
            Text(
              'Krishi Mitra',
              style: GoogleFonts.poppins(
                fontSize: 36,
                fontWeight: FontWeight.bold,
                color: Colors.white,
                letterSpacing: 1.2,
              ),
            ),
            
            const SizedBox(height: 8),
            
            // Tagline
            Text(
              'Farmer\'s Friend',
              style: GoogleFonts.poppins(
                fontSize: 16,
                color: primaryGreen,
                letterSpacing: 0.5,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
