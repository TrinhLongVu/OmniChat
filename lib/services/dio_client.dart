import 'package:dio/dio.dart';

class DioClient {
  // Create a private constructor
  DioClient._privateConstructor();

  // Create a static instance
  static final DioClient _instance = DioClient._privateConstructor();

  // Create a public factory constructor that returns the same instance
  factory DioClient({required String baseUrl}) {
    _instance.setBaseUrl(baseUrl);
    return _instance;
  }

  final Dio dio =
      Dio()
        ..options.validateStatus = (status) {
          return status! <
              500; // Accept status codes less than 500 without throwing exceptions
        };

  void setBaseUrl(String baseUrl) {
    dio.options.baseUrl = baseUrl;
  }
}
