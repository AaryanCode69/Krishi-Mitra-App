import 'package:flutter/material.dart';
import 'package:krishi_mitra/core/constant/colors_theme.dart';
import 'package:krishi_mitra/features/1_auth/presentation/widgets/pin_input.dart';
import 'package:krishi_mitra/shared/widgets/common_text_widget.dart';

class OtpVerificationScreen extends StatelessWidget {
  const OtpVerificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: otpScreenBgColor,
        title: CommonTextWidget(
          data: 'OTP Verification',
          textColor: otpTextColor,
          fontSize: 20,
        ),
      ),
      backgroundColor: otpScreenBgColor,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CommonTextWidget(
              data: 'Enter Verification Code',
              textColor: otpTextColor,
              fontSize: 25,
            ),
            const SizedBox(height: 20),
            CommonTextWidget(
              data:
                  'A 6-digit code has been sent to your\n        registered mobile number',
              textColor: otpSecondTextColor,
              fontSize: 13,
            ),
            const SizedBox(height: 15),
            PinInput(),
          ],
        ),
      ),
    );
  }
}
