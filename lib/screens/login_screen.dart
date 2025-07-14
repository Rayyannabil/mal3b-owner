import 'package:flutter/material.dart';
import 'package:mal3b/components/custom_button.dart';
import 'package:mal3b/components/custom_input_component.dart';
import 'package:mal3b/constants/colors.dart';
import 'package:mal3b/helpers/size_helper.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _rememberMe = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CustomColors.primary,
      appBar: AppBar(
        backgroundColor: CustomColors.primary,
        elevation: 0,
        actions: [
          SizedBox(height: getVerticalSpace(context, 16)),
          Row(
            children: [
              Text('Skip', style: TextStyle(fontSize: 20, color: Colors.white)),
              SizedBox(width: getHorizontalSpace(context, 12)),
              Icon(Icons.arrow_forward_rounded, color: Colors.white),
              SizedBox(width: getHorizontalSpace(context, 20)),
            ],
          ),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Fixed Login text
          SizedBox(height: getVerticalSpace(context, 70)),
          Padding(
            padding: EdgeInsetsGeometry.only(
              left: getHorizontalSpace(context, 30),
            ),
            child: Text(
              'Log in',
              style: TextStyle(color: CustomColors.white, fontSize: 32),
            ),
          ),

          SizedBox(height: getVerticalSpace(context, 30)),

          // Scrollable content
          Expanded(
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.vertical(top: Radius.circular(50)),
                color: Colors.white,
              ),
              child: CustomScrollView(
                slivers: [
                  SliverFillRemaining(
                    hasScrollBody: false,

                    child: Padding(
                      padding: const EdgeInsets.only(
                        left: 20.0,
                        right: 20.0,
                        top: 30,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Center(
                            child: Image.asset(
                              'assets/images/football.png',
                              width: getHorizontalSpace(context, 250),
                              height: getVerticalSpace(context, 250),
                            ),
                          ),
                          SizedBox(height: getVerticalSpace(context, 15)),
                          CustomInput(text: 'Phone Number', isObsecure: false),
                          SizedBox(height: getVerticalSpace(context, 50)),
                          CustomInput(text: 'Password', isObsecure: true),
                          SizedBox(height: getVerticalSpace(context, 20)),

                          Row(
                            children: [
                              Checkbox(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                value: _rememberMe,
                                onChanged: (value) {
                                  setState(() {
                                    _rememberMe = value ?? false;
                                  });
                                },
                                checkColor: Color(0xFF609966),
                                fillColor: MaterialStateProperty.resolveWith((
                                  states,
                                ) {
                                  return Color(0xFFE3F2C1);
                                }),
                              ),
                              Text('Remember me'),
                            ],
                          ),
                          SizedBox(height: getVerticalSpace(context, 20)),
                          Expanded(
                            child: Align(
                              alignment: Alignment.bottomCenter,
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    child: CustomButton(
                                      onPressed: () {},
                                      bgColor: CustomColors.customWhite,
                                      fgColor: CustomColors.secondary
                                          .withOpacity(0.5),
                                      text: Text('Log in'),
                                    ),
                                  ),
                                  SizedBox(
                                    width: getHorizontalSpace(context, 25),
                                  ),
                                  Expanded(
                                    child: CustomButton(
                                      onPressed: () {},
                                      bgColor: CustomColors.secondary,
                                      fgColor: CustomColors.white,

                                      text: Text('Sign up'),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          SizedBox(height: getVerticalSpace(context, 50)),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
