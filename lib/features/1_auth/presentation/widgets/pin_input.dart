import 'package:flutter/material.dart';
import 'package:pinput/pinput.dart';

class PinInput extends StatelessWidget {
  const PinInput({
    super.key,
    required this.controller,
    required this.validator,
    this.onChanged,
  });

  final TextEditingController controller;
  final String? Function(String?)? validator;
  final void Function(String)? onChanged;

  @override
  Widget build(BuildContext context) {
    final baseColor = const Color(0xFF6A994E);
    final defaultTheme = PinTheme(
      width: 54,
      height: 58,
      textStyle: const TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: 20,
        color: Colors.black,
      ),
      decoration: BoxDecoration(
        color: const Color.fromRGBO(240, 240, 240, 1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: baseColor.withValues(alpha: 0.35), width: 1.2),
      ),
    );

    final focusedTheme = defaultTheme.copyWith(
      decoration: defaultTheme.decoration?.copyWith(
        border: Border.all(color: baseColor, width: 1.6),
        boxShadow: const [
          BoxShadow(
            color: Color(0x1A6A994E),
            blurRadius: 10,
            offset: Offset(0, 6),
          ),
        ],
      ),
    );

    return SizedBox(
      width: MediaQuery.widthOf(context) * 0.85,
      child: Pinput(
        controller: controller,
        length: 6,
        keyboardType: TextInputType.number,
        defaultPinTheme: defaultTheme,
        focusedPinTheme: focusedTheme,
        validator: validator,
        onChanged: onChanged,
        hapticFeedbackType: HapticFeedbackType.lightImpact,
      ),
    );
  }
}
