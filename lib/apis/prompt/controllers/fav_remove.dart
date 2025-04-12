import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:omni_chat/apis/prompt/models/request.dart';
import 'package:omni_chat/constants/base_urls.dart';
import 'package:omni_chat/providers/prompt.dart';
import 'package:omni_chat/router/index.dart';
import 'package:omni_chat/services/dio_client.dart';
import 'package:provider/provider.dart';
import 'package:quickalert/quickalert.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> removeFromFavorite(ToggleFavoriteRequest req) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String? accessToken = prefs.getString("access_token");

  var headers = {'x-jarvis-guid': '', 'Authorization': 'Bearer $accessToken'};

  Dio dio = DioClient(baseUrl: BaseUrls.jarvis).dio;

  try {
    Response response = await dio.delete(
      "/api/v1/prompts/${req.id}/favorite",
      options: Options(headers: headers),
    );
    switch (response.statusCode) {
      case 200:
        rootNavigatorKey.currentContext!.read<PromptProvider>().reload2List();
        req.onSuccess();
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
