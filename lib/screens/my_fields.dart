import 'package:flutter/material.dart';
import 'package:mal3b/helpers/size_helper.dart';

class MyFields extends StatefulWidget {
  const MyFields({super.key});

  @override
  State<MyFields> createState() => _MyFieldsState();
}

class _MyFieldsState extends State<MyFields> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Your stadium list / form / content here
          Center(
            child: Text(
              'الملاعب',
              style: TextStyle(fontSize: getFontTitleSize(context) * 1.2),
            ),
          ),
        ],
      ),
    ),
    );
  }
}
