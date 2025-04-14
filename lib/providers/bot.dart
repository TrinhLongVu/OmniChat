import 'package:flutter/material.dart';
import 'package:omni_chat/apis/bot/controllers/get_list.dart';
import 'package:omni_chat/apis/bot/models/response.dart';
import 'package:omni_chat/models/bot.dart';

class BotProvider extends ChangeNotifier {
  List<Bot> botList;

  BotProvider({this.botList = const []});

  Future<void> loadBotList() async {
    GetBotListResponse? res = await getBotList();
    if (res != null) {
      botList = res.data;
    }
    debugPrint(botList.toString());
    notifyListeners();
  }
}
