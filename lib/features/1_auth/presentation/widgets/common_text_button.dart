import 'package:flutter/material.dart';
import 'package:krishi_mitra/core/constant/colors_theme.dart';

class CommonTextButton extends StatelessWidget {
  const CommonTextButton({
    super.key,
    required this.onClick,
    required this.content,
  });

  final void Function() onClick;
  final String content;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onClick,
      child: Text(
        content,
        style: TextStyle(
          decoration: TextDecoration.underline,
          color: otpSecondTextColor,
          fontSize: 15,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
