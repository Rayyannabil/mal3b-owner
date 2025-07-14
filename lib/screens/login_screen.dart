import 'package:flutter/material.dart';
import 'package:mal3b/components/custom_input_component.dart';
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
          // Fixed Login text
          Padding(
            padding: const EdgeInsets.only(left: 29, top: 70, bottom: 30),
            child: Text(
              'Log in',
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
                      padding: const EdgeInsets.only(
                        left: 20.0,
                        right: 20.0,
                        top: 30,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
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
                          SizedBox(height: 20),
                          Expanded(
                            child: Align(
                              alignment: Alignment.bottomCenter,
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  ElevatedButton(
                                    onPressed: () {},
                                    style: ElevatedButton.styleFrom(
                                      fixedSize: Size(150, 45),
                                      backgroundColor: Color(0xFFEDF1D6),
                                      foregroundColor: Color(
                                        0xFF40513B,
                                      ).withOpacity(0.5),
                                    ),
                                    child: Text('Log in'),
                                  ),
                                  ElevatedButton(
                                    onPressed: () {},
                                    style: ElevatedButton.styleFrom(
                                      fixedSize: Size(150, 45),
                                      backgroundColor: Color(0xFF40513B),
                                      foregroundColor: Colors.white,
                                    ),
                                    child: Text('Sign up'),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          SizedBox(height: 40),
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
