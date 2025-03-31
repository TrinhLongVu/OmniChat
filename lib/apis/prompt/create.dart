import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:omni_chat/constants/base_urls.dart';
import 'package:omni_chat/router/index.dart';
import 'package:omni_chat/services/dio_client.dart';
import 'package:quickalert/quickalert.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> createPrompt({
  required String title,
  required String content,
  String description = "",
}) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String? accessToken = prefs.getString("access_token");

  var headers = {'x-jarvis-guid': '', 'Authorization': 'Bearer $accessToken'};

  Dio dio = DioClient(baseUrl: BaseUrls.jarvis).dio;

  try {
    Response response = await dio.post(
      "/api/v1/prompts",
      data: {
        "title": title,
        "content": content,
        "description": description,
        "isPublic": false,
      },
      options: Options(headers: headers),
    );
    switch (response.statusCode) {
      case 201:
        QuickAlert.show(
          context: rootNavigatorKey.currentContext!,
          type: QuickAlertType.success,
          text: "Prompt created successfully!",
          onConfirmBtnTap:
              () => {
                GoRouter.of(rootNavigatorKey.currentContext!).pop(),
                GoRouter.of(rootNavigatorKey.currentContext!).pop(true),
              },
        );
        break;
      default:
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
