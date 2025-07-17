import 'package:flutter/material.dart';
import 'package:device_preview/device_preview.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mal3b/constants/colors.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:mal3b/l10n/app_localizations.dart';
import 'package:mal3b/logic/cubit/authentication_cubit.dart';
import 'package:mal3b/screens/home_screen.dart';
import 'package:mal3b/screens/landing_screen.dart';
import 'package:mal3b/services/toast_service.dart';

void main() {
  runApp(DevicePreview(enabled: true, builder: (context) => const Mal3bApp()));
}

ValueNotifier<String> language = ValueNotifier<String>("en");

class Mal3bApp extends StatelessWidget {
  const Mal3bApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<String>(
      valueListenable: language,
      builder: (context, value, child) {
        return BlocProvider(
          create: (context) => AuthenticationCubit(),
          child: MaterialApp(
            navigatorKey: ToastService().navigatorKey, 
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
            locale: Locale(value),
            supportedLocales: AppLocalizations.supportedLocales,
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            debugShowCheckedModeBanner: false,
            home: HomeScreen(),
          ),
        );
      },
    );
  }
}
