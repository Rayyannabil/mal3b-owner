import 'package:flutter/material.dart';
import 'package:mal3b/components/custom_input_component.dart';

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
              child: SingleChildScrollView(
                padding: const EdgeInsets.only(top: 40, left: 20, right: 20),
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
                    SizedBox(height: 16),
                    CustomInput(text: 'Phone Number', isObsecure: false),
                    SizedBox(height: 16),
                    CustomInput(text: 'Password', isObsecure: true),
                    SizedBox(height: 16),
                    CustomInput(text: 'Confirm Password', isObsecure: true),
                    SizedBox(height: 16),
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
                    SizedBox(height: 32),
                    Padding(
                      padding: const EdgeInsets.only(top: 50),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
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
                    SizedBox(height: 40),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
