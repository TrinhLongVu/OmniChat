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

Future<void> login(AuthRequest req) async {
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
      "/api/v1/auth/password/sign-in",
      data: {"email": req.email, "password": req.password},
      options: Options(headers: headers),
    );
    switch (response.statusCode) {
      case 200:
        AuthenticationResponse loginData = AuthenticationResponse.fromJson(
          response.data,
        );
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString('access_token', loginData.accessToken);
        await prefs.setString('refresh_token', loginData.refreshToken);
        rootNavigatorKey.currentContext!.read<UserProvider>().setUser();
        QuickAlert.show(
          context: rootNavigatorKey.currentContext!,
          type: QuickAlertType.success,
          text: "Login successful!",
          barrierDismissible: false,
          onConfirmBtnTap:
              () => {
                GoRouter.of(
                  rootNavigatorKey.currentContext!,
                ).goNamed("all-bots"),
              },
        );
        break;
      case 400:
        QuickAlert.show(
          context: rootNavigatorKey.currentContext!,
          type: QuickAlertType.error,
          text: "Invalid email or password!",
        );
        req.onError();
        break;
      default:
        QuickAlert.show(
          context: rootNavigatorKey.currentContext!,
          type: QuickAlertType.error,
          text: "Something went wrong! Please try again later.",
        );
        req.onError();
    }
  } catch (e) {
    debugPrint("Error: $e");
  }
}
