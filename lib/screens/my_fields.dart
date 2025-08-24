// ignore_for_file: use_build_context_synchronously, unused_element

import 'dart:developer';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart' hide TextDirection;
import 'package:mal3b/components/custom_button.dart';
import 'package:mal3b/components/date_picker.dart';
import 'package:mal3b/constants/colors.dart';
import 'package:mal3b/helpers/size_helper.dart';
import 'package:mal3b/logic/cubit/authentication_cubit.dart';
import 'package:mal3b/logic/cubit/notification_cubit.dart';
import 'package:mal3b/logic/cubit/stadium_cubit.dart';
import 'package:mal3b/services/toast_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

ValueNotifier<bool> seenNotification = ValueNotifier(false);

class MyFields extends StatefulWidget {
  final VoidCallback? onSuccess;

  const MyFields({super.key, this.onSuccess});

  @override
  State<MyFields> createState() => _MyFieldsState();
}

class _MyFieldsState extends State<MyFields> {
  String? from_day;
  String? to_day;
  final TextEditingController priceController = TextEditingController();
  String? _fcmToken;

  String formatTimeArabic(String timeString) {
    final inputFormat = DateFormat("HH:mm:ss");
    final outputFormat = DateFormat.jm("en");
    final time = inputFormat.parse(timeString);
    return outputFormat.format(time);
  }

  @override
  void initState() {
    super.initState();
    context.read<StadiumCubit>().fetchStadiums();
    context.read<NotificationCubit>().saveFCM();
    SharedPreferences.getInstance().then(
      (value) => {seenNotification.value = value.getBool("seenKey") ?? false},
    );
    context.read<AuthenticationCubit>().getProfileDetails();
    context.read<NotificationCubit>().fetchNotifications();
    _getToken();
  }

  @override
  void dispose() {
    priceController.dispose();
    super.dispose();
  }

