import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:mal3b/api/dio_client.dart';

part 'authentication_state.dart';

class AuthenticationCubit extends Cubit<AuthenticationState> {
  AuthenticationCubit() : super(AuthenticationInitial());

  Dio dio = DioClient().dio;
  FlutterSecureStorage storage = const FlutterSecureStorage();

  void signup({
    required String name,
    required String phone,
    required String password,
  }) async {
    Dio dioAuth = Dio();

    emit(AuthenticationLoading());
    dioAuth.options.headers = {'content-type': 'application/json'};
    try {
      final response = await dioAuth.post(
        "${DioClient.baseUrl}auth/signup",
        data: {"name": name, "phone": phone, "password": password},
      );

      if (response.statusCode == 201) {
        await storage.write(
          key: "accessToken",
          value: response.data['accessToken'],
        );
        await storage.write(
          key: "refreshToken",
          value: response.data['refreshToken'],
        );
        emit(AuthenticationSignUpSuccess());
      } else {
        final msg = response.data['message'] ?? "فيه حاجة غلط حصلت يا نجم";
        emit(AuthenticationSignUpError(msg: _withYaNegm(msg)));
      }
    } on DioException catch (e) {
      if (e.response != null && e.response?.data != null) {
        final msg = e.response!.data['message'] ?? "فيه مشكلة حصلت يا نجم";
        emit(AuthenticationSignUpError(msg: _withYaNegm(msg)));
      } else {
        emit(AuthenticationSignUpError(msg: "حصلت مشكلة في الاتصال يا نجم"));
      }
    } catch (e) {
      emit(AuthenticationSignUpError(msg: "فيه حاجة غلط حصلت يا نجم"));
    }
  }

  void login({required String phone, required String password}) async {
    Dio dioAuth = DioClient().createCleanDio();

    emit(AuthenticationLoading());
    dioAuth.options.headers = {'content-type': 'application/json'};
    try {
      final response = await dioAuth.post(
        "${DioClient.baseUrl}auth/login",
        data: {"phone": phone, "password": password},
      );

      if (response.statusCode == 201) {
        await storage.write(
          key: "accessToken",
          value: response.data['accessToken'],
        );
        await storage.write(
          key: "refreshToken",
          value: response.data['refreshToken'],
        );
        emit(AuthenticationSignInSuccess(msg: "تم تسجيل الدخول يا نجم"));
      } else {
        final msg = response.data['message'] ?? "محاولتك فشلت يا نجم";
        emit(AuthenticationSignInError(msg: _withYaNegm(msg)));
      }
    } on DioException catch (e) {
      if (e.response != null && e.response?.data != null) {
        final msg = e.response!.data['message'] ?? "محاولتك فشلت يا نجم";
        emit(AuthenticationSignInError(msg: _withYaNegm(msg)));
      } else {
        emit(AuthenticationSignInError(msg: "سجل حساب الأول يا نجم"));
      }
    } catch (e) {
      emit(AuthenticationSignInError(msg: "فيه حاجة غلط حصلت يا نجم"));
    }
  }

  /// Helper to make sure error ends with 'يا نجم'
  String _withYaNegm(String msg) {
    msg = msg.trim();
    if (!msg.endsWith('يا نجم')) {
      return '$msg يا نجم';
    }
    return msg;
  }
}
