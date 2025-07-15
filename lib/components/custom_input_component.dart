// // import 'package:flutter/material.dart';

// // class CustomInput extends StatelessWidget {
// //   const CustomInput({
// //     super.key,
// //     required this.text,
// //     required this.isObsecure,
// //     required this.onSubmit,
// //     // required this.validator,
// //   });

// //   final String text;
// //   final bool isObsecure;
// //   final dynamic onSubmit;
// //   // final String? Function(dynamic) validator;

// //   @override
// //   Widget build(BuildContext context) {
// //     return TextFormField(
// //       onFieldSubmitted: onSubmit,
// //       obscureText: isObsecure,
// //       decoration: InputDecoration(
// //         hintText: text,
// //         enabledBorder: UnderlineInputBorder(
// //           borderSide: BorderSide(color: Colors.grey),
// //         ),
// //         focusedBorder: UnderlineInputBorder(
// //           borderSide: BorderSide(color: Color(0xFF40513B), width: 2.0),
// //         ),
// //       ),
// //     );
// //   }
// // }

// import 'package:flutter/material.dart';

// class CustomInput extends StatelessWidget {
//   const CustomInput({
//     super.key,
//     required this.text,
//     required this.isObsecure,
//     this.onSubmit,
//     this.onSaved,
//     this.validator,
//     this.keyboardType = TextInputType.text,
//   });

//   final String text;
//   final bool isObsecure;
//   final void Function(String)? onSubmit;
//   final void Function(String?)? onSaved;
//   final String? Function(String?)? validator;
//   final TextInputType keyboardType;

//   @override
//   Widget build(BuildContext context) {
//     return TextFormField(
//       onFieldSubmitted: onSubmit,
//       onSaved: onSaved,
//       validator: validator,
//       obscureText: isObsecure,
//       keyboardType: keyboardType,
//       decoration: InputDecoration(
//         hintText: text,
//         enabledBorder: const UnderlineInputBorder(
//           borderSide: BorderSide(color: Colors.grey),
//         ),
//         focusedBorder: const UnderlineInputBorder(
//           borderSide: BorderSide(color: Color(0xFF40513B), width: 2.0),
//         ),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';

class CustomInput extends StatelessWidget {
  const CustomInput({
    super.key,
    required this.text,
    required this.isObsecure,
    this.onSubmit,
    this.onSaved,
    this.validator,
    this.keyboardType = TextInputType.text,
    this.controller,
  });

  final String text;
  final bool isObsecure;
  final void Function(String)? onSubmit;
  final void Function(String?)? onSaved;
  final String? Function(String?)? validator;
  final TextInputType keyboardType;
  final TextEditingController? controller;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      onFieldSubmitted: onSubmit,
      onSaved: onSaved,
      validator: validator,
      obscureText: isObsecure,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        hintText: text,
        enabledBorder: const UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.grey),
        ),
        focusedBorder: const UnderlineInputBorder(
          borderSide: BorderSide(color: Color(0xFF40513B), width: 2.0),
        ),
      ),
    );
  }
}