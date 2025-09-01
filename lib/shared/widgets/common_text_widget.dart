import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CommonTextWidget extends StatelessWidget {
  const CommonTextWidget({
    super.key,
    required this.data,
    required this.textColor,
    required this.fontSize,
  });

  final String data;

  final Color textColor;

  final double fontSize;

  @override
  Widget build(BuildContext context) {
    return Text(
      data,
      style: GoogleFonts.roboto(
        fontWeight: FontWeight.bold,
        color: textColor,
        fontSize: fontSize,
      ),
    );
  }
}
