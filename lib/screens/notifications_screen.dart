import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mal3b/constants/colors.dart';
import 'package:flutter_svg/svg.dart' hide Svg;
import 'package:mal3b/logic/cubit/notification_cubit.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  @override
  void initState() {
    super.initState();
    context.read<NotificationCubit>().fetchNotifications();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: CustomColors.white,
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
        children: [
          Padding(
            padding: const EdgeInsets.all(20),
            child: Text(
              'اليوم',
              style: TextStyle(color: CustomColors.primary, fontSize: 24),
            ),
          ),

          // notifications
          Expanded(
            child: BlocBuilder<NotificationCubit, NotificationState>(
              builder: (context, state) {
                log(state.toString());
                if (state is NotificationLoading) {
                  return const Center(
                    child: CircularProgressIndicator(
                      color: CustomColors.primary,
                    ),
                  );
                } else if (state is NotificationSuccess) {
                  final notifications = state.notifications;

                  if (notifications.isEmpty) {
                    return const Center(
                      child: Text(
                        "لا توجد إشعارات حتى الآن",
                        style: TextStyle(
                          fontFamily: "MadaniArabic",
                          fontSize: 15,
                          color: Colors.red,
                        ),
                      ),
                    );
                  }

                  return ListView.builder(
                    itemCount: notifications.length,
                    itemBuilder: (context, index) {
                      final notification = notifications[index];
                      final body = notification['body'] ?? '';
                      // final title = notification['title']; // Optional

                      return Padding(
                        padding: const EdgeInsets.symmetric(
                          vertical: 10,
                          horizontal: 20,
                        ),
                        child: Row(
                          children: [
                            SvgPicture.asset(
                              "assets/images/notifications_bell.svg",
                              width: 40,
                              height: 40,
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                body,
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontFamily: "MadaniArabic",
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  );
                } else if (state is NotificationError) {
                  return Center(child: Text(state.msg));
                }

                return const SizedBox();
              },
            ),
          ),
        ],
      ),
    );
  }
}
