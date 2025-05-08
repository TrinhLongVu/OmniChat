import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:omni_chat/apis/utils/models/request.dart';
import 'package:omni_chat/constants/base_urls.dart';
import 'package:omni_chat/constants/file_extension.dart';
import 'package:omni_chat/services/dio_client.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<String> uploadFile(UploadFileRequest req) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String? accessToken = prefs.getString("access_token");

  var headers = {
    'x-jarvis-guid': '',
    'Authorization': 'Bearer $accessToken',
    'Content-Type': 'multipart/form-data',
  };

  Dio dio = DioClient(baseUrl: BaseUrls.knowledge).dio;
  try {
    String fileExtension = req.fileName.split('.').last.toLowerCase();

    FileExtensionType fileType;
    try {
      fileType = FileExtensionType.values.firstWhere(
        (e) => e.toString().split('.').last == fileExtension,
      );
    } catch (e) {
      fileType = FileExtensionType.pdf;
    }
    FormData formData = FormData.fromMap({
      "files": await MultipartFile.fromFile(
        req.filePath,
        filename: req.fileName,
        contentType: fileType.mediaType,
      ),
    });

    FormData clonedFormData = formData.clone();

    Response response = await dio.post(
      "/kb-core/v1/knowledge/files",
      data: clonedFormData,
      options: Options(headers: headers),
    );
    switch (response.statusCode) {
      case 201:
        return response.data["files"][0]["id"];
      default:
        return "";
    }
  } catch (e) {
    debugPrint("Error: $e");
    return "";
  }
}
