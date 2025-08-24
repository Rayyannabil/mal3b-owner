import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:form_validator/form_validator.dart';
import 'package:mal3b/components/custom_button.dart';
import 'package:mal3b/components/custom_input_component.dart';
import 'package:mal3b/constants/colors.dart';
import 'package:mal3b/helpers/size_helper.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final TextEditingController phoneController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
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
            SizedBox(height: getVerticalSpace(context, 100)),
            SvgPicture.asset(
              'assets/images/forgot_password.svg',
              width: getHorizontalSpace(context, 350),
            ),

            /// ⬇️ Form starts here
            Form(
              key: _formKey,
              child: Padding(
                padding: const EdgeInsets.all(15),
                child: CustomInput(
                  text: 'اكتب رقم تليفونك',
                  isObsecure: false,
                  controller: phoneController,
                  validator: ValidationBuilder(
                    requiredMessage: "دخل رقم تليفونك يا نجم",
                  ).required().build(),
                ),
              ),
            ),
            SizedBox(height: getVerticalSpace(context, 50)),

            /// ⬇️ Button to send OTP
            CustomButton(
              onPressed: () async {
                if (!_formKey.currentState!.validate()) return;

                final phone = "+2${phoneController.text.trim()}";

                try {
                  await FirebaseAuth.instance.verifyPhoneNumber(
                    phoneNumber: phone,
                    timeout: const Duration(seconds: 60),
                    verificationCompleted: (PhoneAuthCredential credential) {
                      // Optional: Handle auto-verification
                    },
                    verificationFailed: (FirebaseAuthException e) {
                      log('Verification failed: ${e.message}');
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('فشل التحقق: ${e.message}')),
                      );
                    },
                    codeSent: (String verificationId, int? resendToken) {
                      Navigator.of(context).pushNamed(
                        '/otp-screen',
                        arguments: {
                          'phone': phone,
                          'verificationId': verificationId,
                          'isResetFlow' : true,
                        },
                      );
                    },
                    codeAutoRetrievalTimeout: (String verificationId) {
                      // Optional: Retry logic
                    },
                  );
                } catch (e) {
                  log("Error sending OTP: $e");
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('حدث خطأ أثناء إرسال الكود')),
                  );
                }
              },
              bgColor: CustomColors.primary,
              fgColor: Colors.white,
              text: Text('التالي'),
            ),
          ],
        ),
      ),
    );
  }
}
