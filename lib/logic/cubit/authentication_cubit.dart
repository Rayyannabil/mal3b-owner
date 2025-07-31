import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:mal3b/api/dio_client.dart';
import 'package:mal3b/models/user_profile_model.dart';

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
        final accessToken = await storage.read(key: "accessToken");

    emit(AuthenticationLoading());
    dioAuth.options.headers = {'content-type': 'application/json',
    "Authorization": "Bearer $accessToken",};
    try {
      final response = await dioAuth.post(
        "${DioClient.baseUrl}owner/auth/signup",
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
        final msg = _normalizeMessage(
          response.data['message'] ?? "فيه حاجة غلط حصلت يا نجم",
        );
        emit(AuthenticationSignUpError(msg: (msg)));
      }
    } on DioException catch (e) {
      if (e.response != null && e.response?.data != null) {
        final msg = e.response!.data['message'] ?? "فيه مشكلة حصلت يا نجم";
        emit(AuthenticationSignUpError(msg: (msg)));
      } else {
        emit(AuthenticationSignUpError(msg: "حصلت مشكلة في الاتصال يا نجم"));
      }
    } catch (e) {
      emit(AuthenticationSignUpError(msg: "فيه حاجة غلط حصلت يا نجم"));
    }
  }

  void login({required String phone, required String password}) async {
    Dio dioAuth = DioClient().createCleanDio();
    final accessToken = await storage.read(key: "accessToken");

    emit(AuthenticationLoading());
    dioAuth.options.headers = {
      'content-type': 'application/json',
      "Authorization": "Bearer $accessToken",
    };

    try {
      final response = await dioAuth.post(
        "${DioClient.baseUrl}owner/auth/login",
        data: {"phone": phone, "password": password},
      );

      if (response.statusCode == 200) {
        // Save tokens
        await storage.write(
          key: "accessToken",
          value: response.data['accessToken'],
        );
        await storage.write(
          key: "refreshToken",
          value: response.data['refreshToken'],
        );

        // Extract and save user info if present
        final userData = response.data['user'];
        if (userData != null) {
          await storage.write(key: "userName", value: userData['name'] ?? '');
          await storage.write(key: "userPhone", value: userData['phone'] ?? '');
        }

        emit(AuthenticationSignInSuccess(msg: "تم تسجيل الدخول يا نجم"));
      } else {
        final msg = _normalizeMessage(
          response.data['message'] ?? "محاولتك فشلت يا نجم",
        );
        emit(AuthenticationSignInError(msg: (msg)));
      }
    } on DioException catch (e) {
      if (e.response != null && e.response?.data != null) {
        final msg = _normalizeMessage(
          e.response!.data['message'] ?? "محاولتك فشلت يا نجم",
        );
        emit(AuthenticationSignInError(msg: (msg)));
      } else {
        emit(AuthenticationSignInError(msg: "سجل حساب الأول يا نجم"));
      }
    } catch (e) {
      emit(AuthenticationSignInError(msg: "فيه حاجة غلط حصلت يا نجم"));
    }
  }

  Future<void> logout() async {
    try {
      final accessToken = storage.read(key: "accessToken");
      // Clear all stored user data
      await dio.post(
        "${DioClient.baseUrl}user/logout",
        options: Options(
          headers: {
            "Authorization": "Bearer $accessToken",
            "Content-Type": "application/json",
          },
        ),
      );

      await storage.deleteAll();
      _cachedUserProfile = null;

      emit(AuthenticationLoggedOut());
    } catch (e) {
      emit(AuthenticationLogoutError(msg: "فشل تسجيل الخروج يا نجم"));
    }
  }

  String _normalizeMessage(dynamic message) {
    if (message is List) {
      return message.join(', ');
    } else if (message is String) {
      return message;
    } else {
      return "حصلت مشكلة غير متوقعة";
    }
  }

  UserProfileModel? _cachedUserProfile;

  Future<UserProfileModel?> getProfileDetails({
    bool forceRefresh = false,
  }) async {
    emit(AccountDetailsLoading());

    if (!forceRefresh && _cachedUserProfile != null) {
      emit(AccountDetailsGotSuccessfully(user: _cachedUserProfile!));
      return _cachedUserProfile;
    }

    final accessToken = await storage.read(key: "accessToken");

    try {
      final response = await dio.get(
        "${DioClient.baseUrl}user/details",
        options: Options(
          headers: {
            "Authorization": "Bearer $accessToken",
            "Content-Type": "application/json",
          },
        ),
      );

      if (response.statusCode == 200) {
        final userProfile = UserProfileModel.fromJson(response.data);
        _cachedUserProfile = userProfile;
        emit(AccountDetailsGotSuccessfully(user: userProfile));
        return userProfile;
      } else {
        emit(AccountDetailsGotFailed(msg: "فشل تحميل البيانات"));
        return null;
      }
    } catch (e) {
      emit(AccountDetailsGotFailed(msg: "حدث خطأ غير متوقع"));
      return null;
    }
  }

  void updateProfile({required String name, required String phone}) async {
    emit(AccountDetailsUpdateLoading());
    try {
      final accessToken = await storage.read(key: "accessToken");

      final response = await dio.post(
        "${DioClient.baseUrl}user/edit-details",
        data: {"name": name, "phone": phone},
        options: Options(
          headers: {
            "Authorization": "Bearer $accessToken",
            "Content-Type": "application/json",
          },
        ),
      );

      if (response.statusCode == 200) {
        _cachedUserProfile = UserProfileModel(name: name, phone: phone);
        await storage.write(key: "userName", value: name);
        await storage.write(key: "userPhone", value: phone);

        emit(AccountDetailsUpdatedSuccess());
        await getProfileDetails(forceRefresh: true);
      } else {
        emit(
          AccountDetailsUpdatedFailed(
            msg: response.data['message'] ?? "فشل تحديث البيانات",
          ),
        );
      }
    } on DioException catch (e) {
      if (e.response != null) {
        emit(
          AccountDetailsUpdatedFailed(
            msg: e.response!.data['message'] ?? "فشل تحديث البيانات",
          ),
        );
      } else {
        emit(AccountDetailsUpdatedFailed(msg: "حدث خطأ غير متوقع"));
      }
    } catch (e) {
      emit(AccountDetailsUpdatedFailed(msg: "حدث خطأ غير متوقع"));
    }
  }
}
