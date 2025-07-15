import 'package:flutter/material.dart';

class CustomInput extends StatelessWidget {
  const CustomInput({
    super.key,
    required this.text,
    required this.isObsecure,
    required this.onSubmit,
    required this.validator,
  });

  final String text;
  final bool isObsecure;
  final dynamic onSubmit;
  final String? Function(dynamic) validator;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      onFieldSubmitted: onSubmit,
      obscureText: isObsecure,
      decoration: InputDecoration(
        hintText: text,
        enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.grey),
        ),
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: Color(0xFF40513B), width: 2.0),
        ),
      ),
    );
  }
}
