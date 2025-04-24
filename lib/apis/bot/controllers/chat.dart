import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:omni_chat/apis/bot/models/request.dart';
import 'package:omni_chat/apis/bot/models/response.dart';
import 'package:omni_chat/constants/base_urls.dart';
import 'package:omni_chat/providers/bot.dart';
import 'package:omni_chat/providers/convo.dart';
import 'package:omni_chat/router/index.dart';
import 'package:omni_chat/services/dio_client.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> chatWithBot(ChatRequest req) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String? accessToken = prefs.getString("access_token");

  var headers = {
    'Authorization': 'Bearer $accessToken',
    'Content-Type': 'application/json',
  };

  Dio dio = DioClient(baseUrl: BaseUrls.jarvis).dio;

  Map<String, Object> chatConvo = {"messages": []};

  try {
    Response response = await dio.post(
      "/api/v1/ai-chat/messages",
      data: {
        "content": req.msgContent,
        "files": [],
        "metadata": {"conversation": chatConvo},
        "assistant": {
          "model": "knowledge-base",
          "name": "votutrinh2002's Default Team Assistant",
          "id": req.botId,
        },
      },
      options: Options(headers: headers),
    );
    debugPrint(response.data.toString());
    switch (response.statusCode) {
      case 200:
        ChatResponse res = ChatResponse.fromJson(response.data);
        rootNavigatorKey.currentContext!.read<ConvoProvider>().setCurrentToken(
          res.remainingTokens,
        );
        rootNavigatorKey.currentContext!.read<BotProvider>().botAnswer(
          res.message,
        );
        break;
      default:
        return;
    }
  } catch (e) {
    debugPrint("Error: $e");
  }
}