  Future<void> _getToken() async {
    FirebaseMessaging messaging = FirebaseMessaging.instance;

    // Request permission (iOS)
    NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      String? token = await messaging.getToken();
      setState(() {
        _fcmToken = token;
      });
      print("FCM Token: $_fcmToken"); // You can send this to your backend
    } else {
      print("Permission denied");
    }
  }

  Widget _buildHeader() {
    String locationText = "الموقع"; // Example, replace with your logic

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
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Text(
                'الملاعب',
                style: TextStyle(
                  fontSize: getFontTitleSize(context) * 1.5,
                  fontWeight: FontWeight.bold,
                  color: CustomColors.secondary,
                ),
              ),
            ),
            SizedBox(height: getVerticalSpace(context, 20)),
            // Add BlocListener to handle offer success/error states
            BlocListener<StadiumCubit, StadiumState>(
              listener: (context, state) {
                if (state is OfferSuccess) {
                  ToastService().showToast(
                    message: 'تمت إضافة خصم بنجاح',
                    type: ToastType.success,
                  );
                  // Re-fetch stadiums after successful offer addition
                  context.read<StadiumCubit>().fetchStadiums();
                } else if (state is OfferError) {
                  String msg = state.msg.trim();
                  ToastService().showToast(message: msg, type: ToastType.error);
                }
              },
              child: BlocBuilder<StadiumCubit, StadiumState>(
                builder: (context, state) {
                  // Handle loading states for both stadium and offer operations
                  if (state is StadiumLoading || state is OfferLoading) {
                    return const Center(
                      child: CircularProgressIndicator(
                        color: CustomColors.primary,
                      ),
                    );
                  }
                  // Handle all loaded states - keep showing stadiums even during offer operations
                  else if (state is StadiumLoaded ||
                      state is OfferSuccess ||
                      state is OfferError) {
                    // Get stadiums from the current state or maintain previous data
                    List<dynamic> stadiums = [];
                    if (state is StadiumLoaded) {
                      stadiums = state.stadiums;
                    } else {
                      // If we're in OfferSuccess or OfferError, we need to get stadiums from previous state
                      // This is a fallback - ideally your cubit should maintain stadium data
                      context.read<StadiumCubit>().fetchStadiums();
                      return const Center(
                        child: CircularProgressIndicator(
                          color: CustomColors.primary,
                        ),
                      );
                    }
                    log(stadiums.toString());

                    if (stadiums.isEmpty) {
                      return const Center(
                        child: Text(
                          "لا توجد ملاعب حتى الآن",
                          style: TextStyle(
                            fontFamily: "MadaniArabic",
                            fontSize: 15,
                            color: Colors.red,
                          ),
                        ),
                      );
                    }

                    return ListView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: stadiums.length,
                      itemBuilder: (context, index) {
                        final stadium = stadiums[index];

                        final name = stadium['name'] ?? '';
                        final id = stadium['id'] ?? '';
                        final amprice = stadium['price'] ?? '';
                        final netPrice = stadium['net_price'] ?? '';
                        final offer = stadium['offer'] ?? '';
                        final pmprice = stadium['night_price'] ?? '';
                        final from = formatTimeArabic(stadium['from_time']);
                        final to = formatTimeArabic(stadium['to_time']);

                        return GestureDetector(
                          onTap: () {
                            // Store the cubit reference before showing dialog
                            final stadiumCubit = context.read<StadiumCubit>();

                            showDialog(
                              context: context,
                              builder: (dialogContext) => AlertDialog(
                                backgroundColor: Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(40),
                                ),
                                content: SingleChildScrollView(
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Padding(
                                        padding: EdgeInsets.only(top: 20),
                                      ),
                                      Align(
                                        alignment: Alignment.centerRight,
                                        child: Text(
                                          'ضيف عرض',
                                          style: TextStyle(
                                            color: CustomColors.primary,
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        height: getVerticalSpace(context, 5),
                                      ),
                                      DatePickerRow(
                                        onDateRangeSelected: (fromday, today) {
                                          setState(() {
                                            from_day = fromday; // "2025-08-31"
                                            to_day = today; // "2025-09-02"
                                          });
                                        },
                                      ),
                                      SizedBox(
                                        height: getVerticalSpace(context, 10),
                                      ),
                                      Row(
                                        children: [
                                          Expanded(
                                            child: state is OfferLoading
                                                ? CircularProgressIndicator(
                                                    color: CustomColors.primary,
                                                  )
                                                : TextFormField(
                                                    controller: priceController,
                                                    keyboardType:
                                                        TextInputType.number,
                                                    decoration: InputDecoration(
                                                      hintText: 'الخصم',
                                                      hintStyle: TextStyle(
                                                        fontSize: 14,
                                                      ),
                                                      isDense: true,
                                                      contentPadding:
                                                          EdgeInsets.symmetric(
                                                            vertical: 8,
                                                            horizontal: 30,
                                                          ),
                                                      enabledBorder:
                                                          OutlineInputBorder(
                                                            borderRadius:
                                                                BorderRadius.circular(
                                                                  12,
                                                                ),
                                                            borderSide:
                                                                BorderSide(
                                                                  color: Colors
                                                                      .grey,
                                                                  width: 1.5,
                                                                ),
                                                          ),
                                                      focusedBorder:
                                                          OutlineInputBorder(
                                                            borderRadius:
                                                                BorderRadius.circular(
                                                                  12,
                                                                ),
                                                            borderSide: BorderSide(
                                                              color:
                                                                  CustomColors
                                                                      .primary,
                                                              width: 2,
                                                            ),
                                                          ),
                                                    ),
                                                  ),
                                          ),
                                          SizedBox(width: 15),
                                          Expanded(
                                            child: TextButton(
                                              onPressed: () {
                                                _showAddOfferConfirmation(
                                                  dialogContext,
                                                  stadiumCubit,
                                                  id,
                                                );
                                              },
                                              child: const Text(
                                                'إضافة خصم',
                                                style: TextStyle(
                                                  color: CustomColors.primary,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      Padding(
                                        padding: EdgeInsets.only(top: 15),
                                      ),
                                      Divider(
                                        indent: 10,
                                        endIndent: 10,
                                        color: Colors.grey,
                                      ),
                                      Align(
                                        alignment: Alignment.centerRight,
                                        child: Padding(
                                          padding: const EdgeInsets.all(5),
                                          child: GestureDetector(
                                            onTap: () {
                                              Navigator.of(context).pushNamed(
                                                '/bookings',
                                                arguments: id,
                                              );
                                            },
                                            child: Text(
                                              'الحجوزات',
                                              style: TextStyle(
                                                color: CustomColors.primary,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                      Divider(
                                        indent: 10,
                                        endIndent: 10,
                                        color: Colors.grey,
                                      ),
                                      Align(
                                        alignment: Alignment.centerRight,
                                        child: Padding(
                                          padding: const EdgeInsets.all(5),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              BlocListener<
                                                StadiumCubit,
                                                StadiumState
                                              >(
                                                listener: (context, state) {
                                                  if (state
                                                      is StadiumDeleteSuccess) {
                                                    ToastService().showToast(
                                                      message: state.msg,
                                                      type: ToastType.success,
                                                    );
                                                  } else if (state
                                                      is StadiumDeleteError) {
                                                    ToastService().showToast(
                                                      message: state.msg,
                                                      type: ToastType.error,
                                                    );
                                                  }
                                                },
                                                child: GestureDetector(
                                                  onTap: () async {
                                                    _showDeleteConfirmation(
                                                      dialogContext,
                                                      stadiumCubit,
                                                      stadium,
                                                    );
                                                  },
                                                  child: Row(
                                                    mainAxisSize:
                                                        MainAxisSize.min,
                                                    children: [
                                                      const Text(
                                                        'حذف ملعب',
                                                        style: TextStyle(
                                                          color: Colors.red,
                                                        ),
                                                      ),
                                                      SizedBox(
                                                        width:
                                                            getHorizontalSpace(
                                                              context,
                                                              150,
                                                            ),
                                                      ),
                                                      const Icon(
                                                        Icons.delete,
                                                        color: Colors.red,
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                actions: [
                                  CustomButton(
                                    bgColor: CustomColors.primary,
                                    fgColor: CustomColors.white,
                                    onPressed: () {
                                      Navigator.of(dialogContext).pop();
                                    },
                                    text: Text('إغلاق'),
                                  ),
                                ],
                              ),
                            );
                          },
                          child: Container(
                            margin: EdgeInsets.symmetric(
                              vertical: 8,
                              horizontal: 16,
                            ),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(30),
                              color: CustomColors.primary,
                            ),
                            child: ListTile(
                              contentPadding: EdgeInsets.all(15),
                              title: Text(
                                'ملعب $name',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(
                                    height: getVerticalSpace(context, 10),
                                  ),
                                  Text(
                                    '$amprice جنيه / الساعة صباحًا',
                                    style: TextStyle(color: Colors.white),
                                  ),
                                  Text(
                                    '$pmprice جنيه / الساعة مساء',
                                    style: TextStyle(color: Colors.white),
                                  ),
                                  SizedBox(
                                    height: getVerticalSpace(context, 10),
                                  ),
                                  Text(
                                    '${(offer == null || offer.toString().isEmpty) ? "لا يوجد خصم" : "$offer خصم"}',
                                    style: TextStyle(color: Colors.white),
                                  ),
                                  SizedBox(
                                    height: getVerticalSpace(context, 10),
                                  ),
                                  Text(
                                    'السعر بعد الخصم: $netPrice جنية / الساعة ',
                                    style: TextStyle(color: Colors.white),
                                  ),
                                  SizedBox(
                                    height: getVerticalSpace(context, 10),
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Text(
                                        'من: $from',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 12,
                                        ),
                                      ),
                                      SizedBox(
                                        width: getHorizontalSpace(context, 50),
                                      ),
                                      Text(
                                        'إلى: $to',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 12,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              textColor: Colors.white,
                            ),
                          ),
                        );
                      },
                    );
                  } else if (state is StadiumError) {
                    return Center(
                      child: Text(
                        state.msg,
                        style: TextStyle(
                          color: Colors.red,
                          fontSize: getFontTitleSize(context),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    );
                  }
                  return const SizedBox.shrink();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Helper method to show add offer confirmation dialog
  void _showAddOfferConfirmation(
    BuildContext dialogContext,
    dynamic stadiumCubit,
    String stadiumId,
  ) {
    showDialog(
      context: dialogContext,
      builder: (confirmDialogContext) {
        return AlertDialog(
          title: const Text('إضافة خصم'),
          content: const Text('هل أنت متأكد أنك تريد إضافة الخصم لهذا الملعب؟'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(confirmDialogContext).pop();
              },
              child: const Text('إلغاء', style: TextStyle(color: Colors.black)),
            ),
            TextButton(
              onPressed: () {
                if (_validateOfferInput(confirmDialogContext)) {
                  try {
                    final price = double.parse(priceController.text);

                    stadiumCubit.addOffer(
                      from_day: from_day!,
                      to_day: to_day!,
                      price: price,
                      stadium_id: stadiumId,
                    );

                    Navigator.of(confirmDialogContext).pop();
                    Navigator.of(dialogContext).pop();

                    // Clear the form
                    _clearForm();
                  } catch (e) {
                    Navigator.of(confirmDialogContext).pop();
                    ToastService().showToast(
                      message: 'الرجاء إدخال قيمة صحيحة للخصم',
                      type: ToastType.error,
                    );
                  }
                }
              },
              child: const Text('تأكيد', style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    );
  }

  // Helper method to validate offer input
  bool _validateOfferInput(BuildContext context) {
    if (priceController.text.isEmpty) {
      Navigator.of(context).pop();
      ToastService().showToast(
        message: 'الرجاء إضافة قيمة العرض',
        type: ToastType.error,
      );
      return false;
    }

    if (from_day == null) {
      Navigator.of(context).pop();
      ToastService().showToast(
        message: 'الرجاء اختيار وقت بداية العرض',
        type: ToastType.error,
      );
      return false;
    }

    if (to_day == null) {
      Navigator.of(context).pop();
      ToastService().showToast(
        message: 'الرجاء اختيار وقت نهاية العرض',
        type: ToastType.error,
      );
      return false;
    }

    return true;
  }

  // Helper method to clear form
  void _clearForm() {
    priceController.clear();
    setState(() {
      from_day = null;
      to_day = null;
    });
  }

  // Helper method to show delete confirmation dialog
  void _showDeleteConfirmation(
    BuildContext dialogContext,
    dynamic stadiumCubit,
    Map<String, dynamic> stadium,
  ) {
    showDialog<bool>(
      context: dialogContext,
      builder: (deleteDialogContext) => AlertDialog(
        title: const Text('تأكيد الحذف'),
        content: const Text('هل أنت متأكد أنك تريد حذف هذا الملعب؟'),
        actions: [
          CustomButton(
            bgColor: Colors.grey,
            fgColor: Colors.white,
            onPressed: () {
              Navigator.of(deleteDialogContext).pop();
            },
            text: const Text('إلغاء'),
          ),
          CustomButton(
            bgColor: Colors.red,
            fgColor: Colors.white,
            onPressed: () async {
              final fieldId = stadium['id']?.toString();
              if (fieldId != null && fieldId.isNotEmpty) {
                await stadiumCubit.deleteStadium(fieldId);
                Navigator.of(deleteDialogContext).pop(); // Close delete dialog
                Navigator.of(dialogContext).pop(); // Close main dialog
              } else {
                ToastService().showToast(
                  message: 'معرف الملعب غير صالح',
                  type: ToastType.error,
                );
              }
            },
            text: const Text('تأكيد'),
          ),
        ],
      ),
    );
  }
}
