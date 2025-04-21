class Knowledge {
  Knowledge({
    required this.id,
    required this.name,
    required this.description,
    required this.userId,
    required this.numUnits,
    required this.totalSize,
    required this.createdAt,
    required this.updatedAt,
    this.deletedAt,
    this.createdBy,
    this.updatedBy,
  });

  final String id;
  final String name;
  final String description;
  final String userId;
  final int numUnits;
  final int totalSize;
  final String createdAt;
  final String updatedAt;
  final String? deletedAt;
  final String? createdBy;
  final String? updatedBy;

  factory Knowledge.fromJson(Map<String, dynamic> json) {
    return Knowledge(
      id: json['id'],
      name: json['knowledgeName'],
      description: json['description'],
      userId: json['userId'],
      numUnits: json['numUnits'],
      totalSize: json['totalSize'],
      createdAt: json['createdAt'],
      updatedAt: json['updatedAt'],
      deletedAt: json['deletedAt'],
      createdBy: json['createdBy'],
      updatedBy: json['updatedBy'],
    );
  }

  factory Knowledge.placeholder() {
    return Knowledge(
      id: "",
      name: "",
      description: "",
      userId: "",
      numUnits: 0,
      totalSize: 0,
      createdAt: "",
      updatedAt: "",
      createdBy: "",
      updatedBy: "",
    );
  }
}
