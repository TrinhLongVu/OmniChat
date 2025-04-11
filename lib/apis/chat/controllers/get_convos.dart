import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:omni_chat/apis/chat/models/request.dart';
import 'package:omni_chat/apis/chat/models/response.dart';
import 'package:omni_chat/constants/base_urls.dart';
import 'package:omni_chat/services/dio_client.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<GetConvosResponse?> getConversations(GetConvosRequest req) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String? accessToken = prefs.getString("access_token");

  var headers = {'x-jarvis-guid': '', 'Authorization': 'Bearer $accessToken'};

  Dio dio = DioClient(baseUrl: BaseUrls.jarvis).dio;

  try {
    Response response = await dio.get(
      "/api/v1/ai-chat/conversations?assistantId=${req.assistantId}&assistantModel=dify",
      options: Options(headers: headers),
    );
    switch (response.statusCode) {
      case 200:
        GetConvosResponse res = GetConvosResponse.fromJson(response.data);
        return res;
      default:
        return null;
    }
  } catch (e) {
    debugPrint("Error: $e");
  }
  return null;
}
