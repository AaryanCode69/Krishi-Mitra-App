import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:krishi_mitra/core/constant/colors_theme.dart';
import 'package:krishi_mitra/features/1_auth/application/auth_providers.dart';

class PhoneInputScreen extends ConsumerStatefulWidget {
  const PhoneInputScreen({super.key});

  @override
  ConsumerState<PhoneInputScreen> createState() => _PhoneInputScreenState();
}

class _PhoneInputScreenState extends ConsumerState<PhoneInputScreen> {
  final TextEditingController _phoneController = TextEditingController();
  final FocusNode _phoneFocusNode = FocusNode();
  bool _isLoading = false;

  @override
  void dispose() {
    _phoneController.dispose();
    _phoneFocusNode.dispose();
    super.dispose();
  }

  Future<void> _handleGetOTP() async {
    final phoneNumber = _phoneController.text.trim();
    
    // Basic validation
    if (phoneNumber.isEmpty) {
      _showErrorSnackBar('Please enter your phone number');
      return;
    }
    
    if (phoneNumber.length != 10) {
      _showErrorSnackBar('Please enter a valid 10-digit phone number');
      return;
    }
    
    // Set loading state
    setState(() {
      _isLoading = true;
    });
    
    try {
      // Get AuthService from provider
      final authService = ref.read(authServiceProvider);
      
      // Call sendOtp method
      final success = await authService.sendOtp(phoneNumber);
      
      if (!mounted) return;
      
      if (success) {
        // Get full phone number with country code
        final fullPhoneNumber = authService.getFullPhoneNumber(phoneNumber);
        
        // Navigate to OTP verification screen with phone number
        context.push('/otp', extra: fullPhoneNumber);
      } else {
        // Show error message
        _showErrorSnackBar('Failed to send OTP. Please try again.');
      }
    } catch (e) {
      if (!mounted) return;
      _showErrorSnackBar('An error occurred. Please try again.');
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }
  
  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: GoogleFonts.poppins(
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.red.shade600,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        margin: const EdgeInsets.all(16),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: const Color(0xFFF5F5F5),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: constraints.maxHeight,
                ),
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: screenWidth * 0.08,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(height: screenHeight * 0.1),
                      
                      // App Logo
                      Container(
                        width: (screenWidth * 0.25).clamp(80.0, 100.0),
                        height: (screenWidth * 0.25).clamp(80.0, 100.0),
                        decoration: BoxDecoration(
                          color: primaryGreen.withValues(alpha: 0.15),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.grass,
                          size: (screenWidth * 0.15).clamp(50.0, 60.0),
                          color: primaryGreen,
                        ),
                      ),
                      
                      SizedBox(height: screenHeight * 0.05),
                      
                      // Heading
                      Text(
                        'Enter Mobile Number',
                        style: GoogleFonts.poppins(
                          fontSize: (screenWidth * 0.065).clamp(24.0, 28.0),
                          fontWeight: FontWeight.bold,
                          color: const Color(0xFF2C3E50),
                        ),
                        textAlign: TextAlign.center,
                      ),
                      
                      SizedBox(height: screenHeight * 0.015),
                      
                      // Instruction Text
                      Text(
                        'We\'ll send a verification code to this number',
                        style: GoogleFonts.poppins(
                          fontSize: (screenWidth * 0.035).clamp(13.0, 15.0),
                          color: const Color(0xFF7F8C8D),
                        ),
                        textAlign: TextAlign.center,
                      ),
                      
                      SizedBox(height: screenHeight * 0.06),
                      
                      // Phone Number Input Field
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.05),
                              blurRadius: 10,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Row(
                          children: [
                            // Country Code
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 18,
                              ),
                              decoration: BoxDecoration(
                                border: Border(
                                  right: BorderSide(
                                    color: Colors.grey.withValues(alpha: 0.3),
                                    width: 1,
                                  ),
                                ),
                              ),
                              child: Row(
                                children: [
                                  Text(
                                    '🇮🇳',
                                    style: TextStyle(
                                      fontSize: (screenWidth * 0.055).clamp(20.0, 24.0),
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    '+91',
                                    style: GoogleFonts.poppins(
                                      fontSize: (screenWidth * 0.04).clamp(15.0, 17.0),
                                      fontWeight: FontWeight.w600,
                                      color: const Color(0xFF2C3E50),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            
                            // Phone Number Input
                            Expanded(
                              child: TextFormField(
                                controller: _phoneController,
                                focusNode: _phoneFocusNode,
                                keyboardType: TextInputType.phone,
                                maxLength: 10,
                                style: GoogleFonts.poppins(
                                  fontSize: (screenWidth * 0.04).clamp(15.0, 17.0),
                                  fontWeight: FontWeight.w500,
                                  color: const Color(0xFF2C3E50),
                                ),
                                inputFormatters: [
                                  FilteringTextInputFormatter.digitsOnly,
                                  LengthLimitingTextInputFormatter(10),
                                ],
                                decoration: InputDecoration(
                                  hintText: 'Mobile Number',
                                  hintStyle: GoogleFonts.poppins(
                                    fontSize: (screenWidth * 0.04).clamp(15.0, 17.0),
                                    color: const Color(0xFFBDC3C7),
                                  ),
                                  border: InputBorder.none,
                                  contentPadding: const EdgeInsets.symmetric(
                                    horizontal: 16,
                                    vertical: 18,
                                  ),
                                  counterText: '',
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      
                      SizedBox(height: screenHeight * 0.05),
                      
                      // Get OTP Button
                      SizedBox(
                        width: double.infinity,
                        height: 56,
                        child: ElevatedButton(
                          onPressed: _isLoading ? null : _handleGetOTP,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: primaryGreen,
                            foregroundColor: Colors.white,
                            disabledBackgroundColor: primaryGreen.withValues(alpha: 0.6),
                            disabledForegroundColor: Colors.white.withValues(alpha: 0.7),
                            elevation: 2,
                            shadowColor: primaryGreen.withValues(alpha: 0.3),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: _isLoading
                              ? SizedBox(
                                  width: 24,
                                  height: 24,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2.5,
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                      Colors.white,
                                    ),
                                  ),
                                )
                              : Text(
                                  'Get OTP',
                                  style: GoogleFonts.poppins(
                                    fontSize: (screenWidth * 0.04).clamp(16.0, 18.0),
                                    fontWeight: FontWeight.w600,
                                    letterSpacing: 0.5,
                                  ),
                                ),
                        ),
                      ),
                      
                      SizedBox(height: screenHeight * 0.1),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
