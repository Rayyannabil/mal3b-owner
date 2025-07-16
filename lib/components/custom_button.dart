import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  const CustomButton({
    super.key,
    required this.onPressed,
    required this.bgColor,
    required this.fgColor,
    required this.text,
    this.radius,
    this.width,
    this.elevation,
    this.borderSide,
  });

  final VoidCallback? onPressed;
  final Color bgColor;
  final Color fgColor;
  final double? radius;
  final double? width;
  final Text text;
  final BorderSide? borderSide;
  final double? elevation;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        elevation: elevation ?? 3,
        fixedSize: Size(width ?? 150, 45),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(radius ?? 16),
        ),
        backgroundColor: bgColor,
        foregroundColor: fgColor,
        side: borderSide,
      ),
      child: Center(child: child),
    );
  }
}
