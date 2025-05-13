import 'package:omni_chat/models/knowledge.dart';
import 'package:omni_chat/models/knowledge_unit.dart';
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

class GetKnowledgeUnitsResponse {
  GetKnowledgeUnitsResponse({required this.data, required this.meta});

  final List<KnowledgeUnit> data;
  final PaginationMeta meta;

  factory GetKnowledgeUnitsResponse.fromJson(Map<String, dynamic> json) {
    return GetKnowledgeUnitsResponse(
      data:
          (json['data'] as List<dynamic>)
              .map((botJson) => KnowledgeUnit.fromJson(botJson))
              .toList(),
      meta: PaginationMeta.fromJson(json['meta']),
    );
  }
}
