import 'package:omni_chat/models/convo_item.dart';

class GetConvosResponse {
  GetConvosResponse({
    this.cursor,
    required this.hasMore,
    this.limit,
    required this.items,
  });

  final String? cursor;
  final bool hasMore;
  final int? limit;
  final List<ConvoItem> items;

  factory GetConvosResponse.fromJson(Map<String, dynamic> json) {
    return GetConvosResponse(
      cursor: json['cursor'],
      hasMore: json['has_more'],
      limit: json['limit'],
      items: List<ConvoItem>.from(
        json['items'].map((x) => ConvoItem.fromJson(x)),
      ),
    );
  }
}

class SendMessageResponse {
  SendMessageResponse({
    required this.id,
    required this.message,
    required this.token,
  });

  final String id;
  final String message;
  final int token;

  factory SendMessageResponse.fromJson(Map<String, dynamic> json) {
    return SendMessageResponse(
      id: json['conversationId'],
      message: json['message'],
      token: json['remainingUsage'],
    );
  }
}

class GetConvoHistoryResponse {
  GetConvoHistoryResponse({required this.hasMore, required this.items});

  final bool hasMore;
  final List<ConvoHistoryItem> items;

  factory GetConvoHistoryResponse.fromJson(Map<String, dynamic> json) {
    return GetConvoHistoryResponse(
      hasMore: json['has_more'],
      items: List<ConvoHistoryItem>.from(
        json['items'].map((x) => ConvoHistoryItem.fromJson(x)),
      ),
    );
  }
}

class ConvoHistoryItem {
  ConvoHistoryItem({required this.answer, required this.query, this.createdAt});

  final String answer;
  final String query;
  final String? createdAt;

  factory ConvoHistoryItem.fromJson(Map<String, dynamic> json) {
    return ConvoHistoryItem(
      answer: json['answer'],
      query: json['query'],
      createdAt: json['created_at'],
    );
  }
}
