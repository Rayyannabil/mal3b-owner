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
import 'package:mal3b/screens/home_screen.dart';
import 'package:mal3b/services/toast_service.dart';

class OtpScreen extends StatefulWidget {
  final String phoneNumber;
  final String verificationId;
  final String name;
  final String phone;
  final String password;
  final bool isResetFlow;

  const OtpScreen({
    super.key,
    required this.phoneNumber,
    required this.verificationId,
    required this.name,
    required this.password,
    required this.phone,
    required this.isResetFlow,
  });

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

  late String _verificationId;

  @override
  void initState() {
    super.initState();
    _verificationId = widget.verificationId;
    _startCountdown();
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

  /// ✅ Fixed phone number formatting to E.164 format
  String _formatPhoneNumber(String phone) {
    // Remove all non-digit characters and whitespace
    String digitsOnly = phone.replaceAll(RegExp(r'[^\d]'), '').trim();

    print('Original phone: $phone');
    print('Digits only: $digitsOnly');

    // Handle Egyptian numbers specifically
    if (digitsOnly.startsWith('2010') ||
        digitsOnly.startsWith('2011') ||
        digitsOnly.startsWith('2012') ||
        digitsOnly.startsWith('2015')) {
      // Already has full country code (20) + mobile prefix
      String formatted = '+$digitsOnly';
      print('Case 1 - Already formatted: $formatted');
      return formatted;
    } else if (digitsOnly.startsWith('010') ||
        digitsOnly.startsWith('011') ||
        digitsOnly.startsWith('012') ||
        digitsOnly.startsWith('015')) {
      // Egyptian mobile with leading 0
      String formatted = '+20${digitsOnly.substring(1)}';
      print('Case 2 - Remove leading 0: $formatted');
      return formatted;
    } else if (digitsOnly.startsWith('10') ||
        digitsOnly.startsWith('11') ||
        digitsOnly.startsWith('12') ||
        digitsOnly.startsWith('15')) {
      // Egyptian mobile without leading 0
      String formatted = '+20$digitsOnly';
      print('Case 3 - Add country code: $formatted');
      return formatted;
    } else if (digitsOnly.length == 11 && digitsOnly.startsWith('0')) {
      // 11 digits starting with 0
      String formatted = '+20${digitsOnly.substring(1)}';
      print('Case 4 - 11 digits with 0: $formatted');
      return formatted;
    } else if (digitsOnly.length == 10) {
      // 10 digits, assume mobile without 0
      String formatted = '+20$digitsOnly';
      print('Case 5 - 10 digits: $formatted');
      return formatted;
    } else {
      // Fallback
      String formatted = '+20$digitsOnly';
      print('Case 6 - Fallback: $formatted');
      return formatted;
    }
  }

  /// 🔹 Verify OTP entered by the user
  Future<void> _verifyOtp() async {
    if (!formKey.currentState!.validate()) return;

    setState(() => isVerifying = true);
    try {
      final credential = PhoneAuthProvider.credential(
        verificationId: _verificationId,
        smsCode: otpController.text.trim(),
      );
      await FirebaseAuth.instance.signInWithCredential(credential);

      if (widget.isResetFlow) {
        Navigator.of(context).pushNamedAndRemoveUntil(
          '/reset-password',
          (r) => false,
          arguments: {'phone': widget.phone, 'otp': otpController.text.trim()},
        );
      } else {
        context.read<AuthenticationCubit>().emit(
          AuthenticationSignInSuccess(msg: 'تم التحقق بنجاح يا نجم'),
        );
        context.read<AuthenticationCubit>().signup(
          name: widget.name,
          phone: widget.phone,
          password: widget.password,
        );
        Navigator.of(context).pushNamedAndRemoveUntil('/home', (r) => false);
      }
    } catch (e) {
      ToastService().showToast(
        message: 'الكود غير صحيح يا نجم',
        type: ToastType.error,
      );
    }
    setState(() => isVerifying = false);
  }

  /// 🔹 Resend OTP with properly formatted number
  Future<void> _resendOtp() async {
    final formattedPhone = _formatPhoneNumber(widget.phoneNumber);

    // Validate the formatted number before sending
    if (!formattedPhone.startsWith('+20') || formattedPhone.length < 13) {
      ToastService().showToast(
        message: "تنسيق رقم الهاتف غير صحيح",
        type: ToastType.error,
      );
      return;
    }

    print('Sending OTP to: $formattedPhone');

    try {
      await FirebaseAuth.instance.verifyPhoneNumber(
        phoneNumber: formattedPhone,
        timeout: const Duration(seconds: 60),
        verificationCompleted: (PhoneAuthCredential credential) async {
          try {
            await FirebaseAuth.instance.signInWithCredential(credential);
            context.read<AuthenticationCubit>().emit(
              AuthenticationSignInSuccess(msg: 'تم التحقق تلقائياً'),
            );
            Navigator.of(
              context,
            ).pushNamedAndRemoveUntil('/home', (r) => false);
          } catch (e) {
            print('Auto verification error: $e');
            ToastService().showToast(
              message: "فشل التحقق التلقائي",
              type: ToastType.error,
            );
          }
        },
        verificationFailed: (FirebaseAuthException e) {
          print('Verification failed: ${e.code} - ${e.message}');
          String errorMessage = "فشل إرسال الكود";

          // Handle specific error codes
          switch (e.code) {
            case 'invalid-phone-number':
              errorMessage = "رقم الهاتف غير صحيح";
              break;
            case 'too-many-requests':
              errorMessage = "تم إرسال عدد كبير من الطلبات، حاول لاحقاً";
              break;
            case 'quota-exceeded':
              errorMessage = "تم تجاوز الحد المسموح، حاول لاحقاً";
              break;
            default:
              errorMessage = e.message ?? "فشل إرسال الكود";
          }

          ToastService().showToast(
            message: errorMessage,
            type: ToastType.error,
          );
        },
        codeSent: (String verificationId, int? resendToken) {
          _verificationId = verificationId; // update verificationId
          ToastService().showToast(
            message: "تم إرسال الكود مرة أخرى",
            type: ToastType.success,
          );
          _startCountdown();
        },
        codeAutoRetrievalTimeout: (String verificationId) {
          _verificationId = verificationId;
        },
      );
    } catch (e) {
      print('Error in resend OTP: $e');
      ToastService().showToast(
        message: "خطأ في إرسال الكود",
        type: ToastType.error,
      );
    }
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
              MaterialPageRoute(builder: (context) => HomeScreen()),
              (route) => false,
            );
          } else if (state is AuthenticationSignUpError) {
            ToastService().showToast(message: state.msg, type: ToastType.error);
          }
        },
        child: SingleChildScrollView(
          child: Column(
            children: [
              SafeArea(
                child: Padding(
                  padding: const EdgeInsets.only(top: 30),
                  child: Text(
                    'أدخل رمز التحقق للإستمرار',
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
                            _formatPhoneNumber(widget.phoneNumber),
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
                          onPressed: _resendOtp,
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
                        onPressed: _verifyOtp,
                        bgColor: CustomColors.primary,
                        fgColor: Colors.white,
                        text: const Text('إرسال الكود'),
                      ),
                    ],
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
