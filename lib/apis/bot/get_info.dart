import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:omni_chat/constants/base_urls.dart';
import 'package:omni_chat/models/bot_model.dart';
import 'package:omni_chat/services/dio_client.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<Bot?> getBotInfo({required String id}) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String? accessToken = prefs.getString("access_token");

  var headers = {'x-jarvis-guid': '', 'Authorization': 'Bearer $accessToken'};

  Dio dio = DioClient(baseUrl: BaseUrls.knowledge).dio;

  try {
    Response response = await dio.get(
      "/kb-core/v1/ai-assistant/$id",
      options: Options(headers: headers),
    );
    switch (response.statusCode) {
      case 200:
        Bot botListRes = Bot.fromJson(response.data);
        return botListRes;
      default:
        return null;
    }
  } catch (e) {
    debugPrint("Error: $e");
  }
  return null;
}
