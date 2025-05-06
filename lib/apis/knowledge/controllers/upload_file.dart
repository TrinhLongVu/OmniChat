import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:omni_chat/apis/knowledge/models/request.dart';
import 'package:omni_chat/constants/base_urls.dart';
import 'package:omni_chat/constants/file_extension.dart';
import 'package:omni_chat/providers/knowledge.dart';
import 'package:omni_chat/router/index.dart';
import 'package:omni_chat/services/dio_client.dart';
import 'package:provider/provider.dart';
import 'package:quickalert/quickalert.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> uploadFileToKnowledge(UploadFileToKnowledgeRequest req) async {
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
      "file": await MultipartFile.fromFile(
        req.filePath,
        filename: req.fileName.split('.').first,
        contentType: fileType.mediaType,
      ),
    });

    FormData clonedFormData = formData.clone();

    Response response = await dio.post(
      "/kb-core/v1/knowledge/${req.id}/local-file",
      data: clonedFormData,
      options: Options(headers: headers),
    );
    switch (response.statusCode) {
      case 201:
        QuickAlert.show(
          context: rootNavigatorKey.currentContext!,
          type: QuickAlertType.success,
          text: "Successfully uploaded to knowledge",
          onConfirmBtnTap:
              () => {
                rootNavigatorKey.currentContext!
                    .read<KnowledgeProvider>()
                    .reloadKnowledgeUnits(),
                GoRouter.of(rootNavigatorKey.currentContext!).pop(),
                GoRouter.of(rootNavigatorKey.currentContext!).pop(),
              },
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
    req.onError();
    QuickAlert.show(
      context: rootNavigatorKey.currentContext!,
      type: QuickAlertType.error,
      text: "Something went wrong! Please try again later.",
    );
    debugPrint("Error: $e");
  }
}
