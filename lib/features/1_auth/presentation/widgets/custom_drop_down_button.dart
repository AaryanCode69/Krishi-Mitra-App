import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:krishi_mitra/core/constant/colors_theme.dart';
import 'package:krishi_mitra/shared/widgets/common_text_widget.dart';

class CustomDropDownButton extends StatelessWidget {
  const CustomDropDownButton({
    super.key,
    required this.items,
    required this.onChanged,
    required this.value,
    this.validator,
    this.label = 'State',
    this.labelColor,
  });

  final List<String> items;
  final void Function(String?)? onChanged;
  final String? value;
  final String? Function(String?)? validator;
  final String label;
  final Color? labelColor;

  @override
  Widget build(BuildContext context) {
    final effectiveLabelColor = labelColor ?? Colors.white;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CommonTextWidget(
          data: label,
          textColor: effectiveLabelColor,
          fontSize: 16,
        ),
        const SizedBox(height: 8),
        DropdownButtonFormField<String>(
          initialValue: value,
          validator: validator,
          dropdownColor: inputFieldBackground,
          style: GoogleFonts.poppins(
            color: Colors.white,
            fontSize: 15,
            fontWeight: FontWeight.w500,
          ),
          decoration: InputDecoration(
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 18, vertical: 4),
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
          hint: Text(
            'Select your state',
            style: GoogleFonts.poppins(
              color: formTextColor,
              fontSize: 14,
              fontWeight: FontWeight.w400,
            ),
          ),
          icon: const Icon(Icons.keyboard_arrow_down_rounded, color: Colors.white),
          onChanged: onChanged,
          items: items
              .map(
                (item) => DropdownMenuItem<String>(
                  value: item,
                  child: Text(item),
                ),
              )
              .toList(),
        ),
      ],
    );
  }
}
