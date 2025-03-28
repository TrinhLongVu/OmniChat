import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:omni_chat/constants/base_urls.dart';
import 'package:omni_chat/models/api/prompt/prompt_list_res.dart';
import 'package:omni_chat/services/dio_client.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<PromptListResponse?> getPromptList({
  required bool isFavorite,
  required bool isPublic,
  String? query = "",
  String? category = "",
}) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String? accessToken = prefs.getString("access_token");

  var headers = {'x-jarvis-guid': '', 'Authorization': 'Bearer $accessToken'};

  Dio dio = DioClient(baseUrl: BaseUrls.jarvis).dio;

  try {
    Response response = await dio.get(
      "/api/v1/prompts?query=$query&category=$category&isFavorite=$isFavorite&isPublic=$isPublic",
      options: Options(headers: headers),
    );
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
