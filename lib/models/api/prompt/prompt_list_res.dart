import 'package:omni_chat/models/prompt.dart';

class PromptListResponse {
  PromptListResponse({
    required this.items,
    required this.hasNext,
    required this.offset,
    required this.limit,
    required this.total,
  });

  final List<Prompt> items;
  final bool hasNext;
  final int offset;
  final int limit;
  final int total;

  factory PromptListResponse.fromJson(Map<String, dynamic> json) {
    return PromptListResponse(
      items:
          (json['items'] as List<dynamic>)
              .map((botJson) => Prompt.fromJson(botJson))
              .toList(),
      hasNext: json['hasNext'],
      offset: json['offset'],
      limit: json['limit'],
      total: json['total'],
    );
  }
}
