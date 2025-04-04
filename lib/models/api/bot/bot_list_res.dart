import 'package:omni_chat/models/api/page_meta.dart';
import 'package:omni_chat/models/bot.dart';

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
