class GetConvoHistoryResponse {
  GetConvoHistoryResponse({
    required this.cursor,
    required this.hasMore,
    required this.limit,
    required this.items,
  });

  final String cursor;
  final bool hasMore;
  final int limit;
  final List<ConvoHistoryItem> items;

  factory GetConvoHistoryResponse.fromJson(Map<String, dynamic> json) {
    return GetConvoHistoryResponse(
      cursor: json['cursor'],
      hasMore: json['has_more'],
      limit: json['limit'],
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
  final int? createdAt;

  factory ConvoHistoryItem.fromJson(Map<String, dynamic> json) {
    return ConvoHistoryItem(
      answer: json['answer'],
      query: json['query'],
      createdAt: json['created_at'],
    );
  }
}
