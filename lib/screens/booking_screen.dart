import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:mal3b/components/custom_button.dart';
import 'package:mal3b/constants/colors.dart';
import 'package:mal3b/helpers/size_helper.dart';

class BookingScreen extends StatelessWidget {
  const BookingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Image.asset(
            "assets/images/championship.png",
            width: double.infinity,
            fit: BoxFit.cover,
            height: getImageHeight(context) * 1.25,
          ),
          Directionality(
            textDirection: TextDirection.ltr,
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      icon: const Icon(
                        Icons.arrow_back_rounded,
                        color: Colors.white,
                        size: 28,
                      ),
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                    Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 5),
                          child: const Text(
                            '4.5',
                            style: TextStyle(color: Colors.white, fontSize: 18),
                          ),
                        ),
                        SizedBox(width: getHorizontalSpace(context, 10)),
                        Image.asset('assets/images/star.png'),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(40),
                  topRight: Radius.circular(40),
                ),
              ),
              width: double.infinity,
              height:
                  MediaQuery.of(context).size.height -
                  (getImageHeight(context) * 1.10),
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 25,
                        vertical: 10,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'القاهرة',
                            style: TextStyle(
                              color: CustomColors.primary,
                              fontSize: 32,
                            ),
                          ),
                          Text(
                            '300 جنيه / الساعة',
                            style: TextStyle(
                              color: CustomColors.primary,
                              fontSize: 15,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(10),
                      child: Text(
                        'Lörem ipsum romkom dobenypp senat, fast misk, men din utom väv toskap i heterov, disa. Suns spell det vill säga sojöde bes förutom pofåtonde i resk fast otrer ude bende. Astrotik sada, i renat i nyra fyrade hypergen eubel, bioserade tresat. Benade transitflykting guldsot gigaplare.',
                        style: const TextStyle(fontSize: 16),
                      ),
                    ),
                    const Spacer(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SvgPicture.asset(
                          "assets/images/calendar.svg",
                          width: 50,
                          height: 50,
                        ),
                        SizedBox(width: getHorizontalSpace(context, 60)),
                        SvgPicture.asset(
                          "assets/images/reserve.svg",
                          width: 50,
                          height: 50,
                        ),
                      ],
                    ),
                    const Spacer(),
                    CustomButton(
                      onPressed: () {},
                      bgColor: CustomColors.primary,
                      fgColor: Colors.white,
                      text: const Text('Next'),
                    ),
                    SizedBox(height: getVerticalSpace(context, 25)),
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
