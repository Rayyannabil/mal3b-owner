// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:mal3b/components/custom_button.dart';
// import 'package:mal3b/components/custom_input_component.dart';
// import 'package:mal3b/constants/colors.dart';
// import 'package:mal3b/helpers/size_helper.dart';
// import 'package:mal3b/logic/cubit/authentication_cubit.dart';
// import 'package:mal3b/screens/home_screen.dart';
// import 'package:mal3b/screens/sign_up_screen.dart';
// import 'package:mal3b/services/toast_service.dart';

// class LoginScreen extends StatefulWidget {
//   const LoginScreen({super.key});

//   @override
//   State<LoginScreen> createState() => _LoginScreenState();
// }

// class _LoginScreenState extends State<LoginScreen> {
//   final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
//   String phone = '';
//   String password = '';
//   bool rememberMe = false;

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: CustomColors.primary,
//       body: BlocListener<AuthenticationCubit, AuthenticationState>(
//         listener: (context, state) {
//           if (state is AuthenticationSignInSuccess) {
//             ToastService().showToast(
//               message: state.msg,
//               type: ToastType.success,
//             );
//             // Navigate to home screen
//             Navigator.pushReplacement(
//               context,
//               MaterialPageRoute(builder: (_) => const HomeScreen()),
//             );
//           } else if (state is AuthenticationSignInError) {
//             ToastService().showToast(message: state.msg, type: ToastType.error);
//           }
//         },
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             SizedBox(height: getVerticalSpace(context, 20)),
//             SafeArea(
//               child: GestureDetector(
//                 onTap: () => print('tapped'),
//                 child: Row(
//                   mainAxisAlignment: MainAxisAlignment.end,
//                   children: [
//                     SizedBox(width: getVerticalSpace(context, 20)),

