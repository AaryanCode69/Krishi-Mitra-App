import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:krishi_mitra/core/constant/colors_theme.dart';
import 'package:krishi_mitra/features/1_auth/application/auth_providers.dart';
import 'package:krishi_mitra/features/1_auth/application/auth_state.dart';

class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _checkAuthAndNavigate();
  }

  Future<void> _checkAuthAndNavigate() async {
    // Wait for splash animation
    await Future.delayed(const Duration(seconds: 2));
    
    if (!mounted) return;
    
    // Check authentication state
    final authState = ref.read(authProvider);
    
    // Navigate based on auth state
    if (authState.status == AuthStatus.success) {
      // User is authenticated, go to home
      context.go('/home');
    } else {
      // User is not authenticated, go to phone input
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
