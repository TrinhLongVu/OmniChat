import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:omni_chat/apis/mail/models/request.dart';
import 'package:omni_chat/apis/mail/models/response.dart';
import 'package:omni_chat/constants/base_urls.dart';
import 'package:omni_chat/router/index.dart';
import 'package:omni_chat/services/dio_client.dart';
import 'package:quickalert/quickalert.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<ReplyEmailResponse?> replyEmail(ReplyEmailRequest req) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String? accessToken = prefs.getString("access_token");

  var headers = {
    'x-jarvis-guid': '',
    'Authorization': 'Bearer $accessToken',
    'Content-Type': 'application/json',
  };

  Dio dio = DioClient(baseUrl: BaseUrls.jarvis).dio;

  try {
    Response response = await dio.post(
      "/api/v1/ai-email/reply-ideas",
      data: {
        "action": "Suggest 3 ideas for this email",
        "email": req.content,
        "metadata": {
          "context": [],
          "receiver": "me",
          "sender": req.sender,
          "subject": req.subject,
        },
      },
      options: Options(headers: headers),
    );
    switch (response.statusCode) {
      case 200:
        ReplyEmailResponse res = ReplyEmailResponse.fromJson(response.data);
        return res;
      default:
        QuickAlert.show(
          context: rootNavigatorKey.currentContext!,
          type: QuickAlertType.error,
          text: "Something went wrong! Please try again later.",
        );
        return null;
    }
  } catch (e) {
    debugPrint("Error: $e");
    QuickAlert.show(
      context: rootNavigatorKey.currentContext!,
      type: QuickAlertType.error,
      text: "Something went wrong! Please try again later.",
    );
    return null;
  }
}
