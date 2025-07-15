import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class DioClient {
  static final DioClient _instance = DioClient._internal();
  factory DioClient() => _instance;

  static const String baseUrl = "http://192.168.1.6:8080/"; 

  late Dio dio;
  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  DioClient._internal() {
    dio = Dio(BaseOptions(
      baseUrl: baseUrl,
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 10),
      headers: {
        'Accept': 'application/json',
      },
    ));

    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          final accessToken = await _storage.read(key: 'accessToken');
          if (accessToken != null) {
            options.headers['Authorization'] = 'Bearer $accessToken';
          }
          return handler.next(options);
        },

        onError: (DioException error, handler) async {
          if (error.response?.statusCode == 401) {
            final refreshToken = await _storage.read(key: 'refreshToken');
            if (refreshToken != null) {
              try {
                final response = await dio.post(
                  '$baseUrl/refresh', 
                  data: {'refreshToken': refreshToken},
                );

                final newAccessToken = response.data['accessToken'];
                final newRefreshToken = response.data['refreshToken'];

                if (newAccessToken != null && newRefreshToken != null) {
                  await _storage.write(key: 'accessToken', value: newAccessToken);
                  await _storage.write(key: 'refreshToken', value: newRefreshToken);
                } else {
                  await _storage.deleteAll();
                }

              } catch (e) {
                await _storage.deleteAll(); 
              }
            }
          }

          return handler.next(error); 
        },
      ),
    );
  }
}
