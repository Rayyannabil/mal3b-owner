import 'dart:developer';

import 'package:easy_notify/easy_notify.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:mal3b/constants/colors.dart';
import 'package:mal3b/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:mal3b/l10n/app_localizations.dart';
import 'package:mal3b/logic/cubit/add_stadium_cubit.dart';
import 'package:mal3b/logic/cubit/authentication_cubit.dart';
import 'package:mal3b/logic/cubit/bookings_cubit.dart';
import 'package:mal3b/logic/cubit/notification_cubit.dart';
import 'package:mal3b/logic/cubit/stadium_cubit.dart';
import 'package:mal3b/screens/bookings_screen.dart';
import 'package:mal3b/screens/add_stadium.dart';
import 'package:mal3b/screens/edit_profile_screen.dart';
import 'package:mal3b/screens/forgot_password_screen.dart';
import 'package:mal3b/screens/home_screen.dart';
import 'package:mal3b/screens/login_screen.dart';
import 'package:mal3b/screens/my_fields.dart';
import 'package:mal3b/screens/otp_screen.dart';
import 'package:mal3b/screens/payment_screen.dart';
import 'package:mal3b/screens/profile_screen.dart';
import 'package:mal3b/screens/profile_screen_skip.dart';
import 'package:mal3b/screens/sign_up_screen.dart';
import 'package:mal3b/screens/notifications_screen.dart';
import 'package:mal3b/services/notification_wrapper.dart';
import 'package:mal3b/services/toast_service.dart';
import 'package:device_preview/device_preview.dart';

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  final notification = message.notification;
  if (notification != null) {
    EasyNotify.showBasicNotification(
      id: DateTime.now().millisecondsSinceEpoch ~/ 1000,
      title: notification.title ?? 'No title (background)',
      body: notification.body ?? 'No body (background)',
    );
  }
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await EasyNotify.init();
  await EasyNotifyPermissions.requestAll();
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  SystemChrome.setSystemUIOverlayStyle(
    SystemUiOverlayStyle(
      statusBarColor: Colors.transparent, // or any color
      statusBarIconBrightness: Brightness.dark, // For Android
      statusBarBrightness: Brightness.light, // For iOS
    ),
  );
  final FlutterSecureStorage storage = const FlutterSecureStorage();
  final token = await storage.read(key: "accessToken");
  log('Access Token: $token');

  // Default route
  final String initialRoute = (token == null || token.isEmpty)
      ? '/login'
      : '/home';

  runApp(
    NotificationListenerWrapper(child: Mal3bApp(initialRoute: initialRoute)),
  );
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
        BlocProvider(create: (_) => AddStadiumCubit()),
        BlocProvider(create: (_) => BookingsCubit()),
        // Add other cubits here
      ],
      child: MaterialApp(
        builder: (context, child) =>
            DevicePreview.appBuilder(context, child), // ✅ Proper usage,
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
        onGenerateRoute: (settings) {
          switch (settings.name) {
            case '/login':
              return MaterialPageRoute(builder: (_) => const LoginScreen());
            case '/signup':
              return MaterialPageRoute(builder: (_) => const SignUpScreen());
            case '/home':
              return MaterialPageRoute(builder: (_) => const HomeScreen());
            case '/profile':
              return MaterialPageRoute(builder: (_) => ProfileScreen());
            case '/add-stadium':
              return MaterialPageRoute(builder: (_) => AddStadium());
            case '/my-fields':
              return MaterialPageRoute(builder: (_) => MyFields());
            case '/notifications':
              return MaterialPageRoute(
                builder: (_) => const NotificationsScreen(),
              );
            case '/edit-profile':
              final args = settings.arguments as Map<String, String>?;
              final name = args?['name'] ?? '';
              final phone = args?['phone'] ?? '';
              return MaterialPageRoute(
                builder: (_) => EditProfileScreen(name: name, phone: phone),
              );
            case '/payment':
              return MaterialPageRoute(builder: (_) => const PaymentScreen());
            case '/forgot-password':
              return MaterialPageRoute(
                builder: (_) => const ForgotPasswordScreen(),
              );
            case '/profile-screen-skip':
              return MaterialPageRoute(
                builder: (_) => const ProfileScreenSkip(),
              );
            case '/bookings':
              final id = settings.arguments as String;
              return MaterialPageRoute(
                builder: (_) => BookingsScreen(id: id),
              );
            case '/otp-screen':
              final args = settings.arguments as Map<String, String>;
              return MaterialPageRoute(
                builder: (_) => OtpScreen(
                  phoneNumber: args['phone'] ?? '',
                  verificationId: args['verificationId'] ?? '',
                ),
              );
            default:
              return MaterialPageRoute(builder: (_) => const LoginScreen());
          }
        },
      ),
    );
  }
}
