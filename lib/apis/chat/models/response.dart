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
