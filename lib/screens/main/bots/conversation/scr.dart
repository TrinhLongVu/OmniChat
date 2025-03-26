import 'package:flutter/material.dart';
import 'package:omni_chat/apis/chat/get_convos.dart';
import 'package:omni_chat/apis/chat/send_msg.dart';
import 'package:omni_chat/constants/color.dart';
import 'package:omni_chat/models/api/chat/get_convos_res.dart';
import 'package:omni_chat/screens/main/bots/conversation/convo_box.dart';
import 'package:omni_chat/screens/main/bots/conversation/prompt_modal.dart';
import 'package:omni_chat/screens/main/bots/conversation/thread_drawer.dart';
import 'package:uuid/uuid.dart';

final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

class ConversationScreen extends StatefulWidget {
  const ConversationScreen({super.key});

  @override
  State<ConversationScreen> createState() => _ConversationScreenState();
}

class _ConversationScreenState extends State<ConversationScreen> {
  final TextEditingController msgCtrlr = TextEditingController();
  final FocusNode focusNod = FocusNode();
  final ScrollController scrollCtrlr = ScrollController();

  List<ConvoItem> convoList = [];
  int tokenNum = 50;

  @override
  void initState() {
    super.initState();
    loadConvoList();
    focusNod.addListener(scrollToBottom);
  }

  @override
  void dispose() {
    focusNod.removeListener(scrollToBottom);
    msgCtrlr.dispose();
    focusNod.dispose();
    scrollCtrlr.dispose();
    super.dispose();
  }

  void scrollToBottom() {
    if (focusNod.hasFocus) {
      Future.delayed(Duration(milliseconds: 300), () {
        scrollCtrlr.animateTo(
          scrollCtrlr.position.maxScrollExtent,
          duration: Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      });
    }
  }

  Future<void> sendConvoMessage() async {
    if (msgCtrlr.text.isNotEmpty && tokenNum > 0) {
      var uuid = Uuid();
      String newConvoId = uuid.v4();
      await sendMessage(newConvoId, msgCtrlr.text);
      setState(() {
        tokenNum--;
        msgCtrlr.clear();
      });
    }
  }

  Future<void> loadConvoList() async {
    GetConvosResponse? convosResponse = await getConversations("gpt-4o-mini");
    if (mounted && convosResponse != null) {
      setState(() {
        convoList = convosResponse.items;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final viewport = MediaQuery.of(context).size;
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        titleSpacing: -10,
        title: Row(
          children: [
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
        actions: [
          IconButton(
            onPressed: () {
              showModalBottomSheet(
                context: context,
                isScrollControlled: true,
                builder: (context) {
                  return PromptModal();
                },
              );
            },
            icon: Icon(Icons.note),
          ),
          IconButton(
            onPressed: () {
              _scaffoldKey.currentState!.openEndDrawer();
            },
            icon: Icon(Icons.message),
          ),
        ],
      ),
      endDrawer: ThreadDrawer(conversations: convoList),
      body: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [omniLightCyan, omniMilk],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SizedBox(
          height: double.infinity,
          child: Stack(
            children: [
              GestureDetector(
                onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
                child: SingleChildScrollView(
                  controller: scrollCtrlr,
                  child: Column(
                    children: [
                      SizedBox(height: viewport.height * .03),
                      convoList.isEmpty
                          ? SizedBox()
                          : Column(
                            spacing: 10,
                            children: List.generate(
                              5,
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
                      SizedBox(height: viewport.height * .25),
                    ],
                  ),
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
                  child: Column(
                    children: [
                      TextField(
                        controller: msgCtrlr,
                        focusNode: focusNod,
                        textInputAction: TextInputAction.newline,
                        style: TextStyle(fontSize: 14),
                        minLines: 1,
                        maxLines: 3,
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.white,
                          hintText: "Type your message...",
                          hintStyle: TextStyle(color: Colors.grey),
                          border: OutlineInputBorder(
                            borderSide: BorderSide.none,
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(10, 0, 10, 8),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Row(
                                spacing: 4,
                                children: [
                                  Icon(
                                    Icons.token_rounded,
                                    color: omniDarkBlue,
                                  ),
                                  Text("$tokenNum"),
                                ],
                              ),
                            ),
                            Row(
                              spacing: 10,
                              children: [
                                IconButton(
                                  onPressed: () {},
                                  iconSize: 20,
                                  padding: EdgeInsets.all(5),
                                  constraints: const BoxConstraints(),
                                  style: const ButtonStyle(
                                    tapTargetSize:
                                        MaterialTapTargetSize.shrinkWrap,
                                  ),
                                  icon: const Icon(
                                    Icons.photo,
                                    color: omniDarkBlue,
                                  ),
                                ),
                                IconButton(
                                  onPressed: () {
                                    sendConvoMessage();
                                  },
                                  iconSize: 20,
                                  padding: EdgeInsets.all(5),
                                  constraints: const BoxConstraints(),
                                  style: const ButtonStyle(
                                    tapTargetSize:
                                        MaterialTapTargetSize.shrinkWrap,
                                  ),
                                  icon: const Icon(
                                    Icons.send_rounded,
                                    color: omniDarkBlue,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
