import 'package:flutter/material.dart';
import 'package:krishi_mitra/shared/widgets/common_text_widget.dart';

class CommonElevatedButton extends StatelessWidget {
  const CommonElevatedButton({
    super.key,
    required this.onTouch,
    required this.textWidget,
    required this.color,
    required this.height,
    required this.width,
  });

  final void Function() onTouch;

  final CommonTextWidget textWidget;

  final Color color;

  final double width;
  final double height;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onTouch,
      style: ElevatedButton.styleFrom(
        fixedSize: Size(width, height),
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadiusGeometry.circular(16),
        ),
        backgroundColor: color,
      ),
      child: textWidget,
    );
  }
}
