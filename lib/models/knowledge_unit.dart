class KnowledgeUnit {
  KnowledgeUnit({
    required this.id,
    required this.name,
    required this.userId,
    this.type,
    this.size,
    this.status,
    required this.knowledgeId,
    required this.createdAt,
    required this.updatedAt,
    this.deletedAt,
    this.createdBy,
    this.updatedBy,
  });

  final String id;
  final String name;
  final String userId;
  final String? type;
  final int? size;
  final bool? status;
  final String knowledgeId;
  final String createdAt;
  final String updatedAt;
  final String? deletedAt;
  final String? createdBy;
  final String? updatedBy;

  factory KnowledgeUnit.fromJson(Map<String, dynamic> json) {
    return KnowledgeUnit(
      id: json['id'],
      name: json['name'],
      userId: json['userId'],
      type: json['type'],
      size: json['size'],
      status: json['status'],
      createdAt: json['createdAt'],
      updatedAt: json['updatedAt'],
      deletedAt: json['deletedAt'],
      createdBy: json['createdBy'],
      updatedBy: json['updatedBy'],
      knowledgeId: json['knowledgeId'],
    );
  }

  factory KnowledgeUnit.placeholder() {
    return KnowledgeUnit(
      id: "",
      name: "",
      type: "",
      userId: "",
      size: 0,
      status: false,
      knowledgeId: "",
      createdAt: "",
      updatedAt: "",
      createdBy: "",
      updatedBy: "",
    );
  }
}
