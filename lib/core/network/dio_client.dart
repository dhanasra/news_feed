import 'package:dio/dio.dart';
import 'package:news_app/core/config/env.dart';

class DioClient {
  static Dio createDio() {
    final dio = Dio(
      BaseOptions(
        baseUrl: Env.baseUrl,
        connectTimeout: const Duration(seconds: 10),
        receiveTimeout: const Duration(seconds: 10),
        queryParameters: {'apiKey': Env.apiKey},
      ),
    );
    dio.interceptors.add(LogInterceptor(responseBody: false));
    return dio;
  }
}