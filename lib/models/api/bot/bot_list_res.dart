import 'package:omni_chat/models/bot_model.dart';

class BotListResponse {
  BotListResponse({required this.data, required this.meta});

  final List<Bot> data;
  final PaginationMeta meta;

  factory BotListResponse.fromJson(Map<String, dynamic> json) {
    return BotListResponse(
      data:
          (json['data'] as List<dynamic>)
              .map((botJson) => Bot.fromJson(botJson))
              .toList(),
      meta: PaginationMeta.fromJson(json['meta']),
    );
  }
}

class PaginationMeta {
  PaginationMeta({
    required this.limit,
    required this.total,
    required this.offset,
    required this.hasNext,
  });

  final int limit;
  final int total;
  final int offset;
  final bool hasNext;

  factory PaginationMeta.fromJson(Map<String, dynamic> json) {
    return PaginationMeta(
      limit: json['limit'] as int,
      total: json['total'] as int,
      offset: json['offset'] as int,
      hasNext: json['hasNext'],
    );
  }
}
