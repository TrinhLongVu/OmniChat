class Prompt {
  Prompt({
    required this.id,
    this.userId,
    this.userName,
    required this.title,
    this.category,
    required this.content,
    this.description,
    this.language,
    this.createdAt,
    this.updatedAt,
    required this.isPublic,
    required this.isFavorite,
  });

  final String id;
  final String? userId;
  final String? userName;
  final String title;
  final String? category;
  final String content;
  final String? description;
  final String? language;
  final String? createdAt;
  final String? updatedAt;
  final bool isPublic;
  final bool isFavorite;

  factory Prompt.fromJson(Map<String, dynamic> json) {
    return Prompt(
      id: json['_id'],
      userId: json['userId'],
      userName: json['userName'],
      title: json['title'],
      category: json['category'],
      content: json['content'],
      description: json['description'],
      language: json['language'],
      createdAt: json['createdAt'],
      updatedAt: json['updatedAt'],
      isPublic: json['isPublic'],
      isFavorite: json['isFavorite'],
    );
  }
  factory Prompt.placeholder() {
    return Prompt(
      id: "",
      userId: "",
      userName: "",
      title: "",
      category: "",
      content: "",
      description: "",
      language: "",
      createdAt: "",
      updatedAt: "",
      isPublic: false,
      isFavorite: false,
    );
  }
}
