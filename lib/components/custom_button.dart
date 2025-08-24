import 'package:flutter/material.dart';
import 'package:mal3b/helpers/size_helper.dart';

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
        padding: EdgeInsets.symmetric(
          vertical: getVerticalSpace(context, 12),
          horizontal: getHorizontalSpace(context, 20),
        ),
        elevation: elevation ?? 3,
        fixedSize: Size(width ?? 150, getButtonHeight(context)),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(radius ?? 16),
        ),
        backgroundColor: bgColor,
        foregroundColor: fgColor,
        side: borderSide,
      ),
      child: text,
    );
  }
}
