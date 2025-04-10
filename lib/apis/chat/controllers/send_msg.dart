import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:omni_chat/constants/base_urls.dart';
import 'package:omni_chat/services/dio_client.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> sendMessage(String convoId, String msgContent) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String? accessToken = prefs.getString("access_token");

  var headers = {
    'x-jarvis-guid': '',
    'Authorization': 'Bearer $accessToken',
    'Content-Type': 'application/json',
  };

  Dio dio = DioClient(baseUrl: BaseUrls.jarvis).dio;

  try {
    Response response = await dio.post(
      "/api/v1/ai-chat/messages",
      data: {
        "content": msgContent,
        "files": [],
        "metadata": {
          "conversation": {"messages": []},
        },
        "assistant": {
          "id": "gemini-1.5-flash-latest",
          "model": "dify",
          "name": "Gemini 1.5 Flash",
        },
      },
      options: Options(headers: headers),
    );
    debugPrint(response.data.toString());
    debugPrint(response.statusCode.toString());
    switch (response.statusCode) {
      case 200:
        break;
      default:
        return;
    }
  } catch (e) {
    debugPrint("Error: $e");
  }
}
