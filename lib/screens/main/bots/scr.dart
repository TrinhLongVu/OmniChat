import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:omni_chat/constants/color.dart';
import 'package:omni_chat/screens/main/bots/bot_rect.dart';
import 'package:omni_chat/widgets/search_box.dart';

class BotListScreen extends StatelessWidget {
  final TextEditingController searchBotCtrlr = TextEditingController();

  BotListScreen({super.key});

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
                ),
              ),
              IconButton(
                onPressed: () {
                  context.go("/chats/new");
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
              children: List.generate(
                12,
                (index) => BotRect(
                  name: "Grammar Bot",
                  description:
                      "This is a grammar bot that can help you with grammar issues",
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
