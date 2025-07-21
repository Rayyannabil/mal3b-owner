import 'package:flutter/material.dart';
import 'package:mal3b/constants/colors.dart';
import 'package:flutter_svg/svg.dart' hide Svg;

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        centerTitle: true,
        leading: GestureDetector(
          onTap: () {
            Navigator.of(context).pop();
          },
          child: Icon(
            Icons.arrow_back_rounded,
            color: CustomColors.primary,
            size: 30,
            textDirection: TextDirection.rtl,
          ),
        ),
        title: Text(
          'الإشعارات',
          style: TextStyle(color: CustomColors.primary, fontSize: 22),
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        // whole page
        children: [
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
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: SvgPicture.asset(
                  "assets/images/notifications_bell.svg",
                  width: 40,
                  height: 40,
                ),
              ),
              Text('لديك خصم 50% على أي حجز'),
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
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: SvgPicture.asset(
                  "assets/images/notifications_bell.svg",
                  width: 40,
                  height: 40,
                ),
              ),
              Text('لديك خصم 50% على أي حجز'),
            ],
          ),
          // yesterday
          Padding(
            padding: const EdgeInsets.all(20),
            child: Text(
              'الأمس',
              style: TextStyle(color: CustomColors.primary, fontSize: 24),
            ),
          ),
          // notification 1
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: SvgPicture.asset(
                  "assets/images/notifications_bell.svg",
                  width: 40,
                  height: 40,
                ),
              ),
              Text(
                'لديك خصم 30% على أي حجز',
                style: TextStyle(color: Colors.grey),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
