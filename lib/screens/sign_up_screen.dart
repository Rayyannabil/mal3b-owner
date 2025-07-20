import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
  final TextEditingController confirmPasswordController = TextEditingController();

  @override
  void dispose() {
    nameController.dispose();
    phoneController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  void signup() {
    if (nameController.text.isEmpty &&
        phoneController.text.isEmpty &&
        passwordController.text.isEmpty &&
        confirmPasswordController.text.isEmpty) {
      ToastService().showToast(
        message: 'املى بياناتك كلها يا نجم',
        type: ToastType.error,
      );
      return;
    }

    if (nameController.text.isEmpty) {
      ToastService().showToast(
        message: 'اكتب اسمك الأول يا نجم',
        type: ToastType.error,
      );
      return;
    }

    if (nameController.text.length < 3) {
      ToastService().showToast(
        message: AppLocalizations.of(context)!.errorEnterFullName,
        type: ToastType.error,
      );
      return;
    }

    if (phoneController.text.isEmpty) {
      ToastService().showToast(
        message: AppLocalizations.of(context)!.errorEnterPhone,
        type: ToastType.error,
      );
      return;
    }

    if (!RegExp(r'^\d{11,}$').hasMatch(phoneController.text)) {
      ToastService().showToast(
        message: AppLocalizations.of(context)!.errorValidPhone,
        type: ToastType.error,
      );
      return;
    }

    if (passwordController.text.isEmpty) {
      ToastService().showToast(
        message: AppLocalizations.of(context)!.errorEnterPassword,
        type: ToastType.error,
      );
      return;
    }

    if (passwordController.text.length < 8) {
      ToastService().showToast(
        message: AppLocalizations.of(context)!.errorPasswordLength,
        type: ToastType.error,
      );
      return;
    }

    if (confirmPasswordController.text.isEmpty) {
      ToastService().showToast(
        message: AppLocalizations.of(context)!.errorEnterConfirmPassword,
        type: ToastType.error,
      );
      return;
    }

    if (passwordController.text != confirmPasswordController.text) {
      ToastService().showToast(
        message: AppLocalizations.of(context)!.errorPasswordMismatch,
        type: ToastType.error,
      );
      return;
    }

    BlocProvider.of<AuthenticationCubit>(context).signup(
      name: nameController.text,
      phone: phoneController.text,
      password: passwordController.text,
    );
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
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
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
                  Padding(
                    padding: const EdgeInsetsDirectional.only(
                      start: 29,
                      top: 70,
                      bottom: 30,
                    ),
                    child: Text(
                      AppLocalizations.of(context)!.signupTitle,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 32,
                      ),
                    ),
                  ),
                ],
              ),
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
                  borderRadius: BorderRadius.circular(50),
                  child: CustomScrollView(
                    slivers: [
                      SliverFillRemaining(
                        hasScrollBody: false,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 40),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              CustomInput(
                                text: AppLocalizations.of(context)!.fullNameHint,
                                isObsecure: false,
                                controller: nameController,
                              ),
                              SizedBox(height: getVerticalSpace(context, 25)),
                              CustomInput(
                                text: AppLocalizations.of(context)!.mobileHint,
                                isObsecure: false,
                                keyboardType: TextInputType.phone,
                                controller: phoneController,
                              ),
                              SizedBox(height: getVerticalSpace(context, 25)),
                              CustomInput(
                                text: AppLocalizations.of(context)!.password,
                                isObsecure: true,
                                controller: passwordController,
                              ),
                              SizedBox(height: getVerticalSpace(context, 25)),
                              CustomInput(
                                text: AppLocalizations.of(context)!.confirmPassword,
                                isObsecure: true,
                                controller: confirmPasswordController,
                              ),
                              SizedBox(height: getVerticalSpace(context, 25)),
                              const Spacer(),
                              BlocBuilder<AuthenticationCubit, AuthenticationState>(
                                builder: (context, state) {
                                  return Row(
                                    children: [
                                      Expanded(
                                        child: CustomButton(
                                          onPressed: () {
                                            Navigator.pushReplacementNamed(context, '/login');
                                          },
                                          bgColor: CustomColors.customWhite,
                                          fgColor: CustomColors.secondary.withOpacity(0.5),
                                          text: Text(
                                            AppLocalizations.of(context)!.login,
                                            style: const TextStyle(fontWeight: FontWeight.bold),
                                          ),
                                        ),
                                      ),
                                      SizedBox(width: getHorizontalSpace(context, 25)),
                                      Expanded(
                                        child: CustomButton(
                                          onPressed: signup,
                                          bgColor: CustomColors.secondary,
                                          fgColor: CustomColors.white,
                                          text: Text(
                                            AppLocalizations.of(context)!.signup,
                                            style: const TextStyle(fontWeight: FontWeight.bold),
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
