// import 'package:flutter/material.dart';
// import 'package:mal3b/components/custom_button.dart';
// import 'package:mal3b/components/custom_input_component.dart';
// import 'package:mal3b/constants/colors.dart';
// import 'package:mal3b/helpers/size_helper.dart';
// import 'package:mal3b/screens/sign_up_screen.dart';

// class LoginScreen extends StatefulWidget {
//   const LoginScreen({super.key});

//   @override
//   _LoginScreenState createState() => _LoginScreenState();
// }

// class _LoginScreenState extends State<LoginScreen> {
//   bool rememberMe = false;

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: CustomColors.primary,

//       body: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           SizedBox(height: getVerticalSpace(context, 20)),
//           SafeArea(
//             child: GestureDetector(
//               onTap: () => print('tapped'),
//               child: Row(
//                 mainAxisAlignment: MainAxisAlignment.end,
//                 children: [
//                   Text(
//                     'Skip',
//                     style: TextStyle(fontSize: 20, color: Colors.white),
//                   ),
//                   SizedBox(width: getHorizontalSpace(context, 12)),
//                   Icon(Icons.arrow_forward_rounded, color: Colors.white),
//                   SizedBox(width: getHorizontalSpace(context, 20)),
//                 ],
//               ),
//             ),
//           ),

//           // Fixed Login text
//           SizedBox(height: getVerticalSpace(context, 70)),
//           Padding(
//             padding: EdgeInsetsGeometry.only(
//               left: getHorizontalSpace(context, 30),
//             ),
//             child: Text(
//               'Log in',
//               style: TextStyle(color: CustomColors.white, fontSize: 32),
//             ),
//           ),

//           SizedBox(height: getVerticalSpace(context, 30)),

//           // Scrollable content
//           Expanded(
//             child: Container(
//               width: double.infinity,
//               decoration: BoxDecoration(
//                 borderRadius: BorderRadius.vertical(top: Radius.circular(50)),
//                 color: Colors.white,
//               ),
//               child: CustomScrollView(
//                 slivers: [
//                   SliverFillRemaining(
//                     hasScrollBody: false,

