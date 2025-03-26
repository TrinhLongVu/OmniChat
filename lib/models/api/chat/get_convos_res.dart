class GetConvosResponse {
  GetConvosResponse({
    required this.hasMore,
    required this.limit,
    required this.items,
  });

  final bool hasMore;
  final int limit;
  final List<ConvoItem> items;

  factory GetConvosResponse.fromJson(Map<String, dynamic> json) {
    return GetConvosResponse(
      hasMore: json['has_more'],
      limit: json['limit'],
      items: List<ConvoItem>.from(
        json['items'].map((x) => ConvoItem.fromJson(x)),
      ),
    );
  }
}

class ConvoItem {
  ConvoItem({required this.id, required this.title, required this.createdAt});

  final String id;
  final String title;
  final int createdAt;

  factory ConvoItem.fromJson(Map<String, dynamic> json) {
    return ConvoItem(
      id: json['id'],
      title: json['title'],
      createdAt: json['created_at'],
    );
  }
}
