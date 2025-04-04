import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:omni_chat/apis/bot/get_list.dart';
import 'package:omni_chat/constants/color.dart';
import 'package:omni_chat/models/api/bot/bot_list_res.dart';
import 'package:omni_chat/models/bot.dart';
import 'package:omni_chat/widgets/rectangle/bot_rect.dart';
import 'package:omni_chat/widgets/search_box.dart';

class BotListScreen extends StatefulWidget {
  const BotListScreen({super.key});

  @override
  State<BotListScreen> createState() => _BotListScreenState();
}

class _BotListScreenState extends State<BotListScreen> {
  final TextEditingController searchBotCtrlr = TextEditingController();

  List<Bot> botList = [];

  @override
  void initState() {
    super.initState();
    loadBotList();
  }

  Future<void> loadBotList() async {
    BotListResponse? botListRes = await getBotList();
    if (mounted && botListRes != null) {
      setState(() {
        botList = botListRes.data;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
          color: Colors.white,
          child: Row(
            children: [
              Expanded(
                child: SearchBox(
                  ctrlr: searchBotCtrlr,
                  placeholder: "Search Bots...",
                  onSearch: () {},
                ),
              ),
              IconButton(
                onPressed: () async {
                  final result = await context.push("/bots/new");
                  if (result == true) {
                    loadBotList();
                  }
                },
                icon: Icon(
                  Icons.add_circle_outline,
                  size: 32,
                  color: omniDarkBlue,
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Column(
              children:
                  botList.map((bot) {
                    return BotRect(
                      title: bot.name,
                      subtitle: bot.description,
                      id: bot.id,
                      navigateToInfo: () async {
                        final result = await context.push("/bots/${bot.id}");
                        if (result == null) {
                          loadBotList();
                        }
                      },
                    );
                  }).toList(),
            ),
          ),
        ),
      ],
    );
  }
}
