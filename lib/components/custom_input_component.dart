import 'package:flutter/material.dart';
import 'package:mal3b/constants/colors.dart';

class CustomInput extends StatefulWidget {
  const CustomInput({
    super.key,
    required this.text,
    required this.isObsecure,
    this.onSubmit,
    this.onSaved,
    this.validator,
    this.keyboardType = TextInputType.text,
    this.controller,
    this.maxLines,
  });

  final String text;
  final bool isObsecure;
  final void Function(String)? onSubmit;
  final void Function(String?)? onSaved;
  final String? Function(String?)? validator;
  final TextInputType keyboardType;
  final TextEditingController? controller;
  final int? maxLines;

  @override
  State<CustomInput> createState() => _CustomInputState();
}

class _CustomInputState extends State<CustomInput> {
  late bool _isObscure;

  @override
  void initState() {
    super.initState();
    _isObscure = widget.isObsecure;
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      maxLines: widget.isObsecure ? 1 : widget.maxLines,
      controller: widget.controller,
      onFieldSubmitted: widget.onSubmit,
      onSaved: widget.onSaved,
      validator: widget.validator,
      obscureText: _isObscure,
      keyboardType: widget.keyboardType,
      decoration: InputDecoration(
        hintText: widget.text,
        enabledBorder: const UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.grey),
        ),
        focusedBorder: const UnderlineInputBorder(
          borderSide: BorderSide(color: Color(0xFF40513B), width: 2.0),
        ),
        suffixIcon: widget.isObsecure
            ? IconButton(
                icon: Icon(
                  _isObscure ? Icons.visibility_off : Icons.visibility,
                  color: CustomColors.primary,
                ),
                onPressed: () {
                  setState(() {
                    _isObscure = !_isObscure;
                  });
                },
              )
            : null,
      ),
    );
  }
}
