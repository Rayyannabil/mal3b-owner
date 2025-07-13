import 'package:flutter/material.dart';
import 'package:mal3b/screens/login_screen.dart';

void main() {
  runApp(const Mal3bApp());
}

class Mal3bApp extends StatelessWidget {
  const Mal3bApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(debugShowCheckedModeBanner: false, home: LoginScreen());
  }
}
