import 'package:flutter/material.dart';
import 'package:omni_chat/apis/knowledge/controllers/get_list.dart';
import 'package:omni_chat/apis/knowledge/models/response.dart';
import 'package:omni_chat/models/knowledge.dart';

class KnowledgeProvider extends ChangeNotifier {
  bool loadingList = false;
  List<Knowledge> knowledgeList;
  bool botLoading = false;
  Knowledge currentKnowledge = Knowledge.placeholder();
  String query = "";

  KnowledgeProvider({this.knowledgeList = const []});

  Future<void> getListFromApi() async {
    GetKnowledgeListResponse? res = await getKnowledgeList((query: query));
    if (res != null) {
      knowledgeList = res.data;
    }
  }

  void loadList() async {
    loadingList = true;
    notifyListeners();
    await getListFromApi();
    loadingList = false;
    notifyListeners();
  }

  void reloadList() async {
    await getListFromApi();
    notifyListeners();
  }

  void searchKnowledge(String queryStr) {
    query = queryStr;
    reloadList();
  }
}
