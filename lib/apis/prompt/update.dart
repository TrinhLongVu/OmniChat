import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:omni_chat/constants/base_urls.dart';
import 'package:omni_chat/router/index.dart';
import 'package:omni_chat/services/dio_client.dart';
import 'package:quickalert/quickalert.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> updatePrompt({
  required String id,
  required String title,
  required String content,
  String description = "",
  required VoidCallback onSuccess,
  required VoidCallback onError,
}) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String? accessToken = prefs.getString("access_token");

  var headers = {
    'x-jarvis-guid': '',
    'Authorization': 'Bearer $accessToken',
    'Content-Type': 'application/json',
  };

  Dio dio = DioClient(baseUrl: BaseUrls.jarvis).dio;

  try {
    Response response = await dio.patch(
      "/api/v1/prompts/$id",
      data: {
        "title": title,
        "content": content,
        "description": description,
        "isPublic": false,
      },
      options: Options(headers: headers),
    );
    switch (response.statusCode) {
      case 200:
        QuickAlert.show(
          context: rootNavigatorKey.currentContext!,
          type: QuickAlertType.success,
          text: "Prompt updated successfully!",
          onConfirmBtnTap:
              () => GoRouter.of(rootNavigatorKey.currentContext!).pop(),
        );
        onSuccess();
        break;
      default:
        onError();
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
