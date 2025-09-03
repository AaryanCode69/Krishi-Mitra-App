import 'package:flutter/material.dart';
import 'package:krishi_mitra/core/constant/colors_theme.dart';
import 'package:krishi_mitra/features/1_auth/presentation/widgets/common_text_button.dart';
import 'package:krishi_mitra/features/1_auth/presentation/widgets/pin_input.dart';
import 'package:krishi_mitra/shared/widgets/common_elevated_button.dart';
import 'package:krishi_mitra/shared/widgets/common_text_widget.dart';

class OtpVerificationScreen extends StatelessWidget {
  const OtpVerificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.heightOf(context);
    double width = MediaQuery.widthOf(context);
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
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              const SizedBox(height: 100),
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
              const SizedBox(height: 40),
              PinInput(),
              const SizedBox(height: 40),
              CommonTextButton(
                onClick: () {},
                content: 'Didnt receive the code? Resend',
              ),
              const SizedBox(height: 70),
              CommonElevatedButton(
                height: height * 0.09,
                width: width * 0.85,
                onTouch: () {},
                textWidget: CommonTextWidget(
                  data: 'Verify & Proceed',
                  textColor: Colors.white,
                  fontSize: 20,
                ),
                color: cardTextColor,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
