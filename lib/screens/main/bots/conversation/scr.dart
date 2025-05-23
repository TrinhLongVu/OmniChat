import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:omni_chat/apis/chat/controllers/send_msg.dart';
import 'package:omni_chat/constants/color.dart';
import 'package:omni_chat/models/prompt.dart';
import 'package:omni_chat/providers/bot.dart';
import 'package:omni_chat/providers/convo.dart';
import 'package:omni_chat/providers/prompt.dart';
import 'package:omni_chat/services/ad_mob.dart';
import 'package:omni_chat/widgets/button/fit_ico_btn.dart';
import 'package:omni_chat/widgets/popup/agent_change.dart';
import 'package:omni_chat/widgets/rectangle/chat_box.dart';
import 'package:omni_chat/widgets/rectangle/convo_box.dart';
import 'package:omni_chat/screens/main/bots/conversation/thread_drawer.dart';
import 'package:omni_chat/widgets/text/info_field.dart';
import 'package:omni_chat/widgets/popup/prompt_info.dart';
import 'package:omni_chat/widgets/text/prompt_slash.dart';
import 'package:omni_chat/widgets/shimmer/shimmer_convo_box.dart';
import 'package:provider/provider.dart';
import 'package:quickalert/quickalert.dart';

final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

class ConversationScreen extends StatefulWidget {
  const ConversationScreen({super.key, this.id});

  final String? id;

  @override
  State<ConversationScreen> createState() => _ConversationScreenState();
}

class _ConversationScreenState extends State<ConversationScreen> {
  final TextEditingController msgCtrlr = TextEditingController();
  final FocusNode focusNod = FocusNode();
  final ScrollController scrollCtrlr = ScrollController();

  bool showPromptTooltip = false;
  bool isOfficial = true;
  String botName = "Loading...";

