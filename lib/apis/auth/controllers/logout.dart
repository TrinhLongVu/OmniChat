import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:omni_chat/constants/base_urls.dart';
import 'package:omni_chat/providers/convo.dart';
import 'package:omni_chat/router/index.dart';
import 'package:omni_chat/services/dio_client.dart';
import 'package:provider/provider.dart';
import 'package:quickalert/quickalert.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> logout() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String? accessToken = prefs.getString("access_token");
  String? refreshToken = prefs.getString("refresh_token");

  var headers = {
    'Authorization': 'Bearer $accessToken',
    'X-Stack-Access-Type': 'client',
    'X-Stack-Project-Id': 'a914f06b-5e46-4966-8693-80e4b9f4f409',
    'X-Stack-Publishable-Client-Key':
        'pck_tqsy29b64a585km2g4wnpc57ypjprzzdch8xzpq0xhayr',
    'X-Stack-Refresh-Token': '$refreshToken',
    'Content-Type': 'application/json',
  };

  Dio dio = DioClient(baseUrl: BaseUrls.auth).dio;

  try {
    Response response = await dio.delete(
      "/api/v1/auth/sessions/current",
      data: {},
      options: Options(headers: headers),
    );
    switch (response.statusCode) {
      case 200:
        prefs.remove("access_token");
        prefs.remove("refresh_token");
        GoRouter.of(rootNavigatorKey.currentContext!).goNamed("landing");
        rootNavigatorKey.currentContext!.read<ConvoProvider>().exitConvo();
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