//                     child: Padding(
//                       padding: const EdgeInsets.only(
//                         left: 20.0,
//                         right: 20.0,
//                         top: 30,
//                       ),
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           Center(
//                             child: Image.asset(
//                               'assets/images/football.png',
//                               width: getImageHeight(context),
//                               height: getImageHeight(context),
//                             ),
//                           ),
//                           SizedBox(height: getVerticalSpace(context, 15)),
//                           CustomInput(text: 'Phone Number', isObsecure: false),
//                           SizedBox(height: getVerticalSpace(context, 20)),
//                           CustomInput(text: 'Password', isObsecure: true),
//                           SizedBox(height: getVerticalSpace(context, 20)),

//                           Row(
//                             children: [
//                               Checkbox(
//                                 shape: RoundedRectangleBorder(
//                                   borderRadius: BorderRadius.circular(6),
//                                 ),
//                                 value: rememberMe,
//                                 onChanged: (value) {
//                                   setState(() {
//                                     rememberMe = value ?? false;
//                                   });
//                                 },
//                                 checkColor: Color(0xFF609966),
//                                 fillColor: MaterialStateProperty.resolveWith((
//                                   states,
//                                 ) {
//                                   return Color(0xFFE3F2C1);
//                                 }),
//                               ),
//                               Text('Remember me'),
//                             ],
//                           ),
//                           Spacer(),
//                           Expanded(
//                             child: Align(
//                               alignment: Alignment.bottomCenter,
//                               child: Row(
//                                 mainAxisAlignment:
//                                     MainAxisAlignment.spaceBetween,
//                                 children: [
//                                   Expanded(
//                                     child: CustomButton(
//                                       onPressed: () {},

//                                       bgColor: CustomColors.customWhite,
//                                       fgColor: CustomColors.secondary
//                                           .withOpacity(0.5),
//                                       text: const Text('Log in'),
//                                     ),
//                                   ),

//                                   SizedBox(
//                                     width: getHorizontalSpace(context, 25),
//                                   ),

//                                   Expanded(
//                                     child: CustomButton(
//                                       onPressed: () {
//                                         Navigator.pushReplacement(
//                                           context,
//                                           PageRouteBuilder(
//                                             transitionDuration: Duration(
//                                               milliseconds: 500,
//                                             ),
//                                             pageBuilder: (_, __, ___) =>
//                                                 const SignUpScreen(),
//                                             transitionsBuilder:
//                                                 (_, animation, __, child) {
//                                                   final tween =
//                                                       Tween(
//                                                         begin: Offset(1.0, 0.0),
//                                                         end: Offset.zero,
//                                                       ).chain(
//                                                         CurveTween(
//                                                           curve: Curves.ease,
//                                                         ),
//                                                       );
//                                                   return SlideTransition(
//                                                     position: animation.drive(
//                                                       tween,
//                                                     ),
//                                                     child: child,
//                                                   );
//                                                 },
//                                           ),
//                                         );
//                                       },
//                                       bgColor: CustomColors.secondary,
//                                       fgColor: CustomColors.white,
//                                       text: const Text('Sign up'),
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                             ),
//                           ),
//                           SizedBox(height: 30),
//                         ],
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ],
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
import 'package:mal3b/screens/sign_up_screen.dart';
import 'package:mal3b/logic/cubit/authentication_cubit.dart';
import 'package:mal3b/services/toast_service.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  late int phone;
  String password = '';
  bool rememberMe = false;

  void login() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      context.read<AuthenticationCubit>().signin(phone, password);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CustomColors.primary,

      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: getVerticalSpace(context, 20)),
          SafeArea(
            child: GestureDetector(
              onTap: () => print('tapped'),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    'Skip',
                    style: TextStyle(fontSize: 20, color: Colors.white),
                  ),
                  SizedBox(width: getHorizontalSpace(context, 12)),
                  Icon(Icons.arrow_forward_rounded, color: Colors.white),
                  SizedBox(width: getHorizontalSpace(context, 20)),
                ],
              ),
            ),
          ),

          // Fixed Login text
          SizedBox(height: getVerticalSpace(context, 70)),
          Padding(
            padding: EdgeInsetsGeometry.only(
              left: getHorizontalSpace(context, 30),
            ),
            child: Text(
              'Log in',
              style: TextStyle(color: CustomColors.white, fontSize: 32),
            ),
          ),

          SizedBox(height: getVerticalSpace(context, 30)),

          // Scrollable content
          Expanded(
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.vertical(top: Radius.circular(50)),
                color: Colors.white,
              ),
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
                          CustomInput(text: 'Phone Number', isObsecure: false),
                          SizedBox(height: getVerticalSpace(context, 20)),
                          CustomInput(text: 'Password', isObsecure: true),
                          SizedBox(height: getVerticalSpace(context, 20)),

                          Row(
                            children: [
                              Checkbox(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                value: _rememberMe,
                                onChanged: (value) {
                                  setState(() {
                                    _rememberMe = value ?? false;
                                  });
                                },
                                checkColor: Color(0xFF609966),
                                fillColor: MaterialStateProperty.resolveWith((
                                  states,
                                ) {
                                  return Color(0xFFE3F2C1);
                                }),
                              ),
                              Text('Remember me'),
                            ],
                          ),
                          Spacer(),
                          Expanded(
                            child: Align(
                              alignment: Alignment.bottomCenter,
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    child: CustomButton(
                                      onPressed: () {},

                                      bgColor: CustomColors.customWhite,
                                      fgColor: CustomColors.secondary
                                          .withOpacity(0.5),
                                      text: const Text('Log in'),
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
                                            transitionDuration: Duration(
                                              milliseconds: 500,
                                            ),
                                            pageBuilder: (_, __, ___) =>
                                                const SignUpScreen(),
                                            transitionsBuilder:
                                                (_, animation, __, child) {
                                                  final tween =
                                                      Tween(
                                                        begin: Offset(1.0, 0.0),
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
                                      text: const Text('Sign up'),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          SizedBox(height: 30),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