  @override
  void initState() {
    super.initState();
    AdMobService().showInterstitialAdIfAllowed();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ConvoProvider>().changeCurrentConvo("");
      context.read<ConvoProvider>().clearCurrentConvo();
    });
    if (widget.id != null) {
      isOfficial = false;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        context.read<BotProvider>().loadInfo(
          id: widget.id!,
          onSuccess: () {
            setState(() {
              botName = context.read<BotProvider>().currentBot.name;
            });
          },
        );
      });
    } else {
      setState(() {
        botName = "Omni Chat Bot";
      });
    }
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

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final convoList = context.watch<ConvoProvider>().currentConvoHistoryList;
    if (convoList.isNotEmpty) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (scrollCtrlr.hasClients) {
          scrollCtrlr.animateTo(
            scrollCtrlr.position.maxScrollExtent,
            duration: const Duration(milliseconds: 1000),
            curve: Curves.easeIn,
          );
        }
      });
    }
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

  Future<void> onSendMessage() async {
    if (isOfficial) {
      if (context.read<ConvoProvider>().currentToken <= 0) {
        QuickAlert.show(
          context: context,
          type: QuickAlertType.error,
          text: "You are out of tokens.",
        );
        return;
      }
    } else {
      if (context.read<ConvoProvider>().currentToken <= 4) {
        QuickAlert.show(
          context: context,
          type: QuickAlertType.error,
          text: "You need at least 5 tokens to send a message.",
        );
        return;
      }
    }
    bool newThread = false;
    if (context.read<ConvoProvider>().currentConvoId.isEmpty) {
      newThread = true;
      context.read<ConvoProvider>().setCurrentConvoId(
        "${DateTime.now().millisecondsSinceEpoch}",
      );
      context.read<ConvoProvider>().clearCurrentConvo();
    }
    var promptToSend = context.read<ConvoProvider>().currentPrompt;
    var msgContentToSend = msgCtrlr.text;
    if (promptToSend.content.isNotEmpty) {
      msgContentToSend = "${promptToSend.content}\n${msgCtrlr.text}";
    }
    msgCtrlr.clear();
    FocusManager.instance.primaryFocus?.unfocus();
    context.read<ConvoProvider>().askChat(msgContentToSend);
    context.read<ConvoProvider>().clearPrompt();
    await sendMessage((
      official: isOfficial,
      convoId: newThread ? "" : context.read<ConvoProvider>().currentConvoId,
      msgContent: msgContentToSend,
      onError: () {
        if (newThread) {
          context.read<ConvoProvider>().setCurrentConvoId("");
          context.read<ConvoProvider>().clearCurrentConvo();
        } else {
          context.read<ConvoProvider>().removeLastMessage();
        }
        QuickAlert.show(
          context: context,
          type: QuickAlertType.error,
          text: "Failed to send message! Please try again later.",
        );
      },
    ));
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
                botName,
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
              ),
            ),
          ],
        ),
        backgroundColor: Colors.white,
        actions: [
          if (isOfficial) ...[
            IconButton(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) => AgentChangePopUp(),
                );
              },
              icon: Icon(Icons.smart_toy, color: omniDarkBlue),
            ),
            IconButton(
              onPressed: () {
                context.read<ConvoProvider>().loadConvoList();
                _scaffoldKey.currentState!.openEndDrawer();
              },
              icon: Icon(BoxIcons.bxs_message_alt_detail, color: omniDarkBlue),
            ),
          ] else
            ...[],
        ],
      ),
      endDrawer:
          isOfficial
              ? ThreadDrawer(
                conversations: context.watch<ConvoProvider>().convoList,
              )
              : null,
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
                                  isOfficial
                                      ? OctIcons.copilot
                                      : Icons.smart_toy,
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
                                if (isOfficial) ...[
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
                                          alignment:
                                              PlaceholderAlignment.middle,
                                          child: FitIconBtn(
                                            onTap: () {
                                              context
                                                  .read<ConvoProvider>()
                                                  .loadConvoList();
                                              _scaffoldKey.currentState!
                                                  .openEndDrawer();
                                            },
                                            icon:
                                                BoxIcons.bxs_message_alt_detail,
                                            iconColor: omniMilk,
                                          ),
                                        ),
                                        TextSpan(
                                          text:
                                              '  to continue your conversation',
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
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
              context.watch<ConvoProvider>().currentPrompt.id != ""
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
                                    Icon(FontAwesome.note_sticky_solid),
                                    Expanded(
                                      child: Text(
                                        context
                                            .watch<ConvoProvider>()
                                            .currentPrompt
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
                                  FitIconBtn(
                                    onTap: () {
                                      showDialog(
                                        context: context,
                                        builder:
                                            (context) => PromptInfoPopUp(
                                              used: true,
                                              prompt:
                                                  context
                                                      .watch<ConvoProvider>()
                                                      .currentPrompt,
                                            ),
                                      );
                                    },
                                    icon: Icons.info_outline,
                                  ),
                                  FitIconBtn(
                                    onTap: () {
                                      context.read<ConvoProvider>().setPrompt(
                                        Prompt.placeholder(),
                                      );
                                    },
                                    icon: Icons.close,
                                  ),
                                ],
                              ),
                            ],
                          ),
                          context
                                      .watch<ConvoProvider>()
                                      .currentPrompt
                                      .description !=
                                  ""
                              ? Text(
                                context
                                    .watch<ConvoProvider>()
                                    .currentPrompt
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
                                    .watch<ConvoProvider>()
                                    .currentPrompt
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
                child: ChatBox(
                  ctrlr: msgCtrlr,
                  focusNode: focusNod,
                  onType: (value) {
                    if (msgCtrlr.text == "/") {
                      setState(() {
                        showPromptTooltip = true;
                      });
                    } else {
                      setState(() {
                        showPromptTooltip = false;
                      });
                    }
                  },
                  onSendMessage: () async {
                    if (msgCtrlr.text.isNotEmpty) {
                      await onSendMessage();
                    }
                  },
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
                                        context.read<ConvoProvider>().setPrompt(
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
