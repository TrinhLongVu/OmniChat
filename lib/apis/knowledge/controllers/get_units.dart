import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:omni_chat/apis/knowledge/models/request.dart';
import 'package:omni_chat/apis/knowledge/models/response.dart';
import 'package:omni_chat/constants/base_urls.dart';
import 'package:omni_chat/services/dio_client.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<GetKnowledgeUnitsResponse?> getKnowledgeUnits(
  GetKnowledgeUnitsRequest req,
) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String? accessToken = prefs.getString("access_token");

  var headers = {'x-jarvis-guid': '', 'Authorization': 'Bearer $accessToken'};

  Dio dio = DioClient(baseUrl: BaseUrls.knowledge).dio;

  try {
    Response response = await dio.get(
      "/kb-core/v1/knowledge/${req.id}/units",
      options: Options(headers: headers),
    );
    switch (response.statusCode) {
      case 200:
        GetKnowledgeUnitsResponse res = GetKnowledgeUnitsResponse.fromJson(
          response.data,
        );
        return res;
      default:
        return null;
    }
  } catch (e) {
    debugPrint("Error: $e");
  }
  return null;
}
