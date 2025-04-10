import 'dart:async';
import 'package:dio/dio.dart';
import 'package:omni_chat/apis/auth/controllers/refresh.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DioClient {
  // Create a private constructor
  DioClient._privateConstructor();

  // Create a static instance
  static final DioClient _instance = DioClient._privateConstructor();

  // Create a public factory constructor that returns the same instance
  factory DioClient({required String baseUrl}) {
    _instance.setBaseUrl(baseUrl);
    _instance.setInterceptors();
    return _instance;
  }

  bool refreshing = false;

  final Dio dio = Dio()..options.validateStatus = (status) => status! < 500;

  void setBaseUrl(String baseUrl) {
    dio.options.baseUrl = baseUrl;
  }

  void setInterceptors() {
    dio.interceptors.add(
      InterceptorsWrapper(
        onResponse: (response, handler) async {
          if (response.statusCode == 401) {
            final originalRequest = response.requestOptions;
            await handleUnauthorizedResponse(originalRequest, handler);
          } else {
            handler.next(response);
          }
        },
        onError: (error, handler) {
          handler.next(error);
        },
      ),
    );
  }

  Future<void> handleUnauthorizedResponse(
    RequestOptions requestOptions,
    ResponseInterceptorHandler handler,
  ) async {
    try {
      await refresh();
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? accessToken = prefs.getString("access_token");
      requestOptions.headers['Authorization'] = 'Bearer $accessToken';

      handler.resolve(await dio.fetch(requestOptions));
    } catch (e) {
      handler.reject(e as DioException);
    } finally {
      refreshing = false;
    }
  }
}
