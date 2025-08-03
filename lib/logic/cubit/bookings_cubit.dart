import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:mal3b/api/dio_client.dart';

part 'bookings_state.dart';

class BookingsCubit extends Cubit<BookingsState> {
  BookingsCubit() : super(BookingsInitial());

  final Dio dio = DioClient().dio;
  final FlutterSecureStorage storage = FlutterSecureStorage();

  Future<void> fetchBookings(String id) async {
    log(id);
    emit(BookingsLoading());
    try {
      final token = await storage.read(key: 'accessToken');
      final response = await dio.post(
        '${DioClient.baseUrl}owner/get-booking',
        options: Options(headers: {"Authorization": "Bearer $token"}),
        data: {'id': id},
      );
      if (response.statusCode == 200) {
        print(response.data);
        final List<Map<String, dynamic>> data = List<Map<String, dynamic>>.from(
          response.data,
        );
        emit(BookingsLoaded(data));
      } else {
        emit(BookingsError(msg: "حدث خطأ أثناء تحميل الحجوزات"));
      }
    } catch (e) {
      log(e.toString());
      emit(BookingsError(msg: "فشل في تحميل الحجوزات"));
    }
  }
}
