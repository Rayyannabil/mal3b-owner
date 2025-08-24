import 'dart:developer';
import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:mal3b/api/dio_client.dart';
part 'notification_state.dart';

class NotificationCubit extends Cubit<NotificationState> {
  NotificationCubit() : super(NotificationInitial());

  final Dio dio = DioClient().dio;

  /// key used for SharedPreferences persistence
  static const String seenKey = "markAsRead";

  /// local in-memory cache
  bool notificationsSeen = false;

  /// read flag from shared prefs on app startup
  Future<void> initSeen() async {
    final prefs = await SharedPreferences.getInstance();
    notificationsSeen = (prefs.getBool(seenKey) ?? true);
  }

  Future<bool> markSeen() async {
    final prefs = await SharedPreferences.getInstance();
    notificationsSeen = true;
    await prefs.setBool(seenKey, true);
    emit(NotificationSeenChanged()); // <—— Trigger rebuild
    return true;
  }

  Future<bool> markUnseen() async {
    final prefs = await SharedPreferences.getInstance();
    notificationsSeen = false;
    await prefs.setBool(seenKey, false);
    emit(NotificationSeenChanged()); // <—— Trigger rebuild
    return true;
  }

  void saveFCM() async {
    String? fcmToken = await FirebaseMessaging.instance.getToken();
    final accessToken = await SharedPreferences.getInstance().then(
      (prefs) => prefs.getString("accessToken"),
    );

    log(fcmToken.toString());

    if (accessToken == null) {
      //
    } else {
      await dio
          .post(
            "${DioClient.baseUrl}user/store-fcm",
            data: {"token": fcmToken},
            options: Options(headers: {"Authorization": "Bearer $accessToken"}),
          )
          .then((response) {
            log(response.data.toString());
          });
    }
  }

  Future<void> fetchNotifications() async {
    emit(NotificationLoading());
    try {
      final prefs = await SharedPreferences.getInstance();
      final accessToken = prefs.getString("accessToken");

      final response = await dio.get(
        '${DioClient.baseUrl}user/notification',
        options: Options(headers: {"Authorization": "Bearer $accessToken"}),
      );
      log(response.data.toString());

      if (response.statusCode == 200) {
        final data = List<Map<String, dynamic>>.from(response.data);
        emit(NotificationSuccess(data));

        for (var item in data) {
          final createdAt = DateTime.parse(item['created_at']).toLocal();
          item['created_at_date'] = createdAt;
        }

        if (data.isNotEmpty && notificationsSeen == false) {
          // mark as unread until user open the screen
          // await markUnseen();
        }
      } else {
        emit(NotificationError(msg: "حدث خطأ أثناء تحميل الإشعارات يا نجم"));
      }
    } catch (e) {
      emit(NotificationError(msg: "فشل في تحميل الإشعارات يا نجم"));
    }
  }
}
