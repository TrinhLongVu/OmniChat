class Bot {
  final String id;
  final String name;
  final String instruction;
  final String? description;

  Bot({
    required this.id,
    required this.name,
    required this.instruction,
    this.description,
  });
}
