import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mal3b/logic/cubit/authentication_cubit.dart';
import 'package:mal3b/components/custom_button.dart';
import 'package:mal3b/components/custom_input_component.dart';
import 'package:mal3b/constants/colors.dart';
import 'package:mal3b/helpers/size_helper.dart';
import 'package:mal3b/screens/add_stadium.dart';
import 'package:mal3b/services/toast_service.dart';

class OtpScreen extends StatefulWidget {
  final String phoneNumber;
  final String verificationId;

  const OtpScreen({
    Key? key,
    required this.phoneNumber,
    required this.verificationId,
  }) : super(key: key);

  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  final TextEditingController otpController = TextEditingController();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  int secondsRemaining = 60;
  bool enableResend = false;
  Timer? timer;
  bool isVerifying = false;

  @override
  void initState() {
    super.initState();
    _startCountdown();
    // OTP is already sent during login/signup screen
  }

  void _startCountdown() {
    secondsRemaining = 60;
    enableResend = false;
    timer?.cancel();
    timer = Timer.periodic(const Duration(seconds: 1), (t) {
      if (secondsRemaining == 0) {
        enableResend = true;
        t.cancel();
      } else {
        secondsRemaining--;
      }
      setState(() {});
    });
  }

  Future<void> _verifyOtp() async {
    if (!formKey.currentState!.validate()) return;

    setState(() => isVerifying = true);
    try {
      final credential = PhoneAuthProvider.credential(
        verificationId: widget.verificationId,
        smsCode: otpController.text.trim(),
      );
      await FirebaseAuth.instance.signInWithCredential(credential);

      // Notify Cubit that sign-in succeeded
      context.read<AuthenticationCubit>().emit(
        AuthenticationSignInSuccess(msg: 'تم التحقق بنجاح يا نجم'),
      );

      Navigator.of(context).pushNamedAndRemoveUntil('/add-stadium', (r) => false);
    } catch (e) {
      ToastService().showToast(
        message: 'الكود غير صحيح يا نجم',
        type: ToastType.error,
      );
    }
    setState(() => isVerifying = false);
  }

  @override
  void dispose() {
    timer?.cancel();
    otpController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: BlocListener<AuthenticationCubit, AuthenticationState>(
        listener: (context, state) {
          if (state is AuthenticationSignUpSuccess) {
            ToastService().showToast(
              message: "تم التحقق بنجاح",
              type: ToastType.success,
            );
            Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(builder: (context) => AddStadium()),
              (route) => false,
            );
          } else if (state is AuthenticationSignUpError) {
            ToastService().showToast(message: state.msg, type: ToastType.error);
          }
        },
        child: Column(
          children: [
            SafeArea(
              child: Padding(
                padding: const EdgeInsets.only(top: 30),
                child: Text(
                  'نسيت كلمة المرور',
                  style: TextStyle(
                    color: CustomColors.primary,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            Form(
              key: formKey,
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 20),
                          child: Text(
                            "أدخل رمز التحقق المرسل إلى ",
                            style: TextStyle(
                              fontFamily: "MadaniArabic",
                              fontSize: getFontSubTitleSize(context),
                              color: Colors.black,
                            ),
                          ),
                        ),
                        Text(
                          widget.phoneNumber,
                          style: const TextStyle(
                            fontFamily: "MadaniArabic",
                            fontSize: 16,
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 100),
                    SvgPicture.asset(
                      "assets/images/otp_illustration.svg",
                      height: getImageHeight(context),
                      width: getImageHeight(context),
                    ),
                    SizedBox(height: 20),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      child: CustomInput(
                        isObsecure: false,
                        onSubmit: (value) {
                          if (value.length == 6) {
                            FocusScope.of(context).unfocus();
                            if (formKey.currentState!.validate()) {
                              _verifyOtp();
                            }
                          }
                        },
                        text: "أدخل كود التحقق (6 أرقام)",
                        controller: otpController,
                        keyboardType: TextInputType.number,
                        validator: (value) {
                          if (value == null || value.length != 6) {
                            return "الرجاء إدخال 6 أرقام";
                          }
                          return null;
                        },
                      ),
                    ),
                    const SizedBox(height: 30),
                    if (isVerifying)
                      const CircularProgressIndicator(
                        color: CustomColors.primary,
                      )
                    else if (enableResend)
                      TextButton(
                        onPressed: () {
                          _verifyOtp();
                          _startCountdown();
                        },
                        child: const Text(
                          "إعادة إرسال الكود",
                          style: TextStyle(
                            color: CustomColors.primary,
                            fontWeight: FontWeight.bold,
                            fontFamily: "MadaniArabic",
                          ),
                        ),
                      )
                    else
                      Text(
                        "يمكنك إعادة الإرسال خلال $secondsRemaining ثانية",
                        style: const TextStyle(
                          fontFamily: "MadaniArabic",
                          color: Colors.grey,
                        ),
                      ),
                    SizedBox(
                      height: getVerticalSpace(
                        context,
                        getVerticalSpace(context, 50),
                      ),
                    ),
                    CustomButton(
                      onPressed: () {},
                      bgColor: CustomColors.primary,
                      fgColor: Colors.white,
                      text: Text('إرسال الكود'),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
