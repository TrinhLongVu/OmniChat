import 'package:flutter/material.dart';
import 'package:omni_chat/apis/chat/controllers/get_convo_history.dart';
import 'package:omni_chat/apis/chat/controllers/get_convos.dart';
import 'package:omni_chat/apis/chat/models/response.dart';
import 'package:omni_chat/models/convo_item.dart';

class ConvoProvider extends ChangeNotifier {
  String currentConvoId = "";
  int currentToken = 0;
  List<ConvoHistoryItem> currentConvoHistoryList;
  List<ConvoItem> convoList;

  ConvoProvider({
    this.currentConvoHistoryList = const [],
    this.convoList = const [],
  });

  Future<void> initConvoList() async {
    GetConvosResponse? convosResponse = await getConversations("gpt-4o-mini");
    if (convosResponse != null) {
      convoList = convosResponse.items;
      currentConvoId = convoList[0].id;
      loadCurrentConvo();
    }
    notifyListeners();
  }

  Future<void> loadConvoList() async {
    GetConvosResponse? convosResponse = await getConversations("gpt-4o-mini");
    if (convosResponse != null) {
      convoList = convosResponse.items;
    }
    notifyListeners();
  }

  Future<void> loadCurrentConvo() async {
    GetConvoHistoryResponse? convoHistoryResponse =
        await getConversationHistory(convoId: currentConvoId);

    if (convoHistoryResponse != null) {
      currentConvoHistoryList = convoHistoryResponse.items;
    }
    notifyListeners();
  }

  void setCurrentConvoId(String id) {
    currentConvoId = id;
    loadCurrentConvo();
    notifyListeners();
  }

  void setCurrentToken(int token) {
    currentToken = token;
    notifyListeners();
  }
}
