import 'dart:async';
import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:omni_chat/apis/bot/models/request.dart';
import 'package:omni_chat/constants/base_urls.dart';
import 'package:omni_chat/providers/bot.dart';
import 'package:omni_chat/router/index.dart';
import 'package:omni_chat/services/dio_client.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> askBot(AskRequest req) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String? accessToken = prefs.getString("access_token");

  var headers = {
    'Authorization': 'Bearer $accessToken',
    'Content-Type': 'application/json',
  };

  Dio dio = DioClient(baseUrl: BaseUrls.knowledge).dio;

  try {
    Response response = await dio.post(
      "/kb-core/v1/ai-assistant/${req.botId}/ask",
      data: {"message": req.msgContent},
      options: Options(headers: headers, responseType: ResponseType.stream),
    );

    switch (response.statusCode) {
      case 200:
        var stream = response.data.stream;

        StringBuffer fullContent = StringBuffer();

        await for (var byteData in stream) {
          String decoded = utf8.decode(byteData);

          List<String> lines = decoded.split('\n');
          for (var line in lines) {
            if (line.startsWith('data:')) {
              String jsonPart = line.substring(5).trim();
              if (jsonPart.isNotEmpty) {
                try {
                  var jsonData = json.decode(jsonPart);
                  if (jsonData is Map<String, dynamic> &&
                      jsonData.containsKey('content')) {
                    String content = jsonData['content'] ?? '';
                    fullContent.write(content);
                  }
                } catch (e) {
                  debugPrint("Error: $e");
                }
              }
            }
          }
        }
        rootNavigatorKey.currentContext!.read<BotProvider>().botPreviewAnswer(
          fullContent.toString(),
        );
        break;
      default:
    }
  } catch (e) {
    debugPrint("Error: $e");
  }
}
