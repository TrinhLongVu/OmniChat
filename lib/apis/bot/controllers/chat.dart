import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:omni_chat/apis/bot/models/request.dart';
import 'package:omni_chat/apis/bot/models/response.dart';
import 'package:omni_chat/constants/base_urls.dart';
import 'package:omni_chat/models/conversation/convo_history_item.dart';
import 'package:omni_chat/providers/bot.dart';
import 'package:omni_chat/providers/convo.dart';
import 'package:omni_chat/router/index.dart';
import 'package:omni_chat/services/dio_client.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

List<Map<String, dynamic>> mapToChatFormat(
  List<ConvoHistoryItem> historyItems,
  String botId,
) {
  var assistantMeta = {
    "model": "knowledge-base",
    "name":
        rootNavigatorKey.currentContext!.read<BotProvider>().currentBot.name,
    "id": botId,
  };

  final chatList = <Map<String, dynamic>>[];

  for (final item in historyItems) {
    chatList.add({
      "role": "user",
      "content": item.query,
      "files": [],
      "assistant": assistantMeta,
    });

    if (item.answer != null) {
      chatList.add({
        "role": "model",
        "content": item.answer,
        "assistant": assistantMeta,
      });
    }
  }

  return chatList;
}

Future<void> chatWithBot(ChatRequest req) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String? accessToken = prefs.getString("access_token");

  var headers = {
    'Authorization': 'Bearer $accessToken',
    'Content-Type': 'application/json',
  };

  Dio dio = DioClient(baseUrl: BaseUrls.jarvis).dio;

  Map<String, Object> botObject = {
    "model": "knowledge-base",
    "name": "votutrinh2002's Default Team Assistant",
    "id": req.botId,
  };

  List<Map<String, dynamic>> chatConvo = mapToChatFormat(
    rootNavigatorKey.currentContext!
        .read<BotProvider>()
        .currentBotConvoHistoryList,
    req.botId,
  );

  try {
    Response response = await dio.post(
      "/api/v1/ai-chat/messages",
      data: {
        "content": req.msgContent,
        "files": [],
        "metadata": {
          "conversation": {"messages": chatConvo},
        },
        "assistant": botObject,
      },
      options: Options(headers: headers),
    );
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
