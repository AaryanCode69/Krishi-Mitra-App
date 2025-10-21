import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:krishi_mitra/core/constant/colors_theme.dart';
import 'package:krishi_mitra/features/1_auth/application/auth_providers.dart';
import 'package:krishi_mitra/features/1_auth/presentation/widgets/common_text_button.dart';
import 'package:krishi_mitra/features/1_auth/presentation/widgets/pin_input.dart';
import 'package:krishi_mitra/shared/widgets/common_elevated_button.dart';
import 'package:krishi_mitra/shared/widgets/common_text_widget.dart';

class OtpVerificationScreen extends ConsumerWidget {
  const OtpVerificationScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(otpVerificationProvider);
    final notifier = ref.read(otpVerificationProvider.notifier);

    final height = MediaQuery.sizeOf(context).height;
    final width = MediaQuery.sizeOf(context).width;

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
              key: notifier.formKey,
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
                  const SizedBox(height: 36),
                  PinInput(
                    controller: notifier.otpController,
                    validator: notifier.validateOtp,
                    onChanged: notifier.onOtpChanged,
                  ),
                  if (state.errorMessage != null) ...[
                    const SizedBox(height: 16),
                    Text(
                      state.errorMessage!,
                      style: GoogleFonts.poppins(
                        color: Colors.redAccent,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                  const SizedBox(height: 28),
                  CommonTextButton(
                    onClick: () => notifier.resendCode(context),
                    content: "Didn't receive the code? Resend",
                  ),
                  const SizedBox(height: 48),
                  CommonElevatedButton(
                    height: height * 0.08,
                    width: width * 0.8,
                    color: otpButtonGreen,
                    isLoading: state.status.isLoading,
                    onTouch: () => notifier.verifyOtp(context),
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
