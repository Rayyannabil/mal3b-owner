import 'package:flutter/material.dart';
import 'package:mal3b/components/custom_button.dart';
import 'package:mal3b/components/custom_input_component.dart';
import 'package:mal3b/constants/colors.dart';
import 'package:mal3b/helpers/size_helper.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  bool _rememberMe = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF609966),
      appBar: AppBar(
        backgroundColor: const Color(0xFF609966),
        elevation: 0,
        actions: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Text(
                  'Skip',
                  style: TextStyle(fontSize: 20, color: Colors.white),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 3, left: 8),
                  child: Icon(Icons.arrow_forward_rounded, color: Colors.white),
                ),
              ],
            ),
          ),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Fixed Sign Up text
          Padding(
            padding: const EdgeInsets.only(left: 29, top: 70, bottom: 30),
            child: Text(
              'Sign Up',
              style: TextStyle(color: Colors.white, fontSize: 32),
            ),
          ),

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
                      padding: EdgeInsets.only(top: 40, left: 20, right: 20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: CustomInput(
                                  text: 'First Name',
                                  isObsecure: false,
                                ),
                              ),
                              SizedBox(width: 16),
                              Expanded(
                                child: CustomInput(
                                  text: 'Last Name',
                                  isObsecure: false,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: getVerticalSpace(context, 16)),
                          CustomInput(text: 'Phone Number', isObsecure: false),
                          SizedBox(height: getVerticalSpace(context, 16)),
                          CustomInput(text: 'Password', isObsecure: true),
                          SizedBox(height: getVerticalSpace(context, 16)),
                          CustomInput(
                            text: 'Confirm Password',
                            isObsecure: true,
                          ),
                          SizedBox(height: getVerticalSpace(context, 16)),
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
                          SizedBox(height: getVerticalSpace(context, 150)),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Expanded(
                                child: CustomButton(
                                  onPressed: () {},
                                  bgColor: CustomColors.customWhite,
                                  fgColor: CustomColors.secondary.withOpacity(
                                    0.5,
                                  ),
                                  text: Text(
                                    'Log in',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(width: getHorizontalSpace(context, 25)),
                              Expanded(
                                child: CustomButton(
                                  onPressed: () {},
                                  bgColor: CustomColors.secondary,
                                  fgColor: CustomColors.white,

                                  text: Text(
                                    'Sign up',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: getVerticalSpace(context, 40)),
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
