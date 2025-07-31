import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:mal3b/api/dio_client.dart';
import 'package:meta/meta.dart';
import 'dart:developer';

part 'add_stadium_state.dart';

class AddStadiumCubit extends Cubit<AddStadiumState> {
  AddStadiumCubit() : super(AddStadiumInitial());

  final Dio dio = DioClient().dio;
  final FlutterSecureStorage storage = const FlutterSecureStorage();

  String _normalizeMessage(dynamic message) {
    if (message is List) {
      return message.join(', ');
    } else if (message is String) {
      return message;
    } else {
      return "حصلت مشكلة غير متوقعة";
    }
  }

  Future<void> addStadium({
    required String name,
    required String des,
    required double price,
    required List<MultipartFile> selectedMultipartImages,
    required String startTime24,
    required String endTime24,
    required double latitude,
    required double longitude,
  }) async {
    emit(AddStadiumLoading());

    try {
      // Clone each MultipartFile to get fresh instances
      final freshImages = selectedMultipartImages.map((file) => file.clone()).toList();

      final formData = FormData.fromMap({
        "name": name,
        "description": des,
        "price": price,
        "images": freshImages, // Use fresh instances here
        "from": startTime24,
        "to": endTime24,
        "longitude": longitude,
        "latitude": latitude,
      });

      log("🟡 Submitting Stadium:\n"
          "🏟 Name: $name\n💰 Price: $price\n🕒 From: $startTime24 To: $endTime24\n📍 Location: ($latitude, $longitude)\n🖼 Images: ${freshImages.length}");

      // Remove manual header; Dio will auto-set multipart/form-data.
      final response = await dio.post(
        "${DioClient.baseUrl}owner/add-field",
        data: formData,
      );

      if (response.statusCode == 201 || response.statusCode == 200) {
        await storage.write(key: "accessToken", value: response.data['accessToken']);
        await storage.write(key: "refreshToken", value: response.data['refreshToken']);
        emit(AddStadiumSuccess(msg: "تم إضافة ملعب بنجاح"));
      } else {
        final msg = _normalizeMessage(
          response.data['message'] ?? "فيه حاجة غلط حصلت",
        );
        emit(AddStadiumError(msg: msg));
      }
    } on DioException catch (e) {
      if (e.response != null && e.response?.data != null) {
        final msg = _normalizeMessage(e.response!.data['message']);
        log("❌ Dio Error Response: ${e.response!.data}");
        emit(AddStadiumError(msg: msg));
      } else {
        log("❌ DioException with no response: ${e.message}");
        emit(AddStadiumError(msg: "حصلت مشكلة في الاتصال يا نجم"));
      }
    } catch (e, stackTrace) {
      log("❌ Unexpected Error: $e", stackTrace: stackTrace);
      emit(AddStadiumError(msg: "فيه حاجة غلط حصلت يا نجم"));
    }
  }
}
