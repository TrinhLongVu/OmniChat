import 'package:flutter/material.dart';

class ChatProvider extends ChangeNotifier {
  String msgPrompt = "";
  String message = "";

  void setPrompt(String prompt) {
    msgPrompt = prompt;
    notifyListeners();
  }

  void setMessage(String msg) {
    message = msg;
    notifyListeners();
  }
}
