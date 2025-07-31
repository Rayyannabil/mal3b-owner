import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'dart:developer';

class DioClient {
  static final DioClient _instance = DioClient._internal();
  factory DioClient() => _instance;

  static const String baseUrl = "http://192.168.1.9:8080/";

  late Dio dio;
  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  DioClient._internal() {
    final baseOptions = BaseOptions(
      baseUrl: baseUrl,
      connectTimeout: const Duration(seconds: 20),
      receiveTimeout: const Duration(seconds: 20),
      sendTimeout: const Duration(seconds: 20),
      headers: {
        'Accept': 'application/json',
        // 'Content-Type': 'application/json',
      },
    );

    dio = Dio(baseOptions);

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
            final accessToken = await _storage.read(key: 'accessToken');

            if (refreshToken != null && accessToken != null) {
              try {
                final refreshDio = Dio(
                  BaseOptions(
                    baseUrl: baseUrl,
                    connectTimeout: const Duration(seconds: 20),
                    receiveTimeout: const Duration(seconds: 20),
                    sendTimeout: const Duration(seconds: 20),
                    headers: {
                      'Accept': 'application/json',
                      // 'Content-Type': 'application/json',
                    },
                  ),
                )..interceptors.clear();

                final response = await refreshDio.post(
                  '/auth/refresh-token',
                  data: {'token': refreshToken},
                );
                
                log(response.toString());
                
                if (response.statusCode == 200 &&
                    response.data['accessToken'] != null &&
                    response.data['refreshToken'] != null) {
                  final newAccessToken = response.data['accessToken'];
                  final newRefreshToken = response.data['refreshToken'];

                  await _storage.write(
                    key: 'accessToken',
                    value: newAccessToken,
                  );
                  await _storage.write(
                    key: 'refreshToken',
                    value: newRefreshToken,
                  );

                  // Retry original request with updated token
                  final options = error.requestOptions;
                  options.headers['Authorization'] = 'Bearer $newAccessToken';

                  final retryResponse = await dio.fetch(options);
                  return handler.resolve(retryResponse);
                } else {
                  await _storage.deleteAll();
                  log("Invalid refresh response");
                }
              } catch (e, s) {
                await _storage.deleteAll();
                log("Token refresh failed: $e");
                log("🔍 StackTrace: $s");
              }
            }
          }

          return handler.next(error);
        },
      ),
    );
  }

  Dio createCleanDio() {
    return Dio(
      BaseOptions(
        baseUrl: baseUrl,
        connectTimeout: const Duration(seconds: 10),
        receiveTimeout: const Duration(seconds: 15),
        sendTimeout: const Duration(seconds: 10),
        headers: {
          'Accept': 'application/json',
          'Content-Type': 'application/json',
        },
      ),
    );
  }
}
