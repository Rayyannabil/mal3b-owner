import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:form_validator/form_validator.dart';
import 'package:mal3b/components/custom_button.dart';
import 'package:mal3b/components/custom_input_component.dart';
import 'package:mal3b/constants/colors.dart';
import 'package:mal3b/helpers/size_helper.dart';
import 'package:mal3b/logic/cubit/authentication_cubit.dart';
import 'package:mal3b/screens/sign_up_screen.dart';
import 'package:mal3b/services/toast_service.dart';
import '../l10n/app_localizations.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    phoneController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  void login() {
    if (_formKey.currentState!.validate()) {
      context.read<AuthenticationCubit>().login(
        phone: phoneController.text,
        password: passwordController.text,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CustomColors.primary,
      body: BlocListener<AuthenticationCubit, AuthenticationState>(
        listener: (context, state) {
          if (state is AuthenticationSignInSuccess) {
            ToastService().showToast(
              message: "تم تسجيل الدخول يا نجم",
              type: ToastType.success,
            );
            Navigator.pushNamedAndRemoveUntil(
              context,
              '/home',
              (route) => false,
            );
          } else if (state is AuthenticationSignInError) {
            ToastService().showToast(
              message: state.msg.endsWith("يا نجم")
                  ? state.msg
                  : "${state.msg} يا نجم",
              type: ToastType.error,
            );
          }
        },
        child: Form(
          key: _formKey,
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
                      Text(
                        AppLocalizations.of(context)!.skip,
                        style: const TextStyle(
                          fontSize: 20,
                          color: Colors.white,
                        ),
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
                padding: EdgeInsetsDirectional.only(
                  start: getHorizontalSpace(context, 30),
                ),
                child: Text(
                  AppLocalizations.of(context)!.loginTitle,
                  style: const TextStyle(
                    color: CustomColors.white,
                    fontSize: 32,
                  ),
                ),
              ),
              SizedBox(height: getVerticalSpace(context, 30)),
              Expanded(
                child: Container(
                  width: double.infinity,
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(50),
                    ),
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
                                  text: AppLocalizations.of(context)!.phoneHint,
                                  isObsecure: false,
                                  keyboardType: TextInputType.phone,
                                  controller: phoneController,
                                  validator:
                                      ValidationBuilder(
                                            requiredMessage:
                                                "دخل رقم التلفون يا نجم",
                                          )
                                          .phone(
                                            "مش هينفع رقم التلفون ده يا نجم",
                                          )
                                          .required()
                                          .build(),
                                ),
                                SizedBox(height: getVerticalSpace(context, 20)),
                                CustomInput(
                                  text: AppLocalizations.of(context)!.password,
                                  isObsecure: true,
                                  controller: passwordController,
                                  validator:
                                      ValidationBuilder(
                                            requiredMessage:
                                                "دخل كلمة السر يا نجم",
                                          )
                                          .minLength(
                                            8,
                                            "اقل حاجه 8 حروف يا نجم",
                                          )
                                          .regExp(
                                            RegExp("[A-Z]"),
                                            "لازم يكون في حرف كبير يا نجم",
                                          )
                                          .regExp(
                                            RegExp("[a-z]"),
                                            "لازم يكون في حرف صغير يا نجم",
                                          )
                                          .regExp(
                                            RegExp("[0-9]"),
                                            "لازم يكون في رقم يا نجم",
                                          )
                                          .regExp(
                                            RegExp("[^a-zA-Z0-9]"),
                                            "لازم يكون في رمز خاص يا نجم",
                                          )
                                          .required()
                                          .build(),
                                ),
                                SizedBox(height: getVerticalSpace(context, 30)),
                                Align(
                                  alignment: Alignment.topRight,
                                  child: Text(
                                    AppLocalizations.of(
                                      context,
                                    )!.forgotPassword,
                                    style: const TextStyle(
                                      decoration: TextDecoration.underline,
                                      fontFamily: "MadaniArabic",
                                      color: CustomColors.primary,
                                      fontSize: 12,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                ),
                                const Spacer(),
                                SizedBox(height: 10),
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
                                        text: Text(
                                          AppLocalizations.of(context)!.login,
                                          style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
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
                                              transitionDuration:
                                                  const Duration(
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
                                        text: Text(
                                          AppLocalizations.of(
                                            context,
                                          )!.createAccount,
                                          style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                          ),
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
      ),
    );
  }
}
