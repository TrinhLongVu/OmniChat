import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:omni_chat/apis/chat/models/response.dart';
import 'package:omni_chat/constants/base_urls.dart';
import 'package:omni_chat/providers/convo.dart';
import 'package:omni_chat/router/index.dart';
import 'package:omni_chat/services/dio_client.dart';
import 'package:provider/provider.dart';
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

  Map<String, Object> chatConvo = {"messages": []};

  if (convoId.isNotEmpty) {
    chatConvo = {'id': convoId, 'messages': []};
  }

  try {
    Response response = await dio.post(
      "/api/v1/ai-chat/messages",
      data: {
        "content": msgContent,
        "files": [],
        "metadata": {"conversation": chatConvo},
        "assistant": {
          "id": "gemini-1.5-flash-latest",
          "model": "dify",
          "name": "Gemini 1.5 Flash",
        },
      },
      options: Options(headers: headers),
    );
    switch (response.statusCode) {
      case 200:
        SendMessageResponse res = SendMessageResponse.fromJson(response.data);
        rootNavigatorKey.currentContext!.read<ConvoProvider>().setCurrentToken(
          res.token,
        );
        break;
      default:
        return;
    }
  } catch (e) {
    debugPrint("Error: $e");
  }
}
