import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:omni_chat/apis/prompt/models/request.dart';
import 'package:omni_chat/apis/prompt/models/response.dart';
import 'package:omni_chat/constants/base_urls.dart';
import 'package:omni_chat/services/dio_client.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<PromptListResponse?> getPromptList(GetPromptListRequest req) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String? accessToken = prefs.getString("access_token");

  var headers = {'x-jarvis-guid': '', 'Authorization': 'Bearer $accessToken'};

  Dio dio = DioClient(baseUrl: BaseUrls.jarvis).dio;

  try {
    String url =
        "/api/v1/prompts?query=${req.query}&isFavorite=${req.isFavorite}&isPublic=${req.isPublic}";
    if (req.category.isNotEmpty) {
      url += "&category=${req.category}";
    }
    Response response = await dio.get(url, options: Options(headers: headers));
    switch (response.statusCode) {
      case 200:
        PromptListResponse promptListRes = PromptListResponse.fromJson(
          response.data,
        );
        return promptListRes;
      default:
        return null;
    }
  } catch (e) {
    debugPrint("Error: $e");
  }
  return null;
}
