import 'dart:developer';
import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:mal3b/api/dio_client.dart';

part 'stadium_state.dart';

class StadiumCubit extends Cubit<StadiumState> {
  StadiumCubit() : super(StadiumInitial());

  final Dio dio = DioClient().dio;
  final FlutterSecureStorage storage = FlutterSecureStorage();

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
}
