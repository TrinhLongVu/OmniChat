import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:omni_chat/apis/bot/models/request.dart';
import 'package:omni_chat/constants/base_urls.dart';
import 'package:omni_chat/router/index.dart';
import 'package:omni_chat/services/dio_client.dart';
import 'package:quickalert/quickalert.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> publishToSlack(PublishToSlackRequest req) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String? accessToken = prefs.getString("access_token");

  var headers = {'x-jarvis-guid': '', 'Authorization': 'Bearer $accessToken'};

  Dio dio = DioClient(baseUrl: BaseUrls.knowledge).dio;

  try {
    Response verifyRes = await dio.post(
      "/kb-core/v1/bot-integration/slack/validation",
      data: {
        "botToken": req.botToken,
        "clientId": req.clientId,
        "clientSecret": req.clientSecret,
        "signingSecret": req.signingSecret,
      },
      options: Options(headers: headers),
    );
    if (verifyRes.statusCode.toString() == "200") {
      Response response = await dio.post(
        "/kb-core/v1/bot-integration/slack/publish/${req.botId}",
        data: {
          "botToken": req.botToken,
          "clientId": req.clientId,
          "clientSecret": req.clientSecret,
          "signingSecret": req.signingSecret,
        },
        options: Options(headers: headers),
      );
      switch (response.statusCode) {
        case 200:
          QuickAlert.show(
            context: rootNavigatorKey.currentContext!,
            type: QuickAlertType.success,
            text: "Bot published to Slack successfully!",
            onConfirmBtnTap:
                () => {
                  GoRouter.of(rootNavigatorKey.currentContext!).pop(),
                  GoRouter.of(rootNavigatorKey.currentContext!).pop(),
                },
          );
          break;
        default:
          QuickAlert.show(
            context: rootNavigatorKey.currentContext!,
            type: QuickAlertType.error,
            text: "Something went wrong! Please try again later.",
          );
          break;
      }
    } else {
      QuickAlert.show(
        context: rootNavigatorKey.currentContext!,
        type: QuickAlertType.error,
        text: "Information not valid! Please try again with something else.",
      );
    }
  } catch (e) {
    QuickAlert.show(
      context: rootNavigatorKey.currentContext!,
      type: QuickAlertType.error,
      text: "Something went wrong! Please try again later.",
    );
    debugPrint("Error: $e");
  }
}
