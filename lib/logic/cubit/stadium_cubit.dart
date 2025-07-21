import 'dart:developer';
import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:mal3b/api/dio_client.dart';

part 'stadium_state.dart';

class StadiumCubit extends Cubit<StadiumState> {
  StadiumCubit() : super(StadiumInitial());

  final Dio dio = DioClient().dio;

  Future<void> fetchAllData(double lat, double lon) async {
    emit(StadiumLoading());

    try {
      final nearestResponse = await dio.get(
        '${DioClient.baseUrl}field/get-recent',
        queryParameters: {
          'latitude': lat,
          'longitude': lon,
        },
      );

      final topRatedResponse = await dio.get(
        '${DioClient.baseUrl}field/best-rating',
      );

      final allResponse = await dio.get(
        '${DioClient.baseUrl}field',
      );

      emit(StadiumAllLoaded(
        allStadiums: allResponse.data as List<dynamic>,
        nearestStadiums: nearestResponse.data as List<dynamic>,
        topRatedStadiums: topRatedResponse.data as List<dynamic>,
      ));
    } catch (e) {
      log('Error fetching stadiums: $e');
      emit(StadiumError("فشل تحميل بيانات الملاعب يا نجم"));
    }
  }
}
