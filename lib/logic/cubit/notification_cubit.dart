import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:mal3b/api/dio_client.dart';
import 'package:meta/meta.dart';

part 'notification_state.dart';

class NotificationCubit extends Cubit<NotificationState> {
  NotificationCubit() : super(NotificationInitial());

  final Dio dio = DioClient().dio;
  final FlutterSecureStorage storage = FlutterSecureStorage();

  Future<void> fetchNotifications() async{
    emit(NotificationLoading());
    try{
      final response = await dio.get(
        '${DioClient.baseUrl}notifications',
        // options: Options(
        //   headers: {"Authorization":"Bearer $token"}
          
        // )
        );
        if(response.statusCode == 200){
          emit(NotificationSuccess(response.data));
        }
        else {
        emit(NotificationError(msg: "حدث خطأأثناء تحميل الإشعارات يا نجم"));
      }
    }
    catch(e){
      emit(NotificationError(msg: "فشل في تحميل الإشعارات يا نجم"));
    }
  }
}

