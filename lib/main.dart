import 'package:flutter/material.dart';
import 'package:mal3b/constants/colors.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:mal3b/screens/sign_up_screen.dart';

void main() {
  runApp(const Mal3bApp());
}

class Mal3bApp extends StatelessWidget {
  const Mal3bApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primaryColor: CustomColors.primary,
        scaffoldBackgroundColor: CustomColors.white,
        fontFamily: 'MadaniArabic',
        textSelectionTheme: TextSelectionThemeData(
          cursorColor: Colors.black,
          selectionColor: CustomColors.primary.withOpacity(0.2),
          selectionHandleColor: CustomColors.primary,
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: CustomColors.primary,

            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: CustomColors.primary,
          foregroundColor: Colors.white,
          elevation: 0,
        ),
      ),
      locale: const Locale('en'),
      supportedLocales: const [Locale('en'), Locale('ar')],
      localizationsDelegates: [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      debugShowCheckedModeBanner: false,
      home: SignUpScreen(),
    );
  }
}
