class ConvoHistoryItem {
  ConvoHistoryItem({this.answer, required this.query, this.createdAt});

  final String? answer;
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
