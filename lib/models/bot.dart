class Bot {
  Bot({
    required this.id,
    required this.userId,
    required this.name,
    this.instruction,
    this.description,
    required this.createdAt,
    required this.updatedAt,
    this.deletedAt,
    this.createdBy,
    this.updatedBy,
    required this.isDefault,
    required this.isFavorite,
    this.permissions,
  });

  final String id;
  final String userId;
  final String name;
  final String? instruction;
  final String? description;
  final String createdAt;
  final String updatedAt;
  final String? deletedAt;
  final String? createdBy;
  final String? updatedBy;
  final bool isDefault;
  final bool isFavorite;
  final List<String>? permissions;

  factory Bot.fromJson(Map<String, dynamic> json) {
    return Bot(
      id: json['id'],
      userId: json['userId'],
      name: json['assistantName'],
      instruction: json['instructions'],
      description: json['description'],
      createdAt: json['createdAt'],
      updatedAt: json['updatedAt'],
      deletedAt: json['deletedAt'],
      createdBy: json['createdBy'],
      updatedBy: json['updatedBy'],
      isDefault: json['isDefault'],
      isFavorite: json['isFavorite'],
      permissions:
          json['permissions'] != null
              ? List<String>.from(json['permissions'])
              : null,
    );
  }

  factory Bot.placeholder() {
    return Bot(
      id: "",
      userId: "",
      name: "",
      instruction: "",
      description: "",
      createdAt: "",
      updatedAt: "",
      deletedAt: "",
      createdBy: "",
      updatedBy: "",
      isDefault: false,
      isFavorite: false,
      permissions: [],
    );
  }
}
