import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:mal3b/api/dio_client.dart';
<<<<<<< HEAD
import 'package:meta/meta.dart';
=======
>>>>>>> a90dcef7ee97fd6b0fe3e763b35472f409d1d1b4

part 'authentication_state.dart';

class AuthenticationCubit extends Cubit<AuthenticationState> {
  AuthenticationCubit() : super(AuthenticationInitial());

  Dio dio = DioClient().dio;
  FlutterSecureStorage storage = FlutterSecureStorage();

<<<<<<< HEAD
  void signup(String fullName, int phone, String password) {
    print('signed up');

  }

  void signin(int phone, String password) {
    print('signed in');
=======
  void signup(
    {
      required name,
      required phone,
      required password ,
      
    }

  ) async
  {
    emit(AuthenticationLoading());
    dio.options.headers = {'content-type':'application/json'};
    try{
      final response = await dio.post("${DioClient.baseUrl}/signup",
      data: {
        "name": name,
        "phone": phone,
        "password": password,
        "address":"address"
      }

      );
      if (response.statusCode == 201) {
        final storage = FlutterSecureStorage();
        log("Access Token: ${response.data['accessToken']}");
        log("Refresh Token: ${response.data['refreshToken']}");

        storage.write(key: "accessToken", value: response.data['accessToken']);
        storage.write(
          key: "refreshToken",
          value: response.data['refreshToken'],
        );
        emit(AuthenticationSignUpSuccess());
      } else {
        emit(AuthenticationSignUpError(msg: response.data['message']));
      }
    } on DioException catch (e) {
      if (e.response != null) {
        emit(AuthenticationSignUpError(msg: e.response!.data['message']));
      } else {
        emit(AuthenticationSignUpError(msg: "حدث خطأ غير متوقع"));
      }
    } catch (e) {
      emit(AuthenticationSignUpError(msg: 'حدث خطأ غير متوقع'));
    }
    
>>>>>>> a90dcef7ee97fd6b0fe3e763b35472f409d1d1b4
  }
}
