import 'package:omni_chat/models/knowledge.dart';
import 'package:omni_chat/models/page_meta.dart';

class GetKnowledgeListResponse {
  GetKnowledgeListResponse({required this.data, required this.meta});

  final List<Knowledge> data;
  final PaginationMeta meta;

  factory GetKnowledgeListResponse.fromJson(Map<String, dynamic> json) {
    return GetKnowledgeListResponse(
      data:
          (json['data'] as List<dynamic>)
              .map((botJson) => Knowledge.fromJson(botJson))
              .toList(),
      meta: PaginationMeta.fromJson(json['meta']),
    );
  }
}
