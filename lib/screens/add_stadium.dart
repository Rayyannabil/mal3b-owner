import 'package:flutter/material.dart';
import 'package:form_validator/form_validator.dart';
import 'package:mal3b/components/custom_input_component.dart';
import 'package:mal3b/helpers/size_helper.dart';

class AddStadium extends StatefulWidget {
  const AddStadium({super.key});

  @override
  State<AddStadium> createState() => _AddStadiumState();
}

class _AddStadiumState extends State<AddStadium> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController desController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Center(
          child: Text(
            'ضيف ملعب',
            style: TextStyle(fontSize: getFontTitleSize(context) * 1.2),
          ),
        ),
        SizedBox(height: getVerticalSpace(context, 30)),
        Form(
          key: _formKey,
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: CustomInput(
                  text: 'اسم الملعب',
                  controller: nameController,
                  isObsecure: false,
                  validator: ValidationBuilder(
                    requiredMessage: "دخل اسم الملعب",
                  ).required().build(),
                ),
              ),
                      SizedBox(height: getVerticalSpace(context, 15)),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: CustomInput(
                  text: 'وصف أو كلام عن الملعب',
                  controller: desController,
                  maxLines: 3,
                  keyboardType: TextInputType.multiline,
                  isObsecure: false,
                  validator: ValidationBuilder(
                    requiredMessage: "دخل اسم الملعب",
                  ).required().build(),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
