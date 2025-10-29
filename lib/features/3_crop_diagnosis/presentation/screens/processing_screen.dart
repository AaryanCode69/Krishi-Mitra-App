import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:krishi_mitra/features/1_auth/application/auth_providers.dart';
import 'package:krishi_mitra/features/1_auth/application/auth_state.dart';
import '../../application/crop_analysis_providers.dart';
import '../../application/crop_analysis_state.dart';

/// Screen displayed during crop image processing
/// 
/// Shows loading animation and status text while the backend processes the image.
/// Automatically navigates to ResultScreen when processing completes.
/// Handles app lifecycle to maintain state during backgrounding.
class ProcessingScreen extends ConsumerStatefulWidget {
  const ProcessingScreen({super.key});

  @override
  ConsumerState<ProcessingScreen> createState() => _ProcessingScreenState();
}

class _ProcessingScreenState extends ConsumerState<ProcessingScreen> with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    // Register lifecycle observer
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    // Unregister lifecycle observer
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    // Handle app lifecycle changes
    if (state == AppLifecycleState.paused || state == AppLifecycleState.inactive) {
      // App going to background - pause polling
      ref.read(cropAnalysisProvider.notifier).pause();
    } else if (state == AppLifecycleState.resumed) {
      // App returning to foreground - resume polling
      ref.read(cropAnalysisProvider.notifier).resume();
    }
  }

  @override
  Widget build(BuildContext context) {
    // Listen to state changes for navigation
    ref.listen<CropAnalysisState>(
      cropAnalysisProvider,
      (previous, next) {
        // Navigate to result screen when completed
        if (next.status == CropAnalysisStatus.completed && next.result != null) {
          context.go('/crop-result', extra: next.result);
        }
        
        // Show error dialog or navigate back when error occurs
        if (next.status == CropAnalysisStatus.error) {
          _showErrorDialog(context, next.errorMessage ?? 'An error occurred');
        }
      },
    );

    // Listen for auth state changes to handle token expiration
    ref.listen<AuthState>(authProvider, (previous, next) {
      // If user is logged out (token expired), navigate to login
      if (next.status == AuthStatus.initial || next.status == AuthStatus.error) {
        // Show message and redirect to login
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Session expired. Please login again.',
              style: GoogleFonts.poppins(color: Colors.white),
            ),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 3),
          ),
        );
        context.go('/phone-input');
      }
    });

    return Scaffold(
      backgroundColor: const Color(0xFF121212),
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Loading animation
                const SizedBox(
                  width: 80,
                  height: 80,
                  child: CircularProgressIndicator(
                    strokeWidth: 6,
                    valueColor: AlwaysStoppedAnimation<Color>(
                      Color(0xFF4CAF50),
                    ),
                  ),
                ),
                const SizedBox(height: 40),
                
                // Status text
                const Text(
                  'Analyzing your crop...',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                
                // Additional status message
                const Text(
                  'This may take a few moments',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.white70,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// Shows error dialog and navigates back
  void _showErrorDialog(BuildContext context, String message) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF1E1E1E),
        title: const Text(
          'Analysis Failed',
          style: TextStyle(color: Colors.white),
        ),
        content: Text(
          message,
          style: const TextStyle(color: Colors.white70),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(); // Close dialog
              context.go('/crop-upload'); // Navigate back to upload screen
            },
            child: const Text(
              'Try Again',
              style: TextStyle(color: Color(0xFF4CAF50)),
            ),
          ),
        ],
      ),
    );
  }
}
