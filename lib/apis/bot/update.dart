import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:omni_chat/constants/base_urls.dart';
import 'package:omni_chat/router/index.dart';
import 'package:omni_chat/services/dio_client.dart';
import 'package:quickalert/quickalert.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<bool> updateBot({
  required String id,
  required String name,
  required String instruction,
  required String description,
}) async {
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
      "/kb-core/v1/ai-assistant/$id",
      data: {
        "assistantName": name,
        "instructions": instruction,
        "description": description,
      },
      options: Options(headers: headers),
    );
    switch (response.statusCode) {
      case 200:
        QuickAlert.show(
          context: rootNavigatorKey.currentContext!,
          type: QuickAlertType.success,
          text: "Bot updated successfully!",
          onConfirmBtnTap:
              () => {GoRouter.of(rootNavigatorKey.currentContext!).pop()},
        );
        return true;
      default:
        QuickAlert.show(
          context: rootNavigatorKey.currentContext!,
          type: QuickAlertType.error,
          text: "Something went wrong! Please try again later.",
        );
        return false;
    }
  } catch (e) {
    debugPrint("Error: $e");
  }
  return false;
}
