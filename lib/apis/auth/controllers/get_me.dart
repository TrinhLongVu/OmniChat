import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:omni_chat/apis/auth/models/response.dart';
import 'package:omni_chat/constants/base_urls.dart';
import 'package:omni_chat/services/dio_client.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<GetMeResponse?> getMe() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String? accessToken = prefs.getString("access_token");

  var headers = {'x-jarvis-guid': '', 'Authorization': 'Bearer $accessToken'};

  Dio dio = DioClient(baseUrl: BaseUrls.jarvis).dio;

  try {
    Response response = await dio.get(
      "/api/v1/auth/me",
      options: Options(headers: headers),
    );
    switch (response.statusCode) {
      case 200:
        final data = response.data as Map<String, dynamic>;
        GetMeResponse meObj = GetMeResponse.fromJson(data);
        return meObj;
      default:
        return null;
    }
  } catch (e) {
    debugPrint("Error: $e");
  }
  return null;
}
