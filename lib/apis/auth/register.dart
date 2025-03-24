import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:omni_chat/router/index.dart';
import 'package:omni_chat/services/dio_client.dart';
import 'package:quickalert/quickalert.dart';

Future<void> register(
  String email,
  String password,
  String confirmPassword,
) async {
  Dio dio = DioClient().dio;

  var headers = {
    'X-Stack-Access-Type': 'client',
    'X-Stack-Project-Id': 'a914f06b-5e46-4966-8693-80e4b9f4f409',
    'X-Stack-Publishable-Client-Key':
        'pck_tqsy29b64a585km2g4wnpc57ypjprzzdch8xzpq0xhayr',
    'Content-Type': 'application/json',
  };

  try {
    QuickAlert.show(
      context: rootNavigatorKey.currentContext!,
      type: QuickAlertType.success,
      text: "Registration successful!",
    );
    Response response = await dio.post(
      "/api/v1/auth/password/sign-up",
      data: {
        "email": email,
        "password": password,
        "verification_callback_url":
            "https://auth.dev.jarvis.cx/handler/email-verification?after_auth_return_to=%2Fauth%2Fsignin%3Fclient_id%3Djarvis_chat%26redirect%3Dhttps%253A%252F%252Fchat.dev.jarvis.cx%252Fauth%252Foauth%252Fsuccess",
      },
      options: Options(headers: headers),
    );

    debugPrint("Response Data: ${response.data}");
    debugPrint("Response Headers: ${response.headers}");
  } catch (e) {
    debugPrint("Error: $e");
  }
}
