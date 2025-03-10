import 'package:flutter/material.dart';
import 'package:omni_chat/constants/color.dart';
import 'package:omni_chat/widgets/chat_thread_rect.dart';

class ThreadDrawer extends StatelessWidget {
  const ThreadDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Colors.white,
      child: Padding(
        padding: const EdgeInsets.only(top: 10, left: 10, right: 10),
        child: Column(
          spacing: 5,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Chat Threads",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                IconButton(
                  onPressed: () {
                    Scaffold.of(context).closeEndDrawer();
                  },
                  icon: Icon(Icons.add_comment, color: omniDarkCyan, size: 25),
                ),
              ],
            ),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  spacing: 10,
                  children: List.generate(
                    20,
                    (index) => ChatThreadRect(
                      title:
                          "You: Can you help me write a blog post about my new book?",
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
