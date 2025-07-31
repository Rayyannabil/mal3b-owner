import 'dart:async';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_svg/svg.dart' hide Svg;
import 'package:mal3b/constants/colors.dart';
import 'package:mal3b/helpers/size_helper.dart';
import 'package:mal3b/logic/cubit/notification_cubit.dart';
import 'package:mal3b/logic/cubit/stadium_cubit.dart';
import 'package:mal3b/screens/add_stadium.dart';
import 'package:mal3b/screens/my_fields.dart';
import 'package:mal3b/services/location_service.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;
  // String _locationText = 'الموقع';
  // final FlutterSecureStorage storage = const FlutterSecureStorage();

  final List<Widget> _screens = const [AddStadium(), MyFields()];

  @override
  void initState() {
    super.initState();
    // _determinePosition();
    BlocProvider.of<NotificationCubit>(context).saveFCM();
  }

  // Future<void> _determinePosition() async {
  //   try {
  //     String address = await LocationService().determinePosition();
  //     final location = await LocationService().getLongAndLat();

  //     setState(() => _locationText = address);

  //     context.read<StadiumCubit>().fetchAllData(
  //           location.latitude,
  //           location.longitude,
  //         );
  //   } catch (e) {
  //     log('Error determining position: $e');
  //     setState(() {
  //       _locationText = 'الموقع غير معروف';
  //     });
  //   }
  // }

  Widget _buildHeader() {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Align(
            alignment: Alignment.topRight,
            child: Container(
              height: 110,
              width: getProfileImageWidth(context) * 1.35,
              decoration: const BoxDecoration(
                color: CustomColors.primary,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(50),
                ),
              ),
              child: SafeArea(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.of(context).pushNamed('/notifications');
                      },
                      child: SvgPicture.asset(
                        "assets/images/notification.svg",
                        width: getProfileImageWidth(context),
                        height: getIconWidth(context) * 1.2,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          SizedBox(width: getHorizontalSpace(context, 10)),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          _buildHeader(),
          SizedBox(height: getVerticalSpace(context, 60)),
          Expanded(
            child: IndexedStack(index: _currentIndex, children: _screens),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: const Color.fromARGB(255, 239, 239, 239),
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
        selectedItemColor: CustomColors.primary,
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.add), label: 'إضافة ملعب'),
          BottomNavigationBarItem(
            icon: Icon(Icons.stadium),
            label: 'الملاعب',
            backgroundColor: CustomColors.primary,
          ),
        ],
      ),
    );
  }
}
