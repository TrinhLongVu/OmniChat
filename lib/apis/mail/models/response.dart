class ReplyEmailResponse {
  ReplyEmailResponse({required this.ideas});

  final List<String> ideas;

  factory ReplyEmailResponse.fromJson(Map<String, dynamic> json) {
    return ReplyEmailResponse(ideas: List<String>.from(json['ideas']));
  }
}

class RespondEmailResponse {
  RespondEmailResponse({
    required this.email,
    required this.token,
    required this.improvedActions,
  });

  final String email;
  final int token;
  final List<String> improvedActions;

  factory RespondEmailResponse.fromJson(Map<String, dynamic> json) {
    return RespondEmailResponse(
      email: json['email'],
      token: json['remainingUsage'],
      improvedActions: List<String>.from(json['improvedActions']),
    );
  }
}
