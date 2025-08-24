import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart' show DateFormat;
import 'package:mal3b/constants/colors.dart';
import 'package:flutter_svg/svg.dart' hide Svg;
import 'package:mal3b/logic/cubit/notification_cubit.dart';
import 'package:mal3b/screens/my_fields.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      seenNotification.value = true;
    });
    context.read<NotificationCubit>().fetchNotifications();
    SharedPreferences.getInstance().then((value) {
      value.setBool("seenKey", seenNotification.value);
    });
  }

  void markNotificationsAsRead() async {
    final cubit = context.read<NotificationCubit>();
    await cubit.fetchNotifications(); // load notifications
    await cubit.markSeen(); // mark them viewed → home icon becomes read
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: CustomColors.white,
        centerTitle: true,
        leading: GestureDetector(
          onTap: () => Navigator.of(context).pop(),
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
          Expanded(
            child: BlocBuilder<NotificationCubit, NotificationState>(
              builder: (context, state) {
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
                      child: Text("لا توجد إشعارات حتى الآن"),
                    );
                  }

                  final now = DateTime.now();
                  final Map<String, List<Map<String, dynamic>>> grouped = {};

                  for (final n in notifications) {
                    final createdAt = DateTime.parse(
                      n['created_at'].toString(),
                    ).toLocal();

                    late String title;
                    if (createdAt.year == now.year &&
                        createdAt.month == now.month &&
                        createdAt.day == now.day) {
                      title = 'اليوم';
                    } else if (createdAt.year ==
                            now.subtract(const Duration(days: 1)).year &&
                        createdAt.month ==
                            now.subtract(const Duration(days: 1)).month &&
                        createdAt.day ==
                            now.subtract(const Duration(days: 1)).day) {
                      title = 'أمس';
                    } else {
                      final formatter = DateFormat('d MMMM yyyy', 'ar');
                      title = formatter.format(createdAt);
                    }

                    grouped.putIfAbsent(title, () => []).add(n);
                  }

                  return ListView(
                    children: grouped.entries.map((entry) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(20),
                            child: Text(
                              entry.key, // 👈 اليوم / أمس / yyyy/MM/dd
                              style: TextStyle(
                                color: CustomColors.primary,
                                fontSize: 24,
                              ),
                            ),
                          ),
                          ...entry.value.map((n) {
                            return Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 20,
                                vertical: 10,
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
                                      n['body'] ?? '',
                                      style: const TextStyle(
                                        fontSize: 16,
                                        fontFamily: "MadaniArabic",
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          }).toList(),
                        ],
                      );
                    }).toList(),
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
