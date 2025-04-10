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
