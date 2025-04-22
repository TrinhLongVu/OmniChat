import 'package:omni_chat/models/knowledge.dart';
import 'package:omni_chat/models/page_meta.dart';
import 'package:omni_chat/models/bot.dart';

class GetBotListResponse {
  GetBotListResponse({required this.data, required this.meta});

  final List<Bot> data;
  final PaginationMeta meta;

  factory GetBotListResponse.fromJson(Map<String, dynamic> json) {
    return GetBotListResponse(
      data:
          (json['data'] as List<dynamic>)
              .map((botJson) => Bot.fromJson(botJson))
              .toList(),
      meta: PaginationMeta.fromJson(json['meta']),
    );
  }
}

class GetImportedKnowledgeListResponse {
  GetImportedKnowledgeListResponse({required this.data, required this.meta});

  final List<Knowledge> data;
  final PaginationMeta meta;

  factory GetImportedKnowledgeListResponse.fromJson(Map<String, dynamic> json) {
    return GetImportedKnowledgeListResponse(
      data:
          (json['data'] as List<dynamic>)
              .map((knowledgeJson) => Knowledge.fromJson(knowledgeJson))
              .toList(),
      meta: PaginationMeta.fromJson(json['meta']),
    );
  }
}