//                     const Text(
//                       'تخطي',
//                       style: TextStyle(fontSize: 20, color: Colors.white),
//                     ),
//                     SizedBox(width: getHorizontalSpace(context, 12)),
//                     const Icon(
//                       Icons.arrow_forward_rounded,
//                       color: Colors.white,
//                     ),
//                     SizedBox(width: getHorizontalSpace(context, 20)),
//                   ],
//                 ),
//               ),
//             ),
//             SizedBox(height: getVerticalSpace(context, 70)),
//             Padding(
//               padding: EdgeInsets.only(right: getHorizontalSpace(context, 30)),
//               child: const Text(
//                 'تسجيل الدخول',
//                 style: TextStyle(color: CustomColors.white, fontSize: 32),
//               ),
//             ),
//             SizedBox(height: getVerticalSpace(context, 30)),
//             Expanded(
//               child: Container(
//                 width: double.infinity,
//                 decoration: const BoxDecoration(
//                   borderRadius: BorderRadius.vertical(top: Radius.circular(50)),
//                   color: Colors.white,
//                 ),
//                 child: ClipRRect(
//                   borderRadius: BorderRadius.circular(50),
//                   child: CustomScrollView(
//                     slivers: [
//                       SliverFillRemaining(
//                         hasScrollBody: false,
//                         child: Padding(
//                           padding: const EdgeInsets.only(
//                             left: 20.0,
//                             right: 20.0,
//                             top: 30,
//                           ),
//                           child: Form(
//                             key: _formKey,
//                             child: Column(
//                               crossAxisAlignment: CrossAxisAlignment.start,
//                               children: [
//                                 Center(
//                                   child: Image.asset(
//                                     'assets/images/football.png',
//                                     width: getImageHeight(context),
//                                     height: getImageHeight(context),
//                                   ),
//                                 ),
//                                 SizedBox(height: getVerticalSpace(context, 15)),
//                                 CustomInput(
//                                   text: 'اكتب رقم تليفونك',
//                                   isObsecure: false,
//                                   keyboardType: TextInputType.phone,
//                                   onSaved: (value) => phone = value ?? '',
//                                   validator: (value) {
//                                     if (value == null || value.isEmpty) {
//                                       return 'الرجاء ادخال رقم تليفون';
//                                     }
//                                     if (!RegExp(r'^\d{11,}$').hasMatch(value)) {
//                                       return 'الرجاء ادخال رقم تليفون صحيح';
//                                     }
//                                     return null;
//                                   },
//                                 ),
//                                 SizedBox(height: getVerticalSpace(context, 20)),
//                                 CustomInput(
//                                   text: 'كلمة المرور',
//                                   isObsecure: true,
//                                   onSaved: (value) => password = value ?? '',
//                                   validator: (value) {
//                                     if (value == null || value.isEmpty) {
//                                       return 'الرجاء إدخال كلمة المرور';
//                                     }
//                                     if (value.length < 8) {
//                                       return 'كلمة المرور يجب أن تكون 8 أحرف على الأقل';
//                                     }
//                                     return null;
//                                   },
//                                 ),
//                                 SizedBox(height: getVerticalSpace(context, 20)),
//                                 Align(
//                                   alignment: Alignment.topRight,
//                                   child: Text(
//                                     "نسيت كلمة المرور؟",
//                                     style: TextStyle(
//                                       decoration: TextDecoration.underline,
//                                       fontFamily: "MadaniArabic",
//                                       color: CustomColors.primary,
//                                       fontSize: 12,
//                                       fontWeight: FontWeight.w400,
//                                     ),
//                                   ),
//                                 ),
//                                 const Spacer(),
//                                 Row(
//                                   mainAxisAlignment:
//                                       MainAxisAlignment.spaceBetween,
//                                   children: [
//                                     Expanded(
//                                       child: CustomButton(
//                                         onPressed: () {
//                                           if (_formKey.currentState!
//                                               .validate()) {
//                                             _formKey.currentState!.save();
//                                             context
//                                                 .read<AuthenticationCubit>()
//                                                 .login(
//                                                   phone: phone,
//                                                   password: password,
//                                                 );
//                                           }
//                                         },
//                                         bgColor: CustomColors.customWhite,
//                                         fgColor: CustomColors.secondary
//                                             .withOpacity(0.5),
//                                         text: const Text('تسجيل الدخول'),
//                                       ),
//                                     ),
//                                     SizedBox(
//                                       width: getHorizontalSpace(context, 25),
//                                     ),
//                                     Expanded(
//                                       child: CustomButton(
//                                         onPressed: () {
//                                           Navigator.pushReplacement(
//                                             context,
//                                             PageRouteBuilder(
//                                               transitionDuration:
//                                                   const Duration(
//                                                     milliseconds: 500,
//                                                   ),
//                                               pageBuilder: (_, __, ___) =>
//                                                   const SignUpScreen(),
//                                               transitionsBuilder:
//                                                   (_, animation, __, child) {
//                                                     final tween =
//                                                         Tween(
//                                                           begin: const Offset(
//                                                             1.0,
//                                                             0.0,
//                                                           ),
//                                                           end: Offset.zero,
//                                                         ).chain(
//                                                           CurveTween(
//                                                             curve: Curves.ease,
//                                                           ),
//                                                         );
//                                                     return SlideTransition(
//                                                       position: animation.drive(
//                                                         tween,
//                                                       ),
//                                                       child: child,
//                                                     );
//                                                   },
//                                             ),
//                                           );
//                                         },
//                                         bgColor: CustomColors.secondary,
//                                         fgColor: CustomColors.white,
//                                         text: const Text(
//                                           'إنشاء حساب جديد',
//                                           style: TextStyle(fontSize: 12),
//                                         ),
//                                       ),
//                                     ),
//                                   ],
//                                 ),
//                                 const SizedBox(height: 30),
//                               ],
//                             ),
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mal3b/components/custom_button.dart';
import 'package:mal3b/components/custom_input_component.dart';
import 'package:mal3b/constants/colors.dart';
import 'package:mal3b/helpers/size_helper.dart';
import 'package:mal3b/logic/cubit/authentication_cubit.dart';
import 'package:mal3b/screens/home_screen.dart';
import 'package:mal3b/screens/sign_up_screen.dart';
import 'package:mal3b/services/toast_service.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  void dispose() {
    phoneController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  void login() {
    if (phoneController.text.isEmpty) {
      ToastService().showToast(
        message: 'الرجاء إدخال رقم الهاتف',
        type: ToastType.error,
      );
      return;
    }
    if (!RegExp(r'^\d{11,}$').hasMatch(phoneController.text)) {
      ToastService().showToast(
        message: 'الرجاء إدخال رقم هاتف صحيح',
        type: ToastType.error,
      );
      return;
    }
    if (passwordController.text.isEmpty) {
      ToastService().showToast(
        message: 'الرجاء إدخال كلمة المرور',
        type: ToastType.error,
      );
      return;
    }
    if (passwordController.text.length < 8) {
      ToastService().showToast(
        message: 'كلمة المرور يجب أن تكون 8 أحرف على الأقل',
        type: ToastType.error,
      );
      return;
    }
    context.read<AuthenticationCubit>().login(
      phone: phoneController.text,
      password: passwordController.text,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CustomColors.primary,
      body: BlocListener<AuthenticationCubit, AuthenticationState>(
        listener: (context, state) {
          if (state is AuthenticationSignInSuccess) {
            ToastService().showToast(
              message: state.msg,
              type: ToastType.success,
            );
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (_) => const HomeScreen()),
            );
          } else if (state is AuthenticationSignInError) {
            ToastService().showToast(message: state.msg, type: ToastType.error);
          }
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: getVerticalSpace(context, 20)),
            SafeArea(
              child: GestureDetector(
                onTap: () => print('tapped'),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    SizedBox(width: getVerticalSpace(context, 20)),
                    const Text(
                      'تخطي',
                      style: TextStyle(fontSize: 20, color: Colors.white),
                    ),
                    SizedBox(width: getHorizontalSpace(context, 12)),
                    const Icon(
                      Icons.arrow_forward_rounded,
                      color: Colors.white,
                    ),
                    SizedBox(width: getHorizontalSpace(context, 20)),
                  ],
                ),
              ),
            ),
            SizedBox(height: getVerticalSpace(context, 70)),
            Padding(
              padding: EdgeInsets.only(right: getHorizontalSpace(context, 30)),
              child: const Text(
                'تسجيل الدخول',
                style: TextStyle(color: CustomColors.white, fontSize: 32),
              ),
            ),
            SizedBox(height: getVerticalSpace(context, 30)),
            Expanded(
              child: Container(
                width: double.infinity,
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.vertical(top: Radius.circular(50)),
                  color: Colors.white,
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(50),

                  child: CustomScrollView(
                    slivers: [
                      SliverFillRemaining(
                        hasScrollBody: false,
                        child: Padding(
                          padding: const EdgeInsets.only(
                            left: 20.0,
                            right: 20.0,
                            top: 30,
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Center(
                                child: Image.asset(
                                  'assets/images/football.png',
                                  width: getImageHeight(context),
                                  height: getImageHeight(context),
                                ),
                              ),
                              SizedBox(height: getVerticalSpace(context, 15)),
                              CustomInput(
                                text: 'اكتب رقم تليفونك',
                                isObsecure: false,
                                keyboardType: TextInputType.phone,
                                controller: phoneController,
                              ),
                              SizedBox(height: getVerticalSpace(context, 20)),
                              CustomInput(
                                text: 'كلمة المرور',
                                isObsecure: true,
                                controller: passwordController,
                              ),
                              SizedBox(height: getVerticalSpace(context, 20)),
                              Align(
                                alignment: Alignment.topRight,
                                child: Text(
                                  "نسيت كلمة المرور؟",
                                  style: TextStyle(
                                    decoration: TextDecoration.underline,
                                    fontFamily: "MadaniArabic",
                                    color: CustomColors.primary,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                              ),
                              const Spacer(),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    child: CustomButton(
                                      onPressed: login,
                                      bgColor: CustomColors.customWhite,
                                      fgColor: CustomColors.secondary
                                          .withOpacity(0.5),
                                      text: const Text('تسجيل الدخول'),
                                    ),
                                  ),
                                  SizedBox(
                                    width: getHorizontalSpace(context, 25),
                                  ),
                                  Expanded(
                                    child: CustomButton(
                                      onPressed: () {
                                        Navigator.pushReplacement(
                                          context,
                                          PageRouteBuilder(
                                            transitionDuration: const Duration(
                                              milliseconds: 500,
                                            ),
                                            pageBuilder: (_, __, ___) =>
                                                const SignUpScreen(),
                                            transitionsBuilder:
                                                (_, animation, __, child) {
                                                  final tween =
                                                      Tween(
                                                        begin: const Offset(
                                                          1.0,
                                                          0.0,
                                                        ),
                                                        end: Offset.zero,
                                                      ).chain(
                                                        CurveTween(
                                                          curve: Curves.ease,
                                                        ),
                                                      );
                                                  return SlideTransition(
                                                    position: animation.drive(
                                                      tween,
                                                    ),
                                                    child: child,
                                                  );
                                                },
                                          ),
                                        );
                                      },
                                      bgColor: CustomColors.secondary,
                                      fgColor: CustomColors.white,
                                      text: const Text(
                                        'إنشاء حساب جديد',
                                        style: TextStyle(fontSize: 12),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 30),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
