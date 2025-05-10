import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:omni_chat/apis/chat/models/request.dart';
import 'package:omni_chat/apis/chat/models/response.dart';
import 'package:omni_chat/constants/base_urls.dart';
import 'package:omni_chat/providers/bot.dart';
import 'package:omni_chat/providers/convo.dart';
import 'package:omni_chat/router/index.dart';
import 'package:omni_chat/services/dio_client.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> sendMessage(SendMessageRequest req) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String? accessToken = prefs.getString("access_token");

  var headers = {
    'x-jarvis-guid': '',
    'Authorization': 'Bearer $accessToken',
    'Content-Type': 'application/json',
  };

  Dio dio = DioClient(baseUrl: BaseUrls.jarvis).dio;

  Map<String, Object> chatConvo = {"messages": []};

  if (req.convoId.isNotEmpty) {
    chatConvo = {'id': req.convoId, 'messages': []};
  }

  Map<String, Object> assistantObj = {
    "id":
        rootNavigatorKey.currentContext!
            .read<ConvoProvider>()
            .currentAssistant
            .id,
    "model": "dify",
    "name":
        rootNavigatorKey.currentContext!
            .read<ConvoProvider>()
            .currentAssistant
            .name,
  };

  if (!req.official) {
    assistantObj = {
      "id": rootNavigatorKey.currentContext!.read<BotProvider>().currentBot.id,
      "model": "knowledge-base",
      "name":
          rootNavigatorKey.currentContext!.read<BotProvider>().currentBot.name,
    };
  }
  debugPrint(assistantObj.toString());
  try {
    Response response = await dio.post(
      "/api/v1/ai-chat/messages",
      data: {
        "content": req.msgContent,
        "files": [],
        "metadata": {"conversation": chatConvo},
        "assistant": assistantObj,
      },
      options: Options(headers: headers),
    );
    switch (response.statusCode) {
      case 200:
        SendMessageResponse res = SendMessageResponse.fromJson(response.data);
        rootNavigatorKey.currentContext!.read<ConvoProvider>().setCurrentToken(
          res.token,
        );
        if (req.convoId.isEmpty) {
          rootNavigatorKey.currentContext!
              .read<ConvoProvider>()
              .setCurrentConvoId(res.id);
          rootNavigatorKey.currentContext!
              .read<ConvoProvider>()
              .loadConvoList();
        }
        if (req.official) {
          rootNavigatorKey.currentContext!
              .read<ConvoProvider>()
              .loadCurrentConvo();
        } else {
          rootNavigatorKey.currentContext!.read<ConvoProvider>().chatAnswer(
            res.message,
          );
        }
        break;
      default:
        req.onError();
        return;
    }
  } catch (e) {
    req.onError();
    debugPrint("Error: $e");
  }
}
