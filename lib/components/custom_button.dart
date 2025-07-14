import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  const CustomButton({
    super.key,
    required this.onPressed,
    required this.bgColor,
    required this.fgColor,
    required this.text,
  });

  final VoidCallback onPressed;
  final Color bgColor;
  final Color fgColor;
  final Text text;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        fixedSize: Size(150, 45),
        backgroundColor: bgColor,
        foregroundColor: fgColor,
      ),
      child: text,
    );
  }
}
