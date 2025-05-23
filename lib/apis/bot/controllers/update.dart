import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:omni_chat/apis/bot/models/request.dart';
import 'package:omni_chat/constants/base_urls.dart';
import 'package:omni_chat/providers/bot.dart';
import 'package:omni_chat/router/index.dart';
import 'package:omni_chat/services/dio_client.dart';
import 'package:provider/provider.dart';
import 'package:quickalert/quickalert.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> updateBot(UpdateBotRequest req) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String? accessToken = prefs.getString("access_token");

  var headers = {
    'x-jarvis-guid': '',
    'Authorization': 'Bearer $accessToken',
    'Content-Type': 'application/json',
  };

  Dio dio = DioClient(baseUrl: BaseUrls.knowledge).dio;

  try {
    Response response = await dio.patch(
      "/kb-core/v1/ai-assistant/${req.id}",
      data: {
        "assistantName": req.name,
        "instructions": req.instruction,
        "description": req.description,
      },
      options: Options(headers: headers),
    );
    switch (response.statusCode) {
      case 200:
        req.onComplete();
        QuickAlert.show(
          context: rootNavigatorKey.currentContext!,
          type: QuickAlertType.success,
          text: "Bot updated successfully!",
          onConfirmBtnTap:
              () => {
                rootNavigatorKey.currentContext!
                    .read<BotProvider>()
                    .reloadList(),
                GoRouter.of(rootNavigatorKey.currentContext!).pop(),
              },
        );
      default:
        req.onComplete();
        QuickAlert.show(
          context: rootNavigatorKey.currentContext!,
          type: QuickAlertType.error,
          text: "Something went wrong! Please try again later.",
        );
    }
  } catch (e) {
    debugPrint("Error: $e");
  }
}
