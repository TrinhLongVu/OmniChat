class ConvoItem {
  ConvoItem({required this.id, required this.title, this.createdAt});

  final String id;
  final String title;
  final int? createdAt;

  factory ConvoItem.fromJson(Map<String, dynamic> json) {
    return ConvoItem(
      id: json['id'],
      title: json['title'],
      createdAt: json['created_at'],
    );
  }
}
