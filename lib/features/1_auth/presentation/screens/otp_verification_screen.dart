import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:krishi_mitra/core/constant/colors_theme.dart';
import 'package:krishi_mitra/features/1_auth/application/auth_providers.dart';
import 'package:krishi_mitra/features/1_auth/application/auth_state.dart';
import 'package:krishi_mitra/features/1_auth/presentation/widgets/common_text_button.dart';
import 'package:krishi_mitra/features/1_auth/presentation/widgets/pin_input.dart';
import 'package:krishi_mitra/shared/widgets/common_elevated_button.dart';
import 'package:krishi_mitra/shared/widgets/common_text_widget.dart';

class OtpVerificationScreen extends ConsumerStatefulWidget {
  final String? phoneNumber;

  const OtpVerificationScreen({super.key, this.phoneNumber});

  @override
  ConsumerState<OtpVerificationScreen> createState() =>
      _OtpVerificationScreenState();
}

class _OtpVerificationScreenState extends ConsumerState<OtpVerificationScreen> {
  final TextEditingController _otpController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _otpController.dispose();
    super.dispose();
  }

  void _handleVerifyOtp() {
    final otp = _otpController.text.trim();

    // Basic validation
    if (otp.isEmpty) {
      _showErrorSnackBar('Please enter the OTP');
      return;
    }

    if (otp.length != 6) {
      _showErrorSnackBar('Please enter a valid 6-digit OTP');
      return;
    }

    if (widget.phoneNumber == null || widget.phoneNumber!.isEmpty) {
      _showErrorSnackBar('Phone number is missing');
      return;
    }

    // Call verify OTP
    ref.read(authProvider.notifier).verifyOtp(widget.phoneNumber!, otp);
  }

  void _handleResendOtp() {
    // TODO: Implement resend OTP logic
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'OTP resent successfully',
          style: GoogleFonts.poppins(color: Colors.white),
        ),
        backgroundColor: primaryGreen,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        margin: const EdgeInsets.all(16),
      ),
    );
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message, style: GoogleFonts.poppins(color: Colors.white)),
        backgroundColor: Colors.red.shade600,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        margin: const EdgeInsets.all(16),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authProvider);
    final height = MediaQuery.sizeOf(context).height;
    final width = MediaQuery.sizeOf(context).width;
    final isLoading = authState.status == AuthStatus.loading;

    // Listen to auth state changes for navigation
    // This must be called within the build method
    ref.listen<AuthState>(authProvider, (previous, next) {
      print('🔔 [OTP Screen] Auth state changed: ${next.status}');
      print('🔔 [OTP Screen] Profile complete: ${next.profileComplete}');
      
      if (next.status == AuthStatus.success) {
        // Navigate based on profileComplete value
        if (next.profileComplete == true) {
          print('✅ [OTP Screen] Navigating to /home');
          // Profile is complete, go to home
          context.go('/home');
        } else {
          print('✅ [OTP Screen] Navigating to /create-account');
          // Profile is not complete, go to create account
          context.go('/create-account');
        }
      } else if (next.status == AuthStatus.error) {
        print('❌ [OTP Screen] Error: ${next.errorMessage}');
      }
    });

    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: otpScreenBgColor,
        elevation: 0,
        title: const CommonTextWidget(
          data: 'OTP Verification',
          textColor: otpTextColor,
          fontSize: 20,
        ),
      ),
      backgroundColor: otpScreenBgColor,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: 12),
                  Text(
                    'Enter Verification Code',
                    style: GoogleFonts.poppins(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                      color: otpTextColor,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'A 6-digit code has been sent to your registered mobile number',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.poppins(
                      color: otpSecondTextColor,
                      fontSize: 14,
                      height: 1.4,
                    ),
                  ),
                  if (widget.phoneNumber != null) ...[
                    const SizedBox(height: 8),
                    Text(
                      widget.phoneNumber!,
                      style: GoogleFonts.poppins(
                        color: otpTextColor,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                  const SizedBox(height: 36),
                  PinInput(
                    controller: _otpController,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter OTP';
                      }
                      if (value.length != 6) {
                        return 'OTP must be 6 digits';
                      }
                      return null;
                    },
                    onChanged: (value) {
                      // Clear error when user types
                      if (authState.status == AuthStatus.error) {
                        ref.read(authProvider.notifier).reset();
                      }
                    },
                  ),
                  if (authState.status == AuthStatus.error &&
                      authState.errorMessage != null) ...[
                    const SizedBox(height: 16),
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.red.shade50,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.red.shade200),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.error_outline,
                            color: Colors.red.shade700,
                            size: 20,
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              authState.errorMessage!,
                              style: GoogleFonts.poppins(
                                color: Colors.red.shade700,
                                fontSize: 13,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                  const SizedBox(height: 28),
                  CommonTextButton(
                    onClick: isLoading ? () {} : _handleResendOtp,
                    content: "Didn't receive the code? Resend",
                  ),
                  const SizedBox(height: 48),
                  CommonElevatedButton(
                    height: height * 0.08,
                    width: width * 0.8,
                    color: otpButtonGreen,
                    isLoading: isLoading,
                    onTouch: isLoading ? () {} : _handleVerifyOtp,
                    child: const CommonTextWidget(
                      data: 'Verify & Proceed',
                      textColor: Colors.white,
                      fontSize: 18,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
