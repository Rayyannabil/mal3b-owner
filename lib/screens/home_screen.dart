// ignore_for_file: unused_import, unused_local_variable, unused_element

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

bool _hasWelcomePopupBeenShown = false;

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

  void _showWorkingOnlyInAlexPopup() {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("تنبيه"),
        content: const Text("التطبيق يعمل حالياً داخل محافظة الإسكندرية فقط"),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text(
              "حسناً",
              style: TextStyle(color: CustomColors.primary),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    String locationText = 'الموقع'; // Example, replace with your logic

    Future<void> _determinePosition() async {
      try {
        String address = await LocationService().determinePosition();

        bool isInAlex =
            address.contains("اسكندرية") || address.contains("Alexandria");

        if (!isInAlex && _hasWelcomePopupBeenShown == false) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            _showWorkingOnlyInAlexPopup();
            _hasWelcomePopupBeenShown = true;
          });
        }

        setState(() {
          locationText = address;
        });

        final location = await LocationService().getLongAndLat();
        // ignore: use_build_context_synchronously
        context.read<StadiumCubit>().fetchStadiums();
      } catch (e) {
        log('Error determining position: $e');
        setState(() {
          locationText = 'الموقع غير معروف';
        });
      }
    }

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          BlocConsumer<NotificationCubit, NotificationState>(
            listener: (context, state) {},
            builder: (context, state) {
              final cubit = context.read<NotificationCubit>();
              print("notificationsSeen = ${cubit.notificationsSeen}");

              return Flexible(
                flex: 4,
                child: Container(
                  height: 110,
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
                        const SizedBox(width: 40),
                        GestureDetector(
                          onTap: () {
                            Navigator.of(context).pushNamed('/notifications');
                          },
                          child: ValueListenableBuilder<bool>(
                            valueListenable: seenNotification,
                            builder: (context, value, child) {
                              return SvgPicture.asset(
                                value
                                    ? "assets/images/notifications_unread.svg"
                                    : "assets/images/notification.svg",
                                width: getIconWidth(context),
                                height: getIconWidth(context),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
          SizedBox(width: getHorizontalSpace(context, 5)),
          Flexible(
            flex: 5,
            child: SizedBox(
              height: 110,
              child: Align(
                alignment: Alignment.bottomCenter,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10.0),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(50),
                      color: CustomColors.customWhite,
                    ),
                    height: getVerticalSpace(context, 40),
                    child: Center(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20.0),
                        child: Text(
                          locationText,
                          softWrap: true,
                          overflow: TextOverflow.visible,
                          style: TextStyle(
                            color: CustomColors.secondary.withOpacity(0.5),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
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
