// import 'package:flutter/material.dart';
// import 'package:mal3b/components/custom_button.dart';
// import 'package:mal3b/components/custom_input_component.dart';
// import 'package:mal3b/constants/colors.dart';
// import 'package:mal3b/helpers/size_helper.dart';
// import 'package:mal3b/screens/login_screen.dart';

// class SignUpScreen extends StatefulWidget {
//   const SignUpScreen({super.key});

//   @override
//   _SignUpScreenState createState() => _SignUpScreenState();
// }

// class _SignUpScreenState extends State<SignUpScreen> {
//   bool rememberMe = false;

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: const Color(0xFF609966),

//       body: SafeArea(
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             SizedBox(height: getVerticalSpace(context, 20)),
//             GestureDetector(
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

//             // Fixed Sign Up text
//             Padding(
//               padding: const EdgeInsets.only(left: 29, top: 70, bottom: 30),
//               child: Text(
//                 'Sign Up',
//                 style: TextStyle(color: Colors.white, fontSize: 32),
//               ),
//             ),

//             // Scrollable content
//             Expanded(
//               child: Container(
//                 width: double.infinity,
//                 decoration: BoxDecoration(
//                   borderRadius: BorderRadius.vertical(top: Radius.circular(50)),
//                   color: Colors.white,
//                 ),
//                 child: CustomScrollView(
//                   slivers: [
//                     SliverFillRemaining(
//                       hasScrollBody: false,
//                       child: Padding(
//                         padding: EdgeInsets.only(top: 40, left: 20, right: 20),
//                         child: Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             CustomInput(text: 'Full Name', isObsecure: false),
//                             SizedBox(height: getVerticalSpace(context, 20)),
//                             CustomInput(
//                               text: 'Phone Number',
//                               isObsecure: false,
//                             ),
//                             SizedBox(height: getVerticalSpace(context, 20)),
//                             CustomInput(text: 'Password', isObsecure: true),
//                             SizedBox(height: getVerticalSpace(context, 20)),
//                             CustomInput(
//                               text: 'Confirm Password',
//                               isObsecure: true,
//                             ),
//                             SizedBox(height: getVerticalSpace(context, 20)),
//                             Row(
//                               children: [
//                                 Checkbox(
//                                   shape: RoundedRectangleBorder(
//                                     borderRadius: BorderRadius.circular(6),
//                                   ),
//                                   value: rememberMe,
//                                   onChanged: (value) {
//                                     setState(() {
//                                       rememberMe = value ?? false;
//                                     });
//                                   },
//                                   checkColor: Color(0xFF609966),
//                                   fillColor: MaterialStateProperty.resolveWith((
//                                     states,
//                                   ) {
//                                     return Color(0xFFE3F2C1);
//                                   }),
//                                 ),
//                                 Text('Remember me'),
//                               ],
//                             ),
//                             Spacer(),
//                             Row(
//                               mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                               children: [
//                                 Expanded(
//                                   child: CustomButton(
//                                     onPressed: () {
//                                       Navigator.pushReplacement(
//                                         context,
//                                         PageRouteBuilder(
//                                           transitionDuration: Duration(
//                                             milliseconds: 500,
//                                           ),
//                                           pageBuilder: (_, __, ___) =>
//                                               const LoginScreen(),
//                                           transitionsBuilder:
//                                               (_, animation, __, child) {
//                                                 final tween =
//                                                     Tween(
//                                                       begin: Offset(-1.0, 0.0),
//                                                       end: Offset.zero,
//                                                     ).chain(
//                                                       CurveTween(
//                                                         curve: Curves.ease,
//                                                       ),
//                                                     );
//                                                 return SlideTransition(
//                                                   position: animation.drive(
//                                                     tween,
//                                                   ),
//                                                   child: child,
//                                                 );
//                                               },
//                                         ),
//                                       );
//                                     },
//                                     bgColor: CustomColors.customWhite,
//                                     fgColor: CustomColors.secondary.withOpacity(
//                                       0.5,
//                                     ),
//                                     text: const Text('Log in'),
//                                   ),
//                                 ),

//                                 SizedBox(
//                                   width: getHorizontalSpace(context, 25),
//                                 ),

