import 'package:flutter/material.dart';
import 'package:krishi_mitra/core/constant/colors_theme.dart';
import 'package:krishi_mitra/shared/widgets/common_text_widget.dart';
import 'package:profanity_filter/profanity_filter.dart';

class CustomTextFormField extends StatelessWidget {
  const CustomTextFormField({
    super.key,
    required this.textEditingController,
    required this.onChange,
    required this.content,
    required this.hint,
  });

  final TextEditingController textEditingController;

  final void Function(String) onChange;

  final String content;

  final String hint;

  @override
  Widget build(BuildContext context) {
    final filter = ProfanityFilter();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CommonTextWidget(
          data: content,
          textColor: const Color(0xFF272b2b),
          fontSize: 20,
        ),
        const SizedBox(height: 2),
        TextFormField(
          controller: textEditingController,
          onChanged: onChange,
          keyboardType: TextInputType.text,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please Enter a Username';
            }
            if (filter.hasProfanity(value)) {
              return 'Please avoid using inappropriate language.';
            }
            return null;
          },
          decoration: InputDecoration(
            fillColor: Colors.grey.withOpacity(0.15),
            filled: true,
            hint: CommonTextWidget(
              data: hint,
              textColor: formTextColor,
              fontSize: 15,
            ),
            floatingLabelBehavior: FloatingLabelBehavior.always,
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(13)),
          ),
        ),
      ],
    );
  }
}
