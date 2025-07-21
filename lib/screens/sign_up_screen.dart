import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:form_validator/form_validator.dart';
import 'package:mal3b/components/custom_button.dart';
import 'package:mal3b/components/custom_input_component.dart';
import 'package:mal3b/constants/colors.dart';
import 'package:mal3b/helpers/size_helper.dart';
import 'package:mal3b/logic/cubit/authentication_cubit.dart';
import 'package:mal3b/services/toast_service.dart';
import '../l10n/app_localizations.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  @override
  void dispose() {
    nameController.dispose();
    phoneController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  void signup() {
    if (_formKey.currentState!.validate()) {
      context.read<AuthenticationCubit>().signup(
        name: nameController.text,
        phone: phoneController.text,
        password: passwordController.text,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CustomColors.primary,
      body: BlocConsumer<AuthenticationCubit, AuthenticationState>(
        listener: (context, state) {
          if (state is AuthenticationSignUpSuccess) {
            ToastService().showToast(
              message: AppLocalizations.of(context)!.signupSuccess,
              type: ToastType.success,
            );
            Navigator.pushReplacementNamed(context, '/login');
          } else if (state is AuthenticationSignUpError) {
            String msg = state.msg.trim();
            if (!msg.endsWith('يا نجم')) {
              msg = '$msg يا نجم';
            }
            ToastService().showToast(message: msg, type: ToastType.error);
          }
        },
        builder: (context, state) => Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: getVerticalSpace(context, 20)),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SafeArea(
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
                Padding(
                  padding: const EdgeInsetsDirectional.only(
                    start: 29,
                    top: 70,
                    bottom: 30,
                  ),
                  child: Text(
                    AppLocalizations.of(context)!.signupTitle,
                    style: const TextStyle(color: Colors.white, fontSize: 32),
                  ),
                ),
              ],
            ),
            Expanded(
              flex: 3,
              child: Container(
                width: double.infinity,
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.vertical(top: Radius.circular(50)),
                  color: Colors.white,
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(50),
                    topRight: Radius.circular(50),
                  ),
                  child: CustomScrollView(
                    slivers: [
                      SliverFillRemaining(
                        hasScrollBody: false,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 20.0,
                            vertical: 40,
                          ),
                          child: Form(
                            key: _formKey,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                CustomInput(
                                  text: AppLocalizations.of(
                                    context,
                                  )!.fullNameHint,
                                  isObsecure: false,
                                  controller: nameController,
                                  validator: ValidationBuilder(
                                    requiredMessage: "دخل اسمك يا نجم",
                                  ).required().build(),
                                ),
                                SizedBox(height: getVerticalSpace(context, 25)),
                                CustomInput(
                                  text: AppLocalizations.of(
                                    context,
                                  )!.mobileHint,
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
                                SizedBox(height: getVerticalSpace(context, 25)),
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
                                            RegExp(
                                              r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)[A-Za-z\d]{8,}$',
                                            ),
                                            "كلمة السر لازم تكون فيها حروف كبيرة وصغيرة وأرقام",
                                          )
                                          .required()
                                          .build(),
                                ),
                                SizedBox(height: getVerticalSpace(context, 25)),
                                CustomInput(
                                  text: AppLocalizations.of(
                                    context,
                                  )!.confirmPassword,
                                  isObsecure: true,
                                  controller: confirmPasswordController,
                                  validator: (value) {
                                    if (value != passwordController.text) {
                                      return "كلمة السر مش متطابقة يا نجم";
                                    }
                                    return null;
                                  },
                                ),
                                SizedBox(height: getVerticalSpace(context, 25)),
                                const Spacer(),
                                BlocBuilder<
                                  AuthenticationCubit,
                                  AuthenticationState
                                >(
                                  builder: (context, state) {
                                    return Row(
                                      children: [
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
                                                      const LoginScreen(),
                                                  transitionsBuilder:
                                                      (
                                                        _,
                                                        animation,
                                                        __,
                                                        child,
                                                      ) {
                                                        final tween =
                                                            Tween(
                                                              begin:
                                                                  const Offset(
                                                                    -1.0,
                                                                    0.0,
                                                                  ),
                                                              end: Offset.zero,
                                                            ).chain(
                                                              CurveTween(
                                                                curve:
                                                                    Curves.ease,
                                                              ),
                                                            );
                                                        return SlideTransition(
                                                          position: animation
                                                              .drive(tween),
                                                          child: child,
                                                        );
                                                      },
                                                ),
                                              );
                                            },
                                            bgColor: CustomColors.customWhite,
                                            fgColor: CustomColors.secondary
                                                .withOpacity(0.5),
                                            text: Text(
                                              AppLocalizations.of(
                                                context,
                                              )!.login,
                                              style: const TextStyle(
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ),
                                        ),
                                        SizedBox(
                                          width: getHorizontalSpace(
                                            context,
                                            25,
                                          ),
                                        ),
                                        Expanded(
                                          child: state is AuthenticationLoading
                                              ? Center(
                                                  child:
                                                      CircularProgressIndicator(),
                                                )
                                              : CustomButton(
                                                  onPressed: signup,
                                                  bgColor:
                                                      CustomColors.secondary,
                                                  fgColor: CustomColors.white,
                                                  text: Text(
                                                    AppLocalizations.of(
                                                      context,
                                                    )!.signup,
                                                    style: const TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                  ),
                                                ),
                                        ),
                                      ],
                                    );
                                  },
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
            ),
          ],
        ),
      ),
    );
  }
}
