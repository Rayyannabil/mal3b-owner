// import 'package:flutter/material.dart';
// import 'package:mal3b/constants/colors.dart';
// import 'package:flutter_localizations/flutter_localizations.dart';
// import 'package:mal3b/screens/login_screen.dart';
// import 'package:mal3b/screens/sign_up_screen.dart';

// void main() {
//   runApp(const Mal3bApp());
// }

// class Mal3bApp extends StatelessWidget {
//   const Mal3bApp({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       theme: ThemeData(
//         primaryColor: CustomColors.primary,
//         scaffoldBackgroundColor: CustomColors.white,
//         fontFamily: 'MadaniArabic',
//         textSelectionTheme: TextSelectionThemeData(
//           cursorColor: Colors.black,
//           selectionColor: CustomColors.primary.withOpacity(0.2),
//           selectionHandleColor: CustomColors.primary,
//         ),
//         elevatedButtonTheme: ElevatedButtonThemeData(
//           style: ElevatedButton.styleFrom(
//             backgroundColor: CustomColors.primary,

//             shape: RoundedRectangleBorder(
//               borderRadius: BorderRadius.circular(12),
//             ),
//           ),
//         ),
//         appBarTheme: const AppBarTheme(
//           backgroundColor: CustomColors.primary,
//           foregroundColor: Colors.white,
//           elevation: 0,
//         ),
//       ),
//       locale: const Locale('en'),
//       supportedLocales: const [Locale('en'), Locale('ar')],
//       localizationsDelegates: [
//         GlobalMaterialLocalizations.delegate,
//         GlobalWidgetsLocalizations.delegate,
//         GlobalCupertinoLocalizations.delegate,
//       ],
//       debugShowCheckedModeBanner: false,
//       home: LoginScreen(),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mal3b/constants/colors.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:mal3b/logic/cubit/authentication_cubit.dart';
import 'package:mal3b/screens/login_screen.dart';
import 'package:mal3b/services/toast_service.dart';

void main() {
  runApp(const Mal3bApp());
}

class Mal3bApp extends StatelessWidget {
  const Mal3bApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AuthenticationCubit(),
      child: MaterialApp(
        navigatorKey: ToastService().navigatorKey, // Add this
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
        locale: const Locale('ar'),
        supportedLocales: const [Locale('en'), Locale('ar')],
        localizationsDelegates: const [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        debugShowCheckedModeBanner: false,
        home: const LoginScreen(),
      ),
    );
  }
}
