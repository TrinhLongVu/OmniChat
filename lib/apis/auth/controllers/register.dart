import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:omni_chat/apis/auth/models/request.dart';
import 'package:omni_chat/apis/auth/models/response.dart';
import 'package:omni_chat/constants/base_urls.dart';
import 'package:omni_chat/providers/user.dart';
import 'package:omni_chat/router/index.dart';
import 'package:omni_chat/services/dio_client.dart';
import 'package:provider/provider.dart';
import 'package:quickalert/quickalert.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> register(AuthRequest req) async {
  const headers = {
    'X-Stack-Access-Type': 'client',
    'X-Stack-Project-Id': 'a914f06b-5e46-4966-8693-80e4b9f4f409',
    'X-Stack-Publishable-Client-Key':
        'pck_tqsy29b64a585km2g4wnpc57ypjprzzdch8xzpq0xhayr',
    'Content-Type': 'application/json',
  };

  Dio dio = DioClient(baseUrl: BaseUrls.auth).dio;

  try {
    Response response = await dio.post(
      "/api/v1/auth/password/sign-up",
      data: {
        "email": req.email,
        "password": req.password,
        "verification_callback_url":
            "https://auth.dev.jarvis.cx/handler/email-verification?after_auth_return_to=%2Fauth%2Fsignin%3Fclient_id%3Djarvis_chat%26redirect%3Dhttps%253A%252F%252Fchat.dev.jarvis.cx%252Fauth%252Foauth%252Fsuccess",
      },
      options: Options(headers: headers),
    );
    switch (response.statusCode) {
      case 200:
        QuickAlert.show(
          context: rootNavigatorKey.currentContext!,
          type: QuickAlertType.success,
          barrierDismissible: false,
          text: "Registration successful!",
          confirmBtnText: "Login now",
          onConfirmBtnTap: () async {
            AuthenticationResponse registerData =
                AuthenticationResponse.fromJson(response.data);
            SharedPreferences prefs = await SharedPreferences.getInstance();
            await prefs.setString('access_token', registerData.accessToken);
            await prefs.setString('refresh_token', registerData.refreshToken);
            rootNavigatorKey.currentContext!.read<UserProvider>().setUser();
            GoRouter.of(rootNavigatorKey.currentContext!).goNamed("all-bots");
          },
        );
        break;
      case 400:
        req.onError();
        QuickAlert.show(
          context: rootNavigatorKey.currentContext!,
          type: QuickAlertType.error,
          text: "Please use a valid email to proceed!",
        );
        break;
      case 409:
        req.onError();
        QuickAlert.show(
          context: rootNavigatorKey.currentContext!,
          type: QuickAlertType.error,
          text: "This email has already been registered!",
        );
        break;
      default:
        req.onError();
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
