import 'package:flutter/material.dart';
import 'package:omni_chat/apis/bot/controllers/get_import_knowledge.dart';
import 'package:omni_chat/apis/bot/controllers/get_info.dart';
import 'package:omni_chat/apis/bot/controllers/get_list.dart';
import 'package:omni_chat/apis/bot/models/response.dart';
import 'package:omni_chat/models/bot.dart';
import 'package:omni_chat/models/knowledge.dart';

class BotProvider extends ChangeNotifier {
  bool loadingList = false;
  List<Bot> botList;
  bool botLoading = false;
  Bot currentBot = Bot.placeholder();
  List<Knowledge> currentBotKnowledges;
  String query = "";

  BotProvider({this.botList = const [], this.currentBotKnowledges = const []});

  Future<void> getListFromApi() async {
    GetBotListResponse? res = await getBotList((query: query));
    if (res != null) {
      botList = res.data;
    }
  }

  Future<void> getImportedKnowledges(String botId) async {
    GetImportedKnowledgeListResponse? res = await getImportedKnowledgeList((
      botId: botId,
    ));
    if (res != null) {
      currentBotKnowledges = res.data;
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

  Future<void> loadInfo({
    required String id,
    required VoidCallback onSuccess,
  }) async {
    botLoading = true;
    notifyListeners();
    Bot? botInfo = await getBotInfo((id: id));
    if (botInfo != null) {
      currentBot = botInfo;
      await getImportedKnowledges(id);
      botLoading = false;
      onSuccess();
    }
    notifyListeners();
  }

  void searchBot(String queryStr) {
    query = queryStr;
    reloadList();
  }
}
