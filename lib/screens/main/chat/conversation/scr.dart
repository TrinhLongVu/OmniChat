import 'package:flutter/material.dart';
import 'package:omni_chat/constants/color.dart';
import 'package:omni_chat/screens/main/chat/conversation/convo_box.dart';

class ConversationScreen extends StatelessWidget {
  final TextEditingController msgCtrlr = TextEditingController();
  ConversationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        titleSpacing: -10,
        title: Row(
          children: [
            Icon(Icons.circle, size: 50),
            Padding(
              padding: const EdgeInsets.only(left: 8),
              child: Text(
                "StarryAI Bot",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
              ),
            ),
          ],
        ),
        backgroundColor: Colors.white,
      ),
      body: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xffE7E7FF), Color(0xffF8F8FF)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Stack(
          children: [
            SingleChildScrollView(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(25),
                    child: Icon(Icons.circle, size: 200),
                  ),
                  Column(
                    spacing: 10,
                    children: List.generate(
                      6,
                      (index) => Column(
                        spacing: 10,
                        children: [
                          ConvoBox(
                            message:
                                "Hello, I'm your new friend, StarryAI Bot. How can I help you today?",
                            isBot: true,
                          ),
                          ConvoBox(
                            message:
                                "Can you help me write a blog post about my new book?",
                            isBot: false,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Positioned(
              left: 15,
              right: 15,
              bottom: 15,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withValues(alpha: .5),
                      spreadRadius: 2,
                      blurRadius: 5,
                      offset: Offset(0, 3),
                    ),
                  ],
                ),
                child: TextField(
                  controller: msgCtrlr,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
                    hintText: "Type your message...",
                    hintStyle: TextStyle(color: Colors.grey),
                    suffixIcon: IconButton(
                      icon: Icon(Icons.send_rounded, color: omniViolet),
                      onPressed: () {
                        if (msgCtrlr.text.isNotEmpty) {
                          msgCtrlr.clear();
                        }
                      },
                    ),
                    border: OutlineInputBorder(
                      borderSide: BorderSide.none,
                      borderRadius: BorderRadius.circular(10),
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
