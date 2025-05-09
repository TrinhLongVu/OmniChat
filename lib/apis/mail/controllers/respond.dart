import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:omni_chat/apis/mail/models/request.dart';
import 'package:omni_chat/apis/mail/models/response.dart';
import 'package:omni_chat/constants/base_urls.dart';
import 'package:omni_chat/providers/convo.dart';
import 'package:omni_chat/router/index.dart';
import 'package:omni_chat/services/dio_client.dart';
import 'package:provider/provider.dart';
import 'package:quickalert/quickalert.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<RespondEmailResponse?> respondEmail(RespondEmailRequest req) async {
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
      "/api/v1/ai-email/",
      data: {
        "action": "Reply to this email",
        "mainIdea": req.mainIdea,
        "email": req.content,
        "availableImprovedActions": [
          "More engaging",
          "More Informative",
          "Add humor",
          "Add details",
          "More apologetic",
          "Make it polite",
          "Add clarification",
          "Simplify language",
          "Improve structure",
          "Add empathy",
          "Add a summary",
          "Insert professional jargon",
          "Make longer",
          "Make shorter",
        ],
        "metadata": {
          "context": [],
          "subject": req.subject,
          "sender": req.sender,
          "receiver": req.receiver,
          "style": {
            "length": "long",
            "formality": "neutral",
            "tone": "friendly",
          },
        },
      },
      options: Options(headers: headers),
    );
    switch (response.statusCode) {
      case 200:
        RespondEmailResponse res = RespondEmailResponse.fromJson(response.data);
        rootNavigatorKey.currentContext!.read<ConvoProvider>().setCurrentToken(
          res.token,
        );
        return res;
      default:
        req.onError();
        QuickAlert.show(
          context: rootNavigatorKey.currentContext!,
          type: QuickAlertType.error,
          text: "Something went wrong! Please try again later.",
        );
        return null;
    }
  } catch (e) {
    req.onError();
    QuickAlert.show(
      context: rootNavigatorKey.currentContext!,
      type: QuickAlertType.error,
      text: "Something went wrong! Please try again later.",
    );
    debugPrint("Error: $e");
    return null;
  }
}