//                                 Expanded(
//                                   child: CustomButton(
//                                     onPressed: () {},
//                                     bgColor: CustomColors.secondary,
//                                     fgColor: CustomColors.white,
//                                     text: const Text('Sign up'),
//                                   ),
//                                 ),
//                               ],
//                             ),
//                             SizedBox(height: 30),
//                           ],
//                         ),
//                       ),
//                     ),
//                   ],
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
import 'package:mal3b/screens/login_screen.dart';
import 'package:mal3b/logic/cubit/authentication_cubit.dart';
import 'package:mal3b/services/toast_service.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  String fullName = '';
  late int phone;
  String password = '';
  String confirmPassword = '';
  bool rememberMe = false;

  void signup() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      if (password != confirmPassword) {
        ToastService().showToast(
          message: "Passwords don't match",
          type: ToastType.error,
        );
        return;
      }
      context.read<AuthenticationCubit>().signup(fullName, phone, password);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CustomColors.primary,
      body: BlocListener<AuthenticationCubit, AuthenticationState>(
        listener: (context, state) {
          if (state is AuthenticationSignUpSuccess) {
            ToastService().showToast(message: 'Account created!', type: ToastType.success);
          } else if (state is AuthenticationSignUpError) {
            ToastService().showToast(message: state.msg, type: ToastType.error);
          }
        },
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: getVerticalSpace(context, 20)),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text('Skip', style: TextStyle(fontSize: 20, color: Colors.white)),
                  SizedBox(width: getHorizontalSpace(context, 12)),
                  Icon(Icons.arrow_forward_rounded, color: Colors.white),
                  SizedBox(width: getHorizontalSpace(context, 20)),
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(left: 29, top: 70, bottom: 30),
                child: Text('Sign Up', style: TextStyle(color: Colors.white, fontSize: 32)),
              ),
              Expanded(
                child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.vertical(top: Radius.circular(50)),
                    color: Colors.white,
                  ),
                  child: Form(
                    key: _formKey,
                    child: CustomScrollView(
                      slivers: [
                        SliverFillRemaining(
                          hasScrollBody: false,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
                            child: Column(
                              children: [
                                CustomInput(
                                  text: 'Full Name',
                                  isObsecure: false,
                                  onSubmit: (value) => fullName = value!,
                                  validator: (value) =>
                                      value!.isEmpty ? 'Please enter your name' : null,
                                ),
                                SizedBox(height: getVerticalSpace(context, 20)),
                                CustomInput(
                                  text: 'Phone Number',
                                  isObsecure: false,
                                  onSubmit: (value) => phone = value!,
                                  validator: (value) =>
                                      value!.isEmpty ? 'Please enter phone' : null,
                                ),
                                SizedBox(height: getVerticalSpace(context, 20)),
                                CustomInput(
                                  text: 'Password',
                                  isObsecure: true,
                                  onSubmit: (value) => password = value!,
                                  validator: (value) =>
                                      value!.length < 6 ? 'Password too short' : null,
                                ),
                                SizedBox(height: getVerticalSpace(context, 20)),
                                CustomInput(
                                  text: 'Confirm Password',
                                  isObsecure: true,
                                  onSubmit: (value) => confirmPassword = value!,
                                  validator: (value) =>
                                      value!.isEmpty ? 'Please confirm password' : null,
                                ),
                                SizedBox(height: getVerticalSpace(context, 20)),
                                Row(
                                  children: [
                                    Checkbox(
                                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
                                      value: rememberMe,
                                      onChanged: (value) {
                                        setState(() {
                                          rememberMe = value ?? false;
                                        });
                                      },
                                      checkColor: CustomColors.primary,
                                      fillColor: MaterialStateProperty.all(Color(0xFFE3F2C1)),
                                    ),
                                    Text('Remember me'),
                                  ],
                                ),
                                Spacer(),
                                Row(
                                  children: [
                                    Expanded(
                                      child: CustomButton(
                                        onPressed: () {
                                          Navigator.pushReplacement(
                                            context,
                                            PageRouteBuilder(
                                              transitionDuration: Duration(milliseconds: 500),
                                              pageBuilder: (_, __, ___) => const LoginScreen(),
                                              transitionsBuilder: (_, animation, __, child) {
                                                final tween = Tween(
                                                  begin: Offset(-1.0, 0.0),
                                                  end: Offset.zero,
                                                ).chain(CurveTween(curve: Curves.ease));
                                                return SlideTransition(
                                                  position: animation.drive(tween),
                                                  child: child,
                                                );
                                              },
                                            ),
                                          );
                                        },
                                        bgColor: CustomColors.customWhite,
                                        fgColor: CustomColors.secondary.withOpacity(0.5),
                                        text: const Text('Log in'),
                                      ),
                                    ),
                                    SizedBox(width: getHorizontalSpace(context, 25)),
                                    Expanded(
                                      child: CustomButton(
                                        onPressed: signup,
                                        bgColor: CustomColors.secondary,
                                        fgColor: CustomColors.white,
                                        text: const Text('Sign up'),
                                      ),
                                    ),
                                  ],
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
              ),
            ],
          ),
        ),
      ),
    );
  }
}
