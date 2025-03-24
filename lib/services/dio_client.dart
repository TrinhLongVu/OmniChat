import 'package:dio/dio.dart';

class DioClient {
  // Create a private constructor
  DioClient._privateConstructor();

  // Create a static instance
  static final DioClient _instance = DioClient._privateConstructor();

  // Create a public factory constructor that returns the same instance
  factory DioClient() {
    return _instance;
  }

  // Initialize the Dio instance
  final Dio dio =
      Dio()
        ..options.baseUrl =
            'https://flockstay-api.onrender.com' // Set base URL
        ..options.validateStatus = (status) {
          // Customize validateStatus to not throw exceptions for specific status codes
          return status! <
              500; // Accept status codes less than 500 without throwing exceptions
        };
}
