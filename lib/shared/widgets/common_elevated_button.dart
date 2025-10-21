import 'package:flutter/material.dart';
import 'package:krishi_mitra/core/constant/colors_theme.dart';

class CommonElevatedButton extends StatelessWidget {
  const CommonElevatedButton({
    super.key,
    required this.onTouch,
    required this.child,
    required this.color,
    required this.height,
    required this.width,
    this.isLoading = false,
  });

  final void Function() onTouch;
  final Widget child;
  final Color color;
  final double width;
  final double height;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
  final disabledColor = color.withValues(alpha: 0.6);
    return ElevatedButton(
      onPressed: isLoading ? null : onTouch,
      style: ElevatedButton.styleFrom(
        fixedSize: Size(width, height),
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        backgroundColor: color,
        disabledBackgroundColor: disabledColor,
        foregroundColor: onDarkTextColor,
      ),
      child: AnimatedSwitcher(
        duration: const Duration(milliseconds: 180),
        child: isLoading
            ? const SizedBox(
                key: ValueKey('loading'),
                width: 24,
                height: 24,
                child: CircularProgressIndicator(
                  strokeWidth: 2.6,
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                ),
              )
            : child,
      ),
    );
  }
}
