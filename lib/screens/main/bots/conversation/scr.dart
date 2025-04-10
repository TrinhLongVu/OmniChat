import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:omni_chat/apis/chat/controllers/send_msg.dart';
import 'package:omni_chat/constants/color.dart';
import 'package:omni_chat/models/prompt.dart';
import 'package:omni_chat/providers/chat.dart';
import 'package:omni_chat/providers/convo.dart';
import 'package:omni_chat/providers/prompt.dart';
import 'package:omni_chat/screens/main/bots/conversation/convo_box.dart';
import 'package:omni_chat/screens/main/bots/conversation/prompt_modal.dart';
import 'package:omni_chat/screens/main/bots/conversation/thread_drawer.dart';
import 'package:omni_chat/widgets/info_field.dart';
import 'package:omni_chat/widgets/popup/prompt_info.dart';
import 'package:omni_chat/widgets/prompt_slash.dart';
import 'package:omni_chat/widgets/shimmer/shimmer_convo_box.dart';
import 'package:provider/provider.dart';

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

  bool showPromptTooltip = false;

  @override
  void initState() {
    super.initState();
    context.read<PromptProvider>().loadSlashList();
    context.read<ConvoProvider>().initConvoList();
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
    var promptToSend = context.read<ChatProvider>().msgPrompt;
    var msgContentToSend = msgCtrlr.text;
    if (promptToSend.content.isNotEmpty) {
      msgContentToSend = "${promptToSend.content}\n${msgCtrlr.text}";
    }
    if (msgCtrlr.text.isNotEmpty) {
      await sendMessage(
        context.read<ConvoProvider>().currentConvoId,
        msgContentToSend,
      );
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
                "Omni Chat Bot",
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
              context.read<ConvoProvider>().loadConvoList();
              _scaffoldKey.currentState!.openEndDrawer();
            },
            icon: Icon(Icons.message),
          ),
        ],
      ),
      endDrawer: ThreadDrawer(
        conversations: context.watch<ConvoProvider>().convoList,
      ),
      body: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [omniDarkCyan, omniLightCyan],
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
                      context.watch<ConvoProvider>().currentConvoId == ""
                          ? Container(
                            width: double.infinity,
                            padding: EdgeInsets.all(15),
                            decoration: BoxDecoration(),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              spacing: 15,
                              children: [
                                Icon(
                                  OctIcons.copilot,
                                  size: 150,
                                  color: omniMilk,
                                ),
                                Text(
                                  "Start a new conversation by typing your message below",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: omniMilk,
                                  ),
                                ),
                                Text(
                                  "Or",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: omniMilk,
                                  ),
                                ),
                                RichText(
                                  textAlign: TextAlign.center,
                                  text: TextSpan(
                                    style: TextStyle(
                                      fontSize: 18,
                                      color: omniMilk,
                                      fontWeight: FontWeight.bold,
                                      fontFamily:
                                          GoogleFonts.poppins().fontFamily,
                                    ),
                                    children: [
                                      TextSpan(
                                        text:
                                            'Select a thread from the drawer  ',
                                      ),
                                      WidgetSpan(
                                        alignment: PlaceholderAlignment.middle,
                                        child: Icon(
                                          Icons.message,
                                          size: 25,
                                          color: omniMilk,
                                        ),
                                      ),
                                      TextSpan(
                                        text: '  to continue your conversation',
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          )
                          : context
                              .watch<ConvoProvider>()
                              .currentConvoHistoryList
                              .isEmpty
                          ? Column(
                            spacing: 10,
                            children: List.generate(
                              4,
                              (index) => ShimmerConvoBox(
                                isBot: index % 2 == 0 ? false : true,
                              ),
                            ),
                          )
                          : Column(
                            spacing: 10,
                            children:
                                context
                                    .watch<ConvoProvider>()
                                    .currentConvoHistoryList
                                    .map((convo) {
                                      return Column(
                                        spacing: 10,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          ConvoBox(
                                            message: convo.query,
                                            isBot: false,
                                          ),
                                          ConvoBox(
                                            message: convo.answer,
                                            isBot: true,
                                          ),
                                        ],
                                      );
                                    })
                                    .toList(),
                          ),
                      SizedBox(height: viewport.height * .25),
                    ],
                  ),
                ),
              ),
              context.watch<ChatProvider>().msgPrompt.id != ""
                  ? Positioned(
                    left: 5,
                    right: 5,
                    bottom: 120,
                    child: Container(
                      padding: EdgeInsets.all(15),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        spacing: 15,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Flexible(
                                child: Row(
                                  spacing: 10,
                                  children: [
                                    Icon(Icons.note),
                                    Expanded(
                                      child: Text(
                                        context
                                            .watch<ChatProvider>()
                                            .msgPrompt
                                            .title,
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                        ),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        softWrap: true,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Row(
                                spacing: 10,
                                children: [
                                  IconButton(
                                    onPressed: () {
                                      showDialog(
                                        context: context,
                                        builder:
                                            (context) => PromptInfoPopUp(
                                              used: true,
                                              prompt:
                                                  context
                                                      .watch<ChatProvider>()
                                                      .msgPrompt,
                                            ),
                                      );
                                    },
                                    iconSize: 20.0,
                                    padding: EdgeInsets.all(5),
                                    constraints: const BoxConstraints(),
                                    style: const ButtonStyle(
                                      tapTargetSize:
                                          MaterialTapTargetSize.shrinkWrap,
                                    ),
                                    icon: Icon(Icons.info_outline),
                                  ),
                                  IconButton(
                                    onPressed: () {
                                      context.read<ChatProvider>().setPrompt(
                                        Prompt.placeholder(),
                                      );
                                    },
                                    iconSize: 20.0,
                                    padding: EdgeInsets.all(5),
                                    constraints: const BoxConstraints(),
                                    style: const ButtonStyle(
                                      tapTargetSize:
                                          MaterialTapTargetSize.shrinkWrap,
                                    ),
                                    icon: const Icon(Icons.close),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          context.watch<ChatProvider>().msgPrompt.description !=
                                  ""
                              ? Text(
                                context
                                    .watch<ChatProvider>()
                                    .msgPrompt
                                    .description
                                    .toString(),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                softWrap: true,
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.black45,
                                ),
                                textAlign: TextAlign.start,
                              )
                              : SizedBox.shrink(),
                          InfoField(
                            infoText:
                                context
                                    .watch<ChatProvider>()
                                    .msgPrompt
                                    .content
                                    .toString(),
                            lineNum: 3,
                          ),
                        ],
                      ),
                    ),
                  )
                  : SizedBox.shrink(),
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
                          hintText:
                              context.watch<ChatProvider>().msgPrompt.id != ""
                                  ? "Asking with promt activated"
                                  : "Ask me anthing or type '/' to use a prompt",
                          hintStyle: TextStyle(color: Colors.grey),
                          border: OutlineInputBorder(
                            borderSide: BorderSide.none,
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        onChanged:
                            (value) => {
                              context.read<ChatProvider>().message = value,
                              if (msgCtrlr.text == "/")
                                {
                                  setState(() {
                                    showPromptTooltip = true;
                                  }),
                                }
                              else
                                {
                                  setState(() {
                                    showPromptTooltip = false;
                                  }),
                                },
                            },
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
                                  Text(
                                    "${context.watch<ConvoProvider>().currentToken}",
                                  ),
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
              showPromptTooltip
                  ? Positioned(
                    left: 20,
                    right: 20,
                    bottom: 110,
                    child: Container(
                      height: viewport.height * 0.3,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(width: 0.5),
                      ),
                      child: SingleChildScrollView(
                        child: Column(
                          children:
                              context
                                  .watch<PromptProvider>()
                                  .slashPrompts
                                  .map(
                                    (prompt) => PromptSlash(
                                      title: prompt.title,
                                      onUse: () {
                                        context.read<ChatProvider>().setPrompt(
                                          prompt,
                                        );
                                        msgCtrlr.clear();
                                        setState(() {
                                          showPromptTooltip = false;
                                        });
                                      },
                                    ),
                                  )
                                  .toList(),
                        ),
                      ),
                    ),
                  )
                  : SizedBox.shrink(),
            ],
          ),
        ),
      ),
    );
  }
}
