import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:mal3b/api/dio_client.dart';
import 'package:mal3b/constants/colors.dart';
import 'package:mal3b/components/custom_button.dart';
import 'package:mal3b/components/custom_input_component.dart';
import 'package:mal3b/services/toast_service.dart';
import 'package:form_validator/form_validator.dart';

class ResetPasswordScreen extends StatefulWidget {
  final String phone;
  final String otp;
  const ResetPasswordScreen({Key? key, required this.phone, required this.otp})
    : super(key: key);

  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  final newPasswordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    newPasswordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  void resetPassword() async {
    if (!formKey.currentState!.validate()) return;

    final dio = Dio(); // fresh Dio instance like you do in signup()

    try {
      final response = await dio.post(
        "${DioClient.baseUrl}user/reset-password",
        data: {
          "phone": widget.phone.substring(2),
          "password": newPasswordController.text.trim(),
        },
        options: Options(headers: {"content-type": "application/json"}),
      );

      if (response.statusCode == 200) {
        ToastService().showToast(
          message: 'تم تغيير كلمة المرور بنجاح',
          type: ToastType.success,
        );
        Navigator.of(context).pushNamedAndRemoveUntil('/login', (_) => false);
      } else {
        final data = response.data;
        String msg = "فشل تغيير كلمة المرور يا نجم";

        if (data is Map && data.containsKey('message')) {
          msg = data['message'] ?? msg;
        } else if (data is List && data.isNotEmpty) {
          msg = data.first.toString();
        }

        ToastService().showToast(message: msg, type: ToastType.error);
      }
    } on DioException catch (e) {
      if (e.response != null && e.response?.data != null) {
        final data = e.response!.data;
        String msg = "فشل تغيير كلمة المرور يا نجم";

        if (data is Map && data.containsKey('message')) {
          msg = data['message'] ?? msg;
        } else if (data is List && data.isNotEmpty) {
          msg = data.first.toString();
        }

        ToastService().showToast(message: msg, type: ToastType.error);
      } else {
        ToastService().showToast(
          message: "حصلت مشكلة في الاتصال يا نجم",
          type: ToastType.error,
        );
      }
    } catch (e) {
      ToastService().showToast(
        message: "فيه حاجة غلط حصلت يا نجم",
        type: ToastType.error,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CustomColors.white,
      appBar: AppBar(
        backgroundColor: CustomColors.white,
        elevation: 0,
        centerTitle: true,
        iconTheme: const IconThemeData(color: CustomColors.primary),
        title: const Text(
          'إعادة تعيين كلمة المرور',
          style: TextStyle(
            color: CustomColors.primary,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: formKey,
          child: Column(
            children: [
              CustomInput(
                isObsecure: true,
                text: 'كلمة المرور الجديدة',
                controller: newPasswordController,
                validator: ValidationBuilder(
                  requiredMessage: "اكتب كلمة المرور يا نجم",
                ).minLength(8, 'على الأقل 8 حروف يا نجم').required().build(),
              ),
              const SizedBox(height: 25),
              CustomInput(
                isObsecure: true,
                text: 'تأكيد كلمة المرور',
                controller: confirmPasswordController,
                validator: (value) {
                  if (value != newPasswordController.text) {
                    return 'كلمات المرور غير متطابقة';
                  }
                  return null;
                },
              ),
              const Spacer(),
              CustomButton(
                onPressed: resetPassword,
                bgColor: CustomColors.primary,
                fgColor: Colors.white,
                text: const Text(
                  'تأكيد',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
