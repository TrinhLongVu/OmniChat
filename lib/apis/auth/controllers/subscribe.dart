import 'package:dio/dio.dart';
import 'package:omni_chat/constants/base_urls.dart';
import 'package:omni_chat/providers/user.dart';
import 'package:omni_chat/router/index.dart';
import 'package:omni_chat/services/dio_client.dart';
import 'package:provider/provider.dart';
import 'package:quickalert/quickalert.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<String?> subscribe() async {
  if (rootNavigatorKey.currentContext!.read<UserProvider>().subscriptionPlan ==
      "Starter") {
    return null;
  }
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String? accessToken = prefs.getString("access_token");

  var headers = {'x-jarvis-guid': '', 'Authorization': 'Bearer $accessToken'};

  Dio dio = DioClient(baseUrl: BaseUrls.jarvis).dio;

  try {
    Response response = await dio.get(
      "/api/v1/subscriptions/subscribe?plan=starter&period=annually",
      options: Options(headers: headers),
    );
    switch (response.statusCode) {
      case 200:
        return response.data.toString();
      default:
        QuickAlert.show(
          context: rootNavigatorKey.currentContext!,
          type: QuickAlertType.error,
          text: "Something went wrong! Please try again later.",
        );
        return null;
    }
  } catch (e) {
    QuickAlert.show(
      context: rootNavigatorKey.currentContext!,
      type: QuickAlertType.error,
      text: "Something went wrong! Please try again later.",
    );
    return null;
  }
}
