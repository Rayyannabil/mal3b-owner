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
import 'package:permission_handler/permission_handler.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;
  bool _isRequestingLocationPermission = false;
  late List<Widget> _screens;

  Future<void> requestLocationPermission() async {
    if (_isRequestingLocationPermission) return;
    _isRequestingLocationPermission = true;

    try {
      var status = await Permission.location.status;

      if (!status.isGranted) {
        status = await Permission.location.request();

        if (status.isDenied) {
          // You can show a dialog here if needed
          log('📍 Location permission denied.');
        } else if (status.isPermanentlyDenied) {
          log('📍 Location permission permanently denied. Opening settings...');
          await openAppSettings();
        }
      } else {
        log('📍 Location permission already granted.');
      }
    } catch (e) {
      log('❌ Error requesting location permission: $e');
    } finally {
      _isRequestingLocationPermission = false;
    }
  }

  @override
  void initState() {
    super.initState();

    // Request location permission on startup
    requestLocationPermission();

    // Initialize screens
    _screens = [
      AddStadium(
        onSuccess: () {
          setState(() {
            _currentIndex = 1;
          });
        },
      ),
      const MyFields(),
    ];

    // Save notification token
    BlocProvider.of<NotificationCubit>(context).saveFCM();
  }

  Widget _buildHeader() {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Align(
        alignment: Alignment.centerRight,
        child: Container(
          height: 100, // Reduced height to fit small devices better
          width: 200,
          decoration: const BoxDecoration(
            color: CustomColors.primary,
            borderRadius: BorderRadius.only(bottomLeft: Radius.circular(50)),
          ),
          child: Center(
            child: GestureDetector(
              onTap: () {
                Navigator.of(context).pushNamed('/notifications');
              },
              child: SvgPicture.asset(
                "assets/images/notification.svg",
                width: getIconWidth(context),
                height: getIconWidth(context),
                fit: BoxFit.contain,
              ),
            ),
          ),
        ),
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
          SizedBox(height: getVerticalSpace(context, 50)),
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
        unselectedItemColor: Colors.grey.withOpacity(0.5),
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.add),
            label: 'إضافة ملعب',
          ),
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
