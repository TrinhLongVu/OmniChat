import 'package:omni_chat/models/assistant.dart';

enum Assistant {
  claudeHaiku("claude-3-haiku-20240307", "Claude 3 Haiku"),
  claudeSonnet("claude-3-sonnet-20240229", "Claude 3 Sonnet"),
  geminiFlash("gemini-1.5-flash-latest", "Gemini 1.5 Flash"),
  geminiPro("gemini-1.5-pro-latest", "Gemini 1.5 Pro"),
  gpt4o("gpt-4o", "GPT-4o"),
  gpt4oMini("gpt-4o-mini", "GPT-4o Mini");

  final String id;
  final String name;
  const Assistant(this.id, this.name);
}

extension AssistantExtension on Assistant {
  AssistantDto toDto() {
    return AssistantDto(id: id, name: name);
  }
}
