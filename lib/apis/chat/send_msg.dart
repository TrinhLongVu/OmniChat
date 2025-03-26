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

  debugPrint(accessToken);

  Dio dio = DioClient(baseUrl: BaseUrls.jarvis).dio;

  try {
    Response response = await dio.post(
      "/api/v1/ai-chat/messages",
      data: {
        "content": msgContent,
        "files": [],
        "metadata": {
          "conversation": {
            "id": convoId,
            "messages": [
              {
                "role": "model",
                "content": "Hi again! What's on your mind?",
                "files": [],
                "assistant": {
                  "id": "gpt-4o-mini",
                  "model": "dify",
                  "name": "GPT-4o Mini",
                },
              },
            ],
          },
        },
        "assistant": {
          "id": "gpt-4o-mini",
          "model": "dify",
          "name": "GPT-4o Mini",
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
