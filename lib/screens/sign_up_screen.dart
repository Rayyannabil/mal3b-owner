import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mal3b/components/custom_button.dart';
import 'package:mal3b/components/custom_input_component.dart';
import 'package:mal3b/constants/colors.dart';
import 'package:mal3b/helpers/size_helper.dart';
import 'package:mal3b/logic/cubit/authentication_cubit.dart';
import 'package:mal3b/screens/login_screen.dart';
import 'package:mal3b/services/toast_service.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final TextEditingController fullNameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();

  @override
  void dispose() {
    fullNameController.dispose();
    phoneController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  void signup() {
    if (fullNameController.text.isEmpty || fullNameController.text.length < 3) {
      ToastService().showToast(
        message: 'الرجاء إدخال اسمك الكامل',
        type: ToastType.error,
      );
      return;
    }
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
    if (confirmPasswordController.text.isEmpty) {
      ToastService().showToast(
        message: 'الرجاء إعادة إدخال كلمة المرور',
        type: ToastType.error,
      );
      return;
    }
    if (passwordController.text != confirmPasswordController.text) {
      ToastService().showToast(
        message: 'كلمة المرور ليست متطابقة',
        type: ToastType.error,
      );
      return;
    }
    context.read<AuthenticationCubit>().signup(
      name: fullNameController.text,
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
          if (state is AuthenticationSignUpSuccess) {
            ToastService().showToast(
              message: 'تم إنشاء الحساب بنجاح!',
              type: ToastType.success,
            );
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (_) => const LoginScreen()),
            );
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
                  SizedBox(width: getVerticalSpace(context, 20)),
                  const Text(
                    'تخطي',
                    style: TextStyle(fontSize: 20, color: Colors.white),
                  ),
                  SizedBox(width: getHorizontalSpace(context, 12)),
                  const Icon(Icons.arrow_forward_rounded, color: Colors.white),
                  SizedBox(width: getHorizontalSpace(context, 20)),
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(right: 29, top: 70, bottom: 30),
                child: const Text(
                  'إنشاء حساب جديد',
                  style: TextStyle(color: Colors.white, fontSize: 32),
                ),
              ),
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
                              top: 40,
                              left: 20,
                              right: 20,
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                CustomInput(
                                  text: 'اكتب إسمك كامل',
                                  isObsecure: false,
                                  controller: fullNameController,
                                ),
                                SizedBox(height: getVerticalSpace(context, 20)),
                                CustomInput(
                                  text: 'رقم موبايلك',
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
                                CustomInput(
                                  text: 'تأكيد كلمة المرور',
                                  isObsecure: true,
                                  controller: confirmPasswordController,
                                ),
                                SizedBox(height: getVerticalSpace(context, 20)),
                                const Spacer(),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
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
                                                  (_, animation, __, child) {
                                                    final tween =
                                                        Tween(
                                                          begin: const Offset(
                                                            -1.0,
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
                                        onPressed: signup,
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
      ),
    );
  }
}
