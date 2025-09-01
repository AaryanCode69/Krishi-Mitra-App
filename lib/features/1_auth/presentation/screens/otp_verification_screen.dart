import 'package:flutter/material.dart';
import 'package:krishi_mitra/core/constant/colors_theme.dart';
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
    );
  }
}
