import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:krishi_mitra/core/constant/colors_theme.dart';
import 'package:krishi_mitra/shared/widgets/common_text_widget.dart';

class CustomTextFormField extends StatelessWidget {
  const CustomTextFormField({
    super.key,
    required this.textEditingController,
    required this.onChange,
    required this.content,
    required this.hint,
    this.validator,
    this.keyboardType = TextInputType.text,
    this.textInputAction,
    this.labelColor,
  });

  final TextEditingController textEditingController;
  final void Function(String) onChange;
  final String content;
  final String hint;
  final String? Function(String?)? validator;
  final TextInputType keyboardType;
  final TextInputAction? textInputAction;
  final Color? labelColor;

  @override
  Widget build(BuildContext context) {
    final effectiveLabelColor = labelColor ?? Colors.white;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CommonTextWidget(
          data: content,
          textColor: effectiveLabelColor,
          fontSize: 16,
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: textEditingController,
          onChanged: onChange,
          keyboardType: keyboardType,
          textInputAction: textInputAction,
          validator: validator,
          style: GoogleFonts.poppins(
            color: Colors.white,
            fontSize: 15,
            fontWeight: FontWeight.w500,
          ),
          decoration: InputDecoration(
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
            hintText: hint,
            hintStyle: GoogleFonts.poppins(
              color: formTextColor,
              fontSize: 14,
              fontWeight: FontWeight.w400,
            ),
            filled: true,
            fillColor: inputFieldBackground,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: BorderSide.none,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: BorderSide(
                color: Colors.white.withValues(alpha: 0.04),
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: const BorderSide(color: cardTextColor, width: 1.4),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: const BorderSide(color: Colors.redAccent),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: const BorderSide(color: Colors.redAccent, width: 1.4),
            ),
          ),
        ),
      ],
    );
  }
}
