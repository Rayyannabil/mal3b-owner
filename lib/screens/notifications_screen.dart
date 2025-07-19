import 'package:flutter/material.dart';
import 'package:mal3b/constants/colors.dart';
import 'package:mal3b/helpers/size_helper.dart';
import 'package:flutter_svg/svg.dart' hide Svg;

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        // whole page
        children: [
          // appbar
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.only(top: 20, left: 10, right: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Center(
                    child: Text(
                      'الإشعارات',
                      style: TextStyle(
                        color: CustomColors.primary,
                        fontSize: 22,
                      ),
                    ),
                  ),
                  Icon(
                    Icons.arrow_back_rounded,
                    color: CustomColors.primary,
                    size: 30,
                    textDirection: TextDirection.rtl,
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: getVerticalSpace(context, 46.5)),
          // today
          Padding(
            padding: const EdgeInsets.all(20),
            child: Text(
              'اليوم',
              style: TextStyle(color: CustomColors.primary, fontSize: 24),
            ),
          ),
          // notification 1
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text('لديك خصم 50% على أي حجز'),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: SvgPicture.asset(
                  "assets/images/notifications_bell.svg",
                  width: 40,
                  height: 40,
                ),
              ),
            ],
          ),
          // divider
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: Divider(
              height: 5,
              thickness: 1,
              indent: 105,
              endIndent: 105,
              color: Colors.grey,
            ),
          ),
          // notification 2
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text('لديك خصم 50% على أي حجز'),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: SvgPicture.asset(
                  "assets/images/notifications_bell.svg",
                  width: 40,
                  height: 40,
                ),
              ),
            ],
          ),

          // yesterday
          Padding(
            padding: const EdgeInsets.all(20),
            child: Text(
              'أمس',
              style: TextStyle(color: CustomColors.primary, fontSize: 24),
            ),
          ),
          // notification 1
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text(
                'لديك خصم 30% على أي حجز',
                style: TextStyle(color: Colors.grey),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: SvgPicture.asset(
                  "assets/images/notifications_bell.svg",
                  width: 40,
                  height: 40,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
