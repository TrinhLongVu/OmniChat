class Bot {
  Bot({
    required this.id,
    required this.userId,
    required this.name,
    required this.instruction,
    this.description,
    required this.createdAt,
    required this.updatedAt,
    this.deletedAt,
    this.createdBy,
    this.updatedBy,
    required this.openAiAssistantId,
    required this.openAiThreadIdPlay,
  });

  final String id;
  final String userId;
  final String name;
  final String instruction;
  final String? description;
  final String createdAt;
  final String updatedAt;
  final String? deletedAt;
  final String? createdBy;
  final String? updatedBy;
  final String openAiAssistantId;
  final String openAiThreadIdPlay;

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
      openAiAssistantId: json['openAiAssistantId'],
      openAiThreadIdPlay: json['openAiThreadIdPlay'],
    );
  }
}
