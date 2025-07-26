import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:mal3b/api/dio_client.dart';
import 'package:meta/meta.dart';

part 'notification_state.dart';

class NotificationCubit extends Cubit<NotificationState> {
  NotificationCubit() : super(NotificationInitial());

  final Dio dio = DioClient().dio;
  final FlutterSecureStorage storage = FlutterSecureStorage();

  void saveFCM() async {
    dio.options.headers = {'Content-Type': 'application/json'};
    String? token = await FirebaseMessaging.instance.getToken();
    final storage = FlutterSecureStorage();
    final accessToken = await storage.read(key: "accessToken");

    try {
      // ignore: unused_local_variable
      final response = await dio.post(
        "${DioClient.baseUrl}user/store-fcm",
        data: {"token": token},
        options: Options(headers: {"Authorization": "Bearer $accessToken"}),
      );
    } catch (e) {
      emit(NotificationError(msg: "فشل في حفظ توكن FCM"));
      throw Exception("فشل في حفظ توكن FCM: $e");
    }
  }

  Future<void> fetchNotifications() async {
    emit(NotificationLoading());
    try {
      final token = await storage.read(key: 'accessToken');
      final response = await dio.get(
        '${DioClient.baseUrl}user/notification',
        options: Options(headers: {"Authorization": "Bearer $token"}),
      );

      if (response.statusCode == 200) {
        emit(
          NotificationSuccess(List<Map<String, dynamic>>.from(response.data)),
        );
      } else {
        emit(NotificationError(msg: "حدث خطأ أثناء تحميل الإشعارات يا نجم"));
      }
    } catch (e) {
      emit(NotificationError(msg: "فشل في تحميل الإشعارات يا نجم"));
    }
  }
}
