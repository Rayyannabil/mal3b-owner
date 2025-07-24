import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:mal3b/components/custom_button.dart';
import 'package:mal3b/constants/colors.dart';
import 'package:mal3b/helpers/size_helper.dart';

class ProfileScreenSkip extends StatelessWidget {
  const ProfileScreenSkip({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Directionality(
            textDirection: TextDirection.ltr,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SafeArea(
                  child: Padding(
                    padding: const EdgeInsetsDirectional.only(
                      top: 20,
                      start: 20,
                      end: 20,
                    ),
                    child: GestureDetector(
                      onTap: () {
                        Navigator.of(context).pop();
                      },
                      child: Icon(
                        Icons.arrow_back_rounded,
                        color: CustomColors.primary,
                        size: 28,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: getVerticalSpace(context, 100)),
          Column(
            children: [
              SvgPicture.asset(
                'assets/images/not-found-profile.svg',
                width: getHorizontalSpace(context, 300),
              ),
              SizedBox(height: getVerticalSpace(context, 50)),
              Center(
                child: Column(
                  children: [
                    Text(
                      textAlign: TextAlign.center,
                      'إنشئ حساب أو سجل\nبالأكونت بتاعك علشان تشوف\nالبروفايل بتاعك',
                      style: TextStyle(
                        fontSize: 24,
                        color: CustomColors.primary,
                      ),
                    ),
                    SizedBox(height: getVerticalSpace(context, 50)),
                    CustomButton(
                      onPressed: () {
                        Navigator.of(context).pushNamed('/login');
                      },
                      bgColor: CustomColors.primary,
                      fgColor: Colors.white,
                      text: Text('تسجيل الدخول'),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
