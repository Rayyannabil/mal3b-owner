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
    emit(StadiumLoading());

    try {
      final token = await storage.read(key: 'accessToken');
      final response = await dio.get(
        '${DioClient.baseUrl}owner/get-stadiums',
        options: Options(headers: {"Authorization": "Bearer $token"}),
      );
      log(response.toString());

      if (response.statusCode == 200) {
        final List<Map<String, dynamic>> data = List<Map<String, dynamic>>.from(
          response.data,
        );
        emit(StadiumLoaded(data));
      } else {
        emit(StadiumError(msg: "حدث خطأ أثناء تحميل الملاعب"));
      }
    } catch (e) {
      print(e);
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
}
