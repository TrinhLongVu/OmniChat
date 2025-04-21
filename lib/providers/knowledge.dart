import 'package:flutter/material.dart';
import 'package:omni_chat/apis/knowledge/controllers/get_list.dart';
import 'package:omni_chat/apis/knowledge/models/response.dart';
import 'package:omni_chat/models/knowledge.dart';

class KnowledgeProvider extends ChangeNotifier {
  bool loadingList = false;
  List<Knowledge> knowledgeList;
  bool botLoading = false;
  Knowledge currentKnowledge = Knowledge.placeholder();

  KnowledgeProvider({this.knowledgeList = const []});

  Future<void> loadList() async {
    loadingList = true;
    notifyListeners();
    GetKnowledgeListResponse? res = await getKnowledgeList();
    if (res != null) {
      knowledgeList = res.data;
    }
    loadingList = false;
    notifyListeners();
  }
}
