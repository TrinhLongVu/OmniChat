import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:omni_chat/constants/base_urls.dart';
import 'package:omni_chat/models/api/chat/get_convo_history_res.dart';
import 'package:omni_chat/services/dio_client.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<GetConvoHistoryResponse?> getConversationHistory({
  required String convoId,
}) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String? accessToken = prefs.getString("access_token");

  var headers = {'x-jarvis-guid': '', 'Authorization': 'Bearer $accessToken'};

  Dio dio = DioClient(baseUrl: BaseUrls.jarvis).dio;

  try {
    Response response = await dio.get(
      "/api/v1/ai-chat/conversations/$convoId/messages?assistantId=gpt-4o-mini&assistantModel=dify",
      options: Options(headers: headers),
    );
    debugPrint(response.data.toString());
    switch (response.statusCode) {
      case 200:
        GetConvoHistoryResponse meObj = GetConvoHistoryResponse.fromJson(
          response.data,
        );
        return meObj;
      default:
        return null;
    }
  } catch (e) {
    debugPrint("Error: $e");
  }
  return null;
}
