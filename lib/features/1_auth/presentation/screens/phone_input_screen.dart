import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:krishi_mitra/core/constant/colors_theme.dart';

class PhoneInputScreen extends StatefulWidget {
  const PhoneInputScreen({super.key});

  @override
  State<PhoneInputScreen> createState() => _PhoneInputScreenState();
}

class _PhoneInputScreenState extends State<PhoneInputScreen> {
  final TextEditingController _phoneController = TextEditingController();
  final FocusNode _phoneFocusNode = FocusNode();

  @override
  void dispose() {
    _phoneController.dispose();
    _phoneFocusNode.dispose();
    super.dispose();
  }

  void _handleGetOTP() {
    print('Get OTP pressed with phone: ${_phoneController.text}');
    // Navigate to OTP verification screen (placeholder for now)
    context.push('/otp');
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
                          onPressed: _handleGetOTP,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: primaryGreen,
                            foregroundColor: Colors.white,
                            elevation: 2,
                            shadowColor: primaryGreen.withValues(alpha: 0.3),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: Text(
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
