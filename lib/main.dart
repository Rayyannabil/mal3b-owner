import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:mal3b/constants/colors.dart';
import 'package:mal3b/l10n/app_localizations.dart';
import 'package:mal3b/logic/cubit/authentication_cubit.dart';
import 'package:mal3b/logic/cubit/notification_cubit.dart';
import 'package:mal3b/logic/cubit/stadium_cubit.dart';
import 'package:mal3b/screens/booking_screen.dart';
import 'package:mal3b/screens/home_screen.dart';
import 'package:mal3b/screens/landing_screen.dart';
import 'package:mal3b/screens/login_screen.dart';
import 'package:mal3b/screens/profile_screen.dart';
import 'package:mal3b/screens/sign_up_screen.dart';
import 'package:mal3b/screens/notifications_screen.dart';
import 'package:mal3b/services/toast_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final FlutterSecureStorage storage = const FlutterSecureStorage();
  final token = await storage.read(key: "accessToken");

  final String initialRoute = (token == null || token.isEmpty)
      ? '/landing'
      : '/home';

  runApp(Mal3bApp(initialRoute: initialRoute));
}

class Mal3bApp extends StatelessWidget {
  final String initialRoute;
  const Mal3bApp({super.key, required this.initialRoute});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => AuthenticationCubit()),
        BlocProvider(create: (_) => StadiumCubit()),
        BlocProvider(create: (_) => NotificationCubit()),
        // Add other cubits here
      ],
      child: MaterialApp(
        navigatorKey: ToastService().navigatorKey,
        debugShowCheckedModeBanner: false,
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
        locale: const Locale("ar"),
        supportedLocales: AppLocalizations.supportedLocales,
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        initialRoute: initialRoute,
        routes: {
          '/landing': (context) => const LandingScreen(),
          '/login': (context) => const LoginScreen(),
          '/signup': (context) => const SignUpScreen(),
          '/home': (context) => const HomeScreen(),
          '/profile': (context) => const ProfileScreen(),
          '/notifications': (context) => const NotificationsScreen(),
          '/booking': (context) => const BookingScreen(),
        },
      ),
    );
  }
}
