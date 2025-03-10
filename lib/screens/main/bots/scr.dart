import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:omni_chat/constants/color.dart';
import 'package:omni_chat/screens/main/bots/bot_archive_box.dart';

class BotListScreen extends StatelessWidget {
  const BotListScreen({super.key});

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
                child: TextField(
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Color(0xffB0B0B0).withValues(alpha: 0.1),
                    hintText: 'Search Bots ...',
                    border: OutlineInputBorder(
                      borderSide: BorderSide.none,
                      borderRadius: BorderRadius.circular(30),
                    ),
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 5,
                    ),
                    prefixIcon: Icon(
                      Icons.search,
                      color: Colors.black.withValues(alpha: 0.6),
                    ),
                  ),
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
              children: List.generate(12, (index) => BotArchiveBox()),
            ),
          ),
        ),
      ],
    );
  }
}
