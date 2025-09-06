import 'package:flutter/material.dart';
import 'package:krishi_mitra/core/constant/colors_theme.dart';
import 'package:krishi_mitra/shared/widgets/common_text_widget.dart';

class CustomDropDownButton extends StatelessWidget {
  const CustomDropDownButton({
    super.key,
    required this.items,
    required this.onChanged,
    required this.value,
  });

  final List<String> items;
  final void Function(String?)? onChanged;
  final String? value;
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CommonTextWidget(data: 'State', textColor: otpTextColor, fontSize: 20),
        const SizedBox(height: 2),
        DropdownButtonFormField<String>(
          initialValue: value,
          decoration: InputDecoration(
            fillColor: Colors.grey.withOpacity(0.15),
            filled: true,
            floatingLabelBehavior: FloatingLabelBehavior.always,
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(13)),
          ),
          hint: CommonTextWidget(
            data: 'Select a State',
            textColor: Colors.grey.withOpacity(0.15),
            fontSize: 20,
          ),
          items: items.map((String item) {
            return DropdownMenuItem(value: item, child: Text(item));
          }).toList(),
          onChanged: onChanged,
        ),
      ],
    );
  }
}
