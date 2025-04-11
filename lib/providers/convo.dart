import 'package:flutter/material.dart';
import 'package:omni_chat/apis/auth/controllers/get_token.dart';
import 'package:omni_chat/apis/auth/models/response.dart';
import 'package:omni_chat/apis/chat/controllers/get_convo_history.dart';
import 'package:omni_chat/apis/chat/controllers/get_convos.dart';
import 'package:omni_chat/apis/chat/models/response.dart';
import 'package:omni_chat/models/conversation/convo_history_item.dart';
import 'package:omni_chat/models/conversation/convo_item.dart';
import 'package:omni_chat/models/prompt.dart';

class ConvoProvider extends ChangeNotifier {
  String currentConvoId = "";
  int currentToken = 0;
  Prompt currentPrompt = Prompt.placeholder();
  List<ConvoHistoryItem> currentConvoHistoryList;
  List<ConvoItem> convoList;

  ConvoProvider({
    this.currentConvoHistoryList = const [],
    this.convoList = const [],
  });

  Future<void> initConvoList() async {
    GetTokenResponse? tokenRes = await getToken();
    if (tokenRes != null) {
      currentToken = tokenRes.currentToken;
    }
    GetConvosResponse? convosResponse = await getConversations((
      assistantId: "gpt-4o-mini",
    ));
    if (convosResponse != null) {
      convoList = convosResponse.items;
    }
    notifyListeners();
  }

  Future<void> loadConvoList() async {
    GetConvosResponse? convosResponse = await getConversations((
      assistantId: "gpt-4o-mini",
    ));
    if (convosResponse != null) {
      convoList = convosResponse.items;
    }
    notifyListeners();
  }

  Future<void> reloadConvo() async {
    clearCurrentConvo();
    loadCurrentConvo();
  }

  Future<void> loadCurrentConvo() async {
    GetConvoHistoryResponse? convoHistoryResponse =
        await getConversationHistory((convoId: currentConvoId));

    if (convoHistoryResponse != null) {
      currentConvoHistoryList = convoHistoryResponse.items;
    }
    notifyListeners();
  }

  void clearCurrentConvo() {
    currentConvoHistoryList = [];
    notifyListeners();
  }

  void setCurrentConvoId(String id) {
    currentConvoId = id;
    notifyListeners();
  }

  void changeCurrentConvo(String id) {
    setCurrentConvoId(id);
    reloadConvo();
    notifyListeners();
  }

  void setCurrentToken(int token) {
    currentToken = token;
    notifyListeners();
  }

  void setPrompt(Prompt prompt) {
    currentPrompt = prompt;
    notifyListeners();
  }

  void clearPrompt() {
    currentPrompt = Prompt.placeholder();
    notifyListeners();
  }

  void askChat(String message) {
    currentConvoHistoryList.add(ConvoHistoryItem(query: message));
    notifyListeners();
  }

  void exitConvo() {
    currentToken = 0;
    currentConvoId = "";
    currentConvoHistoryList = [];
    currentPrompt = Prompt.placeholder();
    convoList = [];
    notifyListeners();
  }
}
