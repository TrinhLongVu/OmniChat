import 'package:flutter/material.dart';
import 'package:omni_chat/apis/bot/controllers/get_list.dart';
import 'package:omni_chat/apis/bot/models/response.dart';
import 'package:omni_chat/models/bot.dart';

class BotProvider extends ChangeNotifier {
  bool loadingList = false;
  List<Bot> botList;

  BotProvider({this.botList = const []});

  Future<void> loadList() async {
    loadingList = true;
    notifyListeners();
    GetBotListResponse? res = await getBotList();
    if (res != null) {
      botList = res.data;
    }
    loadingList = false;
    notifyListeners();
  }
}
