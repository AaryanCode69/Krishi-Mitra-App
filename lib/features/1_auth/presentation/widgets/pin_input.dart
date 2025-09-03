import 'package:flutter/material.dart';
import 'package:pinput/pinput.dart';

class PinInput extends StatelessWidget {
  const PinInput({super.key});

  @override
  Widget build(BuildContext context) {
    final defaultTheme = PinTheme(
      width: 56,
      height: 60,
      decoration: BoxDecoration(
        color: const Color.fromRGBO(240, 240, 240, 1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0xFF6A994E)),
      ),
    );

    return SizedBox(
      width: MediaQuery.widthOf(context) * 0.9,
      child: Pinput(
        length: 6,
        mainAxisAlignment: MainAxisAlignment.center,
        hapticFeedbackType: HapticFeedbackType.lightImpact,
        defaultPinTheme: defaultTheme,
      ),
    );
  }
}
