import 'dart:developer';
import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:mal3b/api/dio_client.dart';

part 'stadium_state.dart';

class StadiumCubit extends Cubit<StadiumState> {
  StadiumCubit() : super(StadiumInitial());

  final Dio dio = DioClient().dio;
  final FlutterSecureStorage storage = const FlutterSecureStorage();

  Future<void> fetchStadiums() async {
    log("aa");
    emit(StadiumLoading());
    try {
      log("a2");
      final token = await storage.read(key: 'accessToken');
      final response = await dio.get(
        '${DioClient.baseUrl}owner/get-stadiums',
        options: Options(headers: {"Authorization": "Bearer $token"}),
      );
      log("a3");
      log(response.statusCode.toString());
      if (response.statusCode == 200) {
        print(response.data);
        // final data = List<Map<String, String>>.from(response.data);
        // log(data.toString()); // Safe to log as String
        // emit(StadiumLoaded(data));
        final List<Map<String, dynamic>> data = List<Map<String, dynamic>>.from(
          response.data,
        );
        log(data.toString()); // convert to string before logging
        emit(StadiumLoaded(data));
      } else {
        log("a4");
        log(response.statusCode.toString());
        emit(StadiumError(msg: "حدث خطأ أثناء تحميل الملاعب"));
      }
    } catch (e) {
      log("a6");
      log(e.toString());

      emit(StadiumError(msg: "فشل في تحميل الملاعب"));
    }
  }

  Future<void> deleteStadium(String fieldId) async {
    emit(StadiumDeleteLoading());
    try {
      log(fieldId);
      final token = await storage.read(key: 'accessToken');

      final response = await dio.post(
        '${DioClient.baseUrl}owner/delete-field/',
        data: {"FieldId": fieldId},
        options: Options(headers: {"Authorization": "Bearer $token"}),
      );

      if (response.statusCode == 200) {
        final message = response.data['message'] ?? "تم حذف الملعب بنجاح";
        emit(StadiumDeleteSuccess(msg: message));
        await fetchStadiums(); // refresh list
      } else {
        final message = response.data['message'] ?? "فشل في حذف الملعب";
        print(message);
        emit(StadiumDeleteError(msg: message));
      }
    } on DioException catch (e) {
      if (e.response != null) {
        final message =
            e.response?.data['message'] ??
            "هذا الملعب محجوز حالياً ولا يمكن حذفه";
        print(message);

        emit(StadiumDeleteError(msg: message));
      } else {
        emit(StadiumDeleteError(msg: "حصلت مشكلة في الاتصال"));
      }
    } catch (e) {
      emit(StadiumDeleteError(msg: "حصلت مشكلة أثناء حذف الملعب"));
    }
  }

  void addOffer({
    required String to_day,
    required String from_day,
    required double price,
    required String stadium_id,
  }) async {
    try {
      final token = await storage.read(key: 'accessToken');

      final response = await dio.post(
        '${DioClient.baseUrl}owner/add-offer/',
        data: {
          "stadium_id": stadium_id,
          "to_day": to_day,
          "from_day": from_day,
          "price": price,
        },
        options: Options(headers: {"Authorization": "Bearer $token"}),
      );

      if (response.statusCode == 200) {
        final message = response.data['message'] ?? "تم إضافة عرض بنجاح";
        emit(OfferSuccess(msg: message));
      } else {
        final message = response.data['message'] ?? "فشل في إضافة عرض";
        emit(OfferError(msg: message));
      }
    } on DioException catch (e) {
      if (e.response != null) {
        final message =
            e.response?.data['message'] ?? "حصلت مشكلة أثناء إضافة العرض";
        emit(OfferError(msg: message));
      } else {
        emit(OfferError(msg: "حصلت مشكلة في الاتصال"));
      }
    } catch (e) {
      emit(OfferError(msg: "حصلت مشكلة أثناء إضافة العرض"));
    }
  }
}
