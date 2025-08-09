import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
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
    required double amprice,
    required double pmprice,
    required List<MultipartFile> selectedMultipartImages,
    required String nightTime,
    required String startTime24,
    required String endTime24,
    required double latitude,
    required double longitude,
    required String location,
  }) async {
    final accessToken = await storage.read(key: "accessToken");
    emit(AddStadiumLoading());

    try {
      // Clone each MultipartFile to get fresh instancphomees
      final freshImages = selectedMultipartImages
          .map((file) => file.clone())
          .toList();

      Future<MultipartFile> compressAndConvert(XFile file) async {
        final result = await FlutterImageCompress.compressWithFile(
          file.path,
          minWidth: 800,
          minHeight: 600,
          quality: 70,
        );

        return MultipartFile.fromBytes(result!, filename: file.name);
      }
      // final formData = {
      //   "name": name,
      //   "description": des,
      //   "price": price,
      //   // "images": freshImages, // Use fresh instances here
      //   "from": startTime24,
      //   "to": endTime24,
      //   "longitude": longitude,
      //   "latitude": latitude,
      // };

      final formData = FormData.fromMap({
        "name": name,
        "description": des,
        "price": amprice,
        "night_price": pmprice,
        "images": freshImages,
        "night_time":nightTime,
        "from": startTime24,
        "to": endTime24,
        "longitude": longitude,
        "latitude": latitude,
        "address": location,
      });
      log(formData.toString());
      final accessToken = await storage.read(key: "accessToken");
      log(accessToken.toString());
      dio.options.headers = {"Authorization": "Bearer $accessToken"};
      // Remove manual header; Dio will auto-set multipart/form-data.
      final response = await dio.post(
        "${DioClient.baseUrl}owner/add-field",
        data: formData,
      );
      print(accessToken);
      

      log(response.toString());
      log(response.statusCode.toString());
      if (response.statusCode == 201 || response.statusCode == 200) {
        await storage.read(
          key: "accessToken",
        );
        await storage.read(
          key: "refreshToken",
        );
        
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
        log("${e.response!.data}");
        emit(AddStadiumError(msg: msg));
      } else {
        log(" ${e.message}");
        emit(AddStadiumError(msg: "حصلت مشكلة في الاتصال يا نجم"));
      }
    } catch (e, stackTrace) {
      log("$e", stackTrace: stackTrace);
      emit(AddStadiumError(msg: "فيه حاجة غلط حصلت يا نجم"));
    }
  }
}
