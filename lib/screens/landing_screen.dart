import 'package:flutter/material.dart';
import 'package:mal3b/components/custom_button.dart';
import 'package:mal3b/constants/colors.dart';
import 'package:mal3b/helpers/size_helper.dart';
import 'package:mal3b/main.dart';
import 'package:mal3b/screens/login_screen.dart';
import 'package:mal3b/screens/sign_up_screen.dart';
import '../l10n/app_localizations.dart';

class LandingScreen extends StatelessWidget {
  const LandingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LayoutBuilder(
        builder: (context, constraint) => SingleChildScrollView(
          child: ConstrainedBox(
            constraints: BoxConstraints(minHeight: constraint.maxHeight),
            child: IntrinsicHeight(
              child: SafeArea(
                child: Padding(
                  padding: const EdgeInsets.all(25.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(
                        "assets/images/landingImage.png",
                        height: getImageLandingHeight(context),
                        width: getImageLandingHeight(context),
                      ),
                      SizedBox(height: getVerticalSpace(context, 18)),
                      Text(
                        AppLocalizations.of(context)!.landingTitle,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: getFontTitleSize(context),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 10),
                      Text(
                        AppLocalizations.of(context)!.landingSubtitle,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: getFontSubTitleSize(context),
                          color: Color(0xffA9A9A9),
                        ),
                      ),
                      SizedBox(height: getVerticalSpace(context, 35)),
                      SizedBox(
                        width: double.infinity,
                        child: CustomButton(
                          onPressed: () {
                            Navigator.of(context).pushNamed('/login');
                          },
                          radius: 999999,
                          bgColor: CustomColors.primary,
                          fgColor: Colors.white,
                          text: Text(
                            AppLocalizations.of(context)!.login,
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                      SizedBox(height: getVerticalSpace(context, 30)),
                      SizedBox(
                        width: double.infinity,
                        child: CustomButton(
                          elevation: 0,
                          borderSide: BorderSide(
                            width: 1,
                            color: CustomColors.primary,
                          ),
                          onPressed: () {
                            Navigator.of(context).pushNamed('/signup');
                          },
                          radius: 999999,
                          bgColor: CustomColors.white,
                          fgColor: CustomColors.primary,
                          text: Text(
                            AppLocalizations.of(context)!.signup,
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
