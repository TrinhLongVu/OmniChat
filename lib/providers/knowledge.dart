import 'package:flutter/material.dart';
import 'package:omni_chat/apis/knowledge/controllers/get_list.dart';
import 'package:omni_chat/apis/knowledge/controllers/get_units.dart';
import 'package:omni_chat/apis/knowledge/models/response.dart';
import 'package:omni_chat/models/knowledge.dart';
import 'package:omni_chat/models/knowledge_unit.dart';

class KnowledgeProvider extends ChangeNotifier {
  List<Knowledge> knowledgeList;
  bool loadingList = false;
  String query = "";

  Knowledge currentKnowledge = Knowledge.placeholder();
  List<KnowledgeUnit> currentKnowledgeUnits;
  bool knowledgeLoading = false;

  KnowledgeProvider({
    this.knowledgeList = const [],
    this.currentKnowledgeUnits = const [],
  });

  Future<void> getListFromApi() async {
    GetKnowledgeListResponse? res = await getKnowledgeList((query: query));
    if (res != null) {
      knowledgeList = res.data;
    }
  }

  Future<void> getKnowledgeUnitsFromApi(Knowledge knowledge) async {
    GetKnowledgeUnitsResponse? res = await getKnowledgeUnits((
      id: currentKnowledge.id,
    ));
    if (res != null) {
      currentKnowledgeUnits = res.data;
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

  void reloadKnowledgeUnits() async {
    await getKnowledgeUnitsFromApi(currentKnowledge);
    notifyListeners();
  }

  void setCurrentKnowledge(Knowledge knowledge) async {
    knowledgeLoading = true;
    notifyListeners();
    currentKnowledge = knowledge;
    await getKnowledgeUnitsFromApi(knowledge);
    knowledgeLoading = false;
    notifyListeners();
  }
}
