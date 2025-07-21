import 'package:flutter/material.dart';
import 'package:mal3b/constants/colors.dart';
import 'package:mal3b/helpers/size_helper.dart';
import 'package:flutter_svg/svg.dart' hide Svg;

class BookingScreen extends StatelessWidget {
  const BookingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Row(
            children: [
              Container(
                height: getVerticalSpace(context, 400),
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('assets/images/championship.png'),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
