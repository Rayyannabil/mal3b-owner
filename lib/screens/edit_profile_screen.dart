import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:form_validator/form_validator.dart';
import 'package:mal3b/logic/cubit/authentication_cubit.dart';
import 'package:mal3b/components/custom_button.dart';
import 'package:mal3b/components/custom_input_component.dart';
import 'package:mal3b/constants/colors.dart';
import 'package:mal3b/helpers/size_helper.dart';
import 'package:mal3b/services/toast_service.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key, required this.name, required this.phone});
  final String name, phone;

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  late TextEditingController nameController;
  late TextEditingController phoneController;
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  @override
  void initState() {
    phoneController = TextEditingController(text: widget.phone);
    nameController = TextEditingController(text: widget.name);
    super.initState();
  }

  @override
  void dispose() {
    nameController.dispose();
    phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: BlocConsumer<AuthenticationCubit, AuthenticationState>(
        listener: (context, state) {
          if (state is AccountDetailsUpdatedSuccess) {
            ToastService().showToast(
              message: "تم تحديث البيانات بنجاح",
              type: ToastType.success,
            );
            Navigator.pop(context); // رجوع للشاشة السابقة
          } else if (state is AccountDetailsUpdatedFailed) {
            ToastService().showToast(message: state.msg, type: ToastType.error);
          }
        },
        builder: (context, state) {
          return Column(
            children: [
              SafeArea(
                child: Padding(
                  padding: const EdgeInsetsDirectional.only(
                    top: 30,
                    start: 20,
                    end: 20,
                  ),
                  child: GestureDetector(
                    onTap: () {
                      Navigator.of(context).pop();
                    },
                    child: Align(
                      alignment: Alignment.centerRight,
                      child: Icon(
                        Icons.arrow_back_rounded,
                        color: CustomColors.primary,
                        size: 28,
                      ),
                    ),
                  ),
                ),
              ),
              SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(15),
                  child: Form(
                    key: formKey,
                    child: Column(
                      children: [
                        const Text(
                          "تعديل البيانات الشخصية",
                          style: TextStyle(
                            fontFamily: 'MadaniArabic',
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: getVerticalSpace(context, 30)),
                        CustomInput(
                          isObsecure: false,
                          text: "الإسم الكامل",
                          controller: nameController,
                          validator: ValidationBuilder()
                              .required("يرجى إدخال الاسم")
                              .build(),
                          keyboardType: TextInputType.name,
                        ),
                        SizedBox(height: getVerticalSpace(context, 15)),
                        CustomInput(
                          isObsecure: false,
                          text: "رقم الهاتف",
                          controller: phoneController,
                          keyboardType: TextInputType.phone,
                          validator: ValidationBuilder()
                              .required("يرجى إدخال رقم الهاتف")
                              .minLength(10, "رقم الهاتف غير صحيح")
                              .build(),
                        ),
                        SizedBox(height: getVerticalSpace(context, 100)),
                        state is AccountDetailsUpdateLoading
                            ? const CircularProgressIndicator(
                                color: CustomColors.primary,
                              )
                            : CustomButton(
                                fgColor: Colors.white,
                                bgColor: CustomColors.primary,
                                text: Text("حفظ التعديلات"),
                                onPressed: () {
                                  if (formKey.currentState!.validate()) {
                                    BlocProvider.of<AuthenticationCubit>(
                                      context,
                                    ).updateProfile(
                                      name: nameController.text.trim(),
                                      phone: phoneController.text.trim(),
                                    );
                                  }
                                },
                              ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
