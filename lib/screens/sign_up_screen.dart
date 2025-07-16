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
  final TextEditingController nameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();

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
        message: 'اسمك لازم يكون أطول شوية يا نجم',
        type: ToastType.error,
      );
      return;
    }

    if (phoneController.text.isEmpty) {
      ToastService().showToast(
        message: 'دخل رقم موبايلك يا نجم',
        type: ToastType.error,
      );
      return;
    }

    if (!RegExp(r'^\d{11,}$').hasMatch(phoneController.text)) {
      ToastService().showToast(
        message: 'اكتب رقم موبايل صح كده يا نجم',
        type: ToastType.error,
      );
      return;
    }

    if (passwordController.text.isEmpty) {
      ToastService().showToast(
        message: 'اكتب كلمة السر يا نجم',
        type: ToastType.error,
      );
      return;
    }

    if (passwordController.text.length < 8) {
      ToastService().showToast(
        message: 'كلمة السر لازم تكون ٨ حروف على الأقل يا نجم',
        type: ToastType.error,
      );
      return;
    }

    if (confirmPasswordController.text.isEmpty) {
      ToastService().showToast(
        message: 'اكتب تأكيد كلمة السر يا نجم',
        type: ToastType.error,
      );
      return;
    }

    if (passwordController.text != confirmPasswordController.text) {
      ToastService().showToast(
        message: 'كلمة السر مش متطابقة يا نجم',
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
              message: 'تم إنشاء الحساب بنجاح يا نجم!',
              type: ToastType.success,
            );
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (_) => const LoginScreen()),
            );
          } else if (state is AuthenticationSignUpError) {
            String msg = state.msg.trim();
            if (!msg.endsWith('يا نجم')) {
              msg = '$msg يا نجم';
            }
            ToastService().showToast(message: msg, type: ToastType.error);
          }
        },
        builder: (context, state) => SafeArea(
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
              const Padding(
                padding: EdgeInsets.only(right: 29, top: 70, bottom: 30),
                child: Text(
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
                            padding: const EdgeInsets.symmetric(
                              horizontal: 20.0,
                              vertical: 40,
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                CustomInput(
                                  text: 'اكتب إسمك كامل',
                                  isObsecure: false,
                                  controller: nameController,
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
                                BlocBuilder<AuthenticationCubit, AuthenticationState>(
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
                                                      const Duration(milliseconds: 500),
                                                  pageBuilder: (_, __, ___) =>
                                                      const LoginScreen(),
                                                  transitionsBuilder: (_, animation, __, child) {
                                                    final tween = Tween(
                                                      begin: const Offset(-1.0, 0.0),
                                                      end: Offset.zero,
                                                    ).chain(
                                                      CurveTween(curve: Curves.ease),
                                                    );
                                                    return SlideTransition(
                                                      position: animation.drive(tween),
                                                      child: child,
                                                    );
                                                  },
                                                ),
                                              );
                                            },
                                            bgColor: CustomColors.customWhite,
                                            fgColor:
                                                CustomColors.secondary.withOpacity(0.5),
                                            child: const Text('تسجيل الدخول'),
                                          ),
                                        ),
                                        SizedBox(width: getHorizontalSpace(context, 25)),
                                        Expanded(
                                          child: CustomButton(
                                            onPressed: state is AuthenticationLoading
                                                ? null
                                                : signup,
                                            bgColor: CustomColors.secondary,
                                            fgColor: CustomColors.white,
                                            child: state is AuthenticationLoading
                                                ? const SizedBox(
                                                    width: 20,
                                                    height: 20,
                                                    child: CircularProgressIndicator(
                                                      strokeWidth: 2,
                                                      valueColor:
                                                          AlwaysStoppedAnimation<Color>(
                                                              Colors.white),
                                                    ),
                                                  )
                                                : const Text(
                                                    'إنشاء حساب جديد',
                                                    style: TextStyle(fontSize: 12),
                                                  ),
                                          ),
                                        ),
                                      ],
                                    );
                                  },
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
