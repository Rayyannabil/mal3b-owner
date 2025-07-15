import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:mal3b/api/dio_client.dart';
import 'package:meta/meta.dart';

part 'authentication_state.dart';

class AuthenticationCubit extends Cubit<AuthenticationState> {
  AuthenticationCubit() : super(AuthenticationInitial());

  Dio dio = DioClient().dio;
  FlutterSecureStorage storage = FlutterSecureStorage();

  void signup(String fullName, int phone, String password) {
    print('signed up');

  }

  void signin(int phone, String password) {
    print('signed in');
  }
}
