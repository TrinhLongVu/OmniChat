import 'package:flutter/material.dart';
import 'package:omni_chat/constants/color.dart';
import 'package:omni_chat/models/conversation/convo_item.dart';
import 'package:omni_chat/providers/convo.dart';
import 'package:omni_chat/widgets/rectangle/chat_thread_rect.dart';
import 'package:provider/provider.dart';

class ThreadDrawer extends StatelessWidget {
  const ThreadDrawer({super.key, required this.conversations});

  final List<ConvoItem> conversations;

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Colors.white,
      child: Padding(
        padding: const EdgeInsets.only(top: 10, left: 10, right: 10),
        child: Column(
          spacing: 5,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Chat Threads",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  context.watch<ConvoProvider>().currentConvoId.isNotEmpty
                      ? IconButton(
                        onPressed: () {
                          context.read<ConvoProvider>().clearCurrentConvo();
                          context.read<ConvoProvider>().setCurrentConvoId("");
                          Scaffold.of(context).closeEndDrawer();
                        },
                        icon: Icon(
                          Icons.add_comment,
                          color: omniDarkCyan,
                          size: 25,
                        ),
                      )
                      : SizedBox.shrink(),
                ],
              ),
            ),
            Expanded(
              child:
                  conversations.isEmpty
                      ? Center(
                        child: Text(
                          "No chat threads available.",
                          style: TextStyle(fontSize: 16, color: Colors.grey),
                        ),
                      )
                      : SingleChildScrollView(
                        child: Column(
                          spacing: 10,
                          children:
                              conversations.map((convo) {
                                return ChatThreadRect(
                                  title: convo.title,
                                  isCurrent:
                                      convo.id ==
                                      context
                                          .watch<ConvoProvider>()
                                          .currentConvoId,
                                  onChangeThread:
                                      () => {
                                        context
                                            .read<ConvoProvider>()
                                            .changeCurrentConvo(convo.id),
                                        Scaffold.of(context).closeEndDrawer(),
                                      },
                                );
                              }).toList(),
                        ),
                      ),
            ),
          ],
        ),
      ),
    );
  }
}
