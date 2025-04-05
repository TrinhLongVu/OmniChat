import 'package:flutter/material.dart';
import 'package:omni_chat/models/prompt.dart';

class ChatProvider extends ChangeNotifier {
  Prompt msgPrompt = Prompt.placeholder();
  String message = "";

  void setPrompt(Prompt prompt) {
    msgPrompt = prompt;
    notifyListeners();
  }

  void setMessage(String msg) {
    message = msg;
    notifyListeners();
  }
}
