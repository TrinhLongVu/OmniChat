import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:omni_chat/apis/knowledge/models/request.dart';
import 'package:omni_chat/constants/base_urls.dart';
import 'package:omni_chat/router/index.dart';
import 'package:omni_chat/services/dio_client.dart';
import 'package:quickalert/quickalert.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> uploadWebToKnowledge(UploadWebToKnowledgeRequest req) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String? accessToken = prefs.getString("access_token");

  var headers = {
    'x-jarvis-guid': '',
    'Authorization': 'Bearer $accessToken',
    'Content-Type': 'application/json',
  };

  Dio dio = DioClient(baseUrl: BaseUrls.knowledge).dio;

  try {
    Response response = await dio.post(
      "/kb-core/v1/knowledge/${req.id}/web",
      data: {"unitName": req.unitName, "webUrl": req.webUrl},
      options: Options(headers: headers),
    );
    debugPrint(response.data.toString());
    switch (response.statusCode) {
      case 201:
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
