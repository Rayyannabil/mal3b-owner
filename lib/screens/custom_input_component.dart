import 'package:flutter/material.dart';

class CustomInput extends StatelessWidget {
  const CustomInput({super.key, required this.text, required this.isObsecure});

  final String text;
  final bool isObsecure;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
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
