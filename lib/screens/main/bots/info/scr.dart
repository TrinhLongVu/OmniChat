import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:lottie/lottie.dart';
import 'package:omni_chat/apis/bot/controllers/ask.dart';
import 'package:omni_chat/apis/bot/controllers/create.dart';
import 'package:omni_chat/apis/bot/controllers/delete.dart';
import 'package:omni_chat/apis/bot/controllers/update.dart';
import 'package:omni_chat/constants/color.dart';
import 'package:omni_chat/providers/bot.dart';
import 'package:omni_chat/providers/convo.dart';
import 'package:omni_chat/providers/prompt.dart';
import 'package:omni_chat/widgets/button/common_btn.dart';
import 'package:omni_chat/widgets/button/fit_ico_btn.dart';
import 'package:omni_chat/widgets/button/ico_txt_btn.dart';
import 'package:omni_chat/widgets/popup/knowledge_import.dart';
import 'package:omni_chat/widgets/rectangle/chat_box.dart';
import 'package:omni_chat/widgets/rectangle/convo_box.dart';
import 'package:omni_chat/widgets/rectangle/knowledge_rect.dart';
import 'package:omni_chat/widgets/tab_item.dart';
import 'package:omni_chat/widgets/text/info_field.dart';
import 'package:omni_chat/widgets/text/input_field.dart';
import 'package:omni_chat/widgets/text/input_header.dart';
import 'package:omni_chat/widgets/popup/publish_bot.dart';
import 'package:omni_chat/widgets/text/prompt_slash.dart';
import 'package:provider/provider.dart';
import 'package:quickalert/quickalert.dart';
import 'package:validatorless/validatorless.dart';

class BotInfoScreen extends StatefulWidget {
  final String? id;

  const BotInfoScreen({super.key, this.id});

  @override
  State<BotInfoScreen> createState() => _BotInfoScreenState();
}

class _BotInfoScreenState extends State<BotInfoScreen> {
  final editBotFormKey = GlobalKey<FormState>();
  late TextEditingController nameCtrlr;
  late TextEditingController instructionCtrlr;
  late TextEditingController descriptionCtrlr;
  late TextEditingController chatCtrlr;
  String screenState = "";
  final ValueNotifier<bool> loading = ValueNotifier(false);
  bool showPromptTooltip = false;

  @override
  void initState() {
    super.initState();
    if (widget.id == null) {
      screenState = "create";
      nameCtrlr = TextEditingController();
      instructionCtrlr = TextEditingController();
      descriptionCtrlr = TextEditingController();
      chatCtrlr = TextEditingController();
    } else {
      screenState = "info";
      chatCtrlr = TextEditingController();
      WidgetsBinding.instance.addPostFrameCallback((_) {
        context.read<BotProvider>().loadInfo(
          id: widget.id!,
          onSuccess: () {
            nameCtrlr = TextEditingController(
              text: context.read<BotProvider>().currentBot.name,
            );
            instructionCtrlr = TextEditingController(
              text: context.read<BotProvider>().currentBot.instruction,
            );
            descriptionCtrlr = TextEditingController(
              text: context.read<BotProvider>().currentBot.description,
            );
          },
        );
        context.read<BotProvider>().clearPreviewBotConvo();
      });
    }
  }

  @override
  void dispose() {
    nameCtrlr.dispose();
    instructionCtrlr.dispose();
    descriptionCtrlr.dispose();
    chatCtrlr.dispose();
    super.dispose();
  }

  Future<void> onCreateBot() async {
    loading.value = true;
    await createBot((
      name: nameCtrlr.text,
      instruction: instructionCtrlr.text,
      description: descriptionCtrlr.text,
      onError: () {
        loading.value = false;
      },
    ));
  }

  Future<void> onDeleteBot() async {
    loading.value = true;
    await deleteBot((
      id: widget.id!,
      onError: () {
        loading.value = false;
      },
    ));
  }

  Future<void> onUpdateBot() async {
    loading.value = true;
    await updateBot((
      id: widget.id!,
      name: nameCtrlr.text,
      instruction: instructionCtrlr.text,
      description: descriptionCtrlr.text,
      onComplete: () {
        context.read<BotProvider>().loadInfo(id: widget.id!, onSuccess: () {});
        loading.value = false;
      },
    ));
  }

  Future<void> onPreviewChat() async {
    var promptToSend = context.read<ConvoProvider>().currentPrompt;
    var msgContentToSend = chatCtrlr.text;
    if (promptToSend.content.isNotEmpty) {
      msgContentToSend = "${promptToSend.content}\n${chatCtrlr.text}";
    }
    chatCtrlr.clear();
    FocusManager.instance.primaryFocus?.unfocus();
    context.read<BotProvider>().previewAskBot(msgContentToSend);
    context.read<ConvoProvider>().clearPrompt();
    await askBot((botId: widget.id!, msgContent: msgContentToSend));
  }

  @override
  Widget build(BuildContext context) {
    Size viewport = MediaQuery.of(context).size;
    return DefaultTabController(
      length: screenState == "create" ? 1 : 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            screenState == "create" ? "Create New Bot" : "Bot's Information",
          ),
          actions: [
            (screenState != "create" &&
                    !context.watch<BotProvider>().botLoading)
                ? IconButton(
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (context) => BotPublishingPopUp(),
                    );
                  },
                  icon: Icon(Icons.lan_sharp, color: omniDarkBlue),
                )
                : Container(),
          ],
          bottom:
              screenState == "create"
                  ? null
                  : PreferredSize(
                    preferredSize: const Size.fromHeight(40),
                    child: ClipRRect(
                      borderRadius: const BorderRadius.all(Radius.circular(10)),
                      child: Container(
                        height: 40,
                        margin: const EdgeInsets.symmetric(horizontal: 20),
                        decoration: BoxDecoration(
                          borderRadius: const BorderRadius.all(
                            Radius.circular(10),
                          ),
                          color: omniLightCyan,
                        ),
                        child: const TabBar(
                          indicatorSize: TabBarIndicatorSize.tab,
                          dividerColor: Colors.transparent,
                          indicator: BoxDecoration(
                            color: omniDarkBlue,
                            borderRadius: BorderRadius.all(Radius.circular(10)),
                          ),
                          labelColor: Colors.white,
                          unselectedLabelColor: Colors.black54,
                          tabs: [
                            TabItem(title: 'Information'),
                            TabItem(title: 'Preview'),
                          ],
                        ),
                      ),
                    ),
                  ),
        ),
        body: TabBarView(
          children: [
            SizedBox(
              height: double.infinity,
              child: Form(
                key: editBotFormKey,
                child: Stack(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(
                        left: 20,
                        right: 20,
                        bottom: 70,
                      ),
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 15),
                              child: const Icon(
                                Icons.smart_toy_outlined,
                                size: 40,
                              ),
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              spacing: 8,
                              children: [
                                InputHeader(
                                  title: "Name",
                                  isRequired: !(screenState == "info"),
                                ),
                                (screenState == "info")
                                    ? InfoField(
                                      infoText:
                                          context
                                              .watch<BotProvider>()
                                              .currentBot
                                              .name,
                                      fontSz: 16,
                                      shimmerizing:
                                          context
                                              .watch<BotProvider>()
                                              .botLoading,
                                    )
                                    : InputField(
                                      controller: nameCtrlr,
                                      placeholder: "Bot's Name",
                                      validateFunc: Validatorless.required(
                                        "Name of the bot is required",
                                      ),
                                      formKey: editBotFormKey,
                                    ),
                                InputHeader(
                                  title: "Instructions",
                                  isRequired: false,
                                ),
                                (screenState == "info")
                                    ? InfoField(
                                      infoText:
                                          context
                                              .watch<BotProvider>()
                                              .currentBot
                                              .instruction ??
                                          "",
                                      fontSz: 16,
                                      lineNum: 4,
                                      shimmerizing:
                                          context
                                              .watch<BotProvider>()
                                              .botLoading,
                                    )
                                    : InputField(
                                      controller: instructionCtrlr,
                                      placeholder:
                                          "Instruct the bot how to reply",
                                      minLns: 3,
                                      maxLns: 5,
                                    ),
                                InputHeader(
                                  title: "Description",
                                  isRequired: false,
                                ),
                                (screenState == "info")
                                    ? InfoField(
                                      infoText:
                                          context
                                              .watch<BotProvider>()
                                              .currentBot
                                              .description ??
                                          "",
                                      fontSz: 16,
                                      lineNum: 3,
                                      shimmerizing:
                                          context
                                              .watch<BotProvider>()
                                              .botLoading,
                                    )
                                    : InputField(
                                      controller: descriptionCtrlr,
                                      placeholder:
                                          "Description of how you would use the bot for",
                                      minLns: 3,
                                      maxLns: 5,
                                    ),
                                if (!context.watch<BotProvider>().botLoading &&
                                    screenState == "info") ...[
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      InputHeader(title: "Knowledges"),
                                      TextButton(
                                        onPressed: () {
                                          showDialog(
                                            context: context,
                                            builder:
                                                (context) =>
                                                    KnowledgeImportPopUp(),
                                          );
                                        },
                                        child: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          spacing: 10,
                                          children: [
                                            Text(
                                              "Import",
                                              style: TextStyle(
                                                color: omniDarkCyan,
                                              ),
                                            ),
                                            Icon(
                                              Icons.add,
                                              color: omniDarkBlue,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                  context
                                          .watch<BotProvider>()
                                          .currentBotKnowledges
                                          .isEmpty
                                      ? Align(
                                        alignment: Alignment.center,
                                        child: Text(
                                          "No Imported Knowledges Yet",
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black54,
                                          ),
                                        ),
                                      )
                                      : Column(
                                        spacing: 10,
                                        children:
                                            context
                                                .watch<BotProvider>()
                                                .currentBotKnowledges
                                                .map((knowledge) {
                                                  return KnowledgeRect(
                                                    knowledge: knowledge,
                                                    imported: true,
                                                  );
                                                })
                                                .toList(),
                                      ),
                                ],
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    !context.watch<BotProvider>().botLoading
                        ? Positioned(
                          right: 20,
                          left: 20,
                          bottom: 5,
                          child: ValueListenableBuilder<bool>(
                            valueListenable: loading,
                            builder: (context, loading, _) {
                              return loading
                                  ? Lottie.asset(
                                    "assets/anims/loading.json",
                                    width: 120,
                                    height: 80,
                                  )
                                  : (screenState == "info")
                                  ? Row(
                                    spacing: 10,
                                    children: [
                                      IcoTxtBtn(
                                        title: "Edit",
                                        onTap: () {
                                          setState(() {
                                            screenState = "edit";
                                          });
                                        },
                                      ),
                                      IcoTxtBtn(
                                        title: "Delete",
                                        bgColor: Colors.red,
                                        onTap: () {
                                          QuickAlert.show(
                                            context: context,
                                            type: QuickAlertType.confirm,
                                            text:
                                                "Are you sure you want to delete this bot?",
                                            onCancelBtnTap: () => context.pop(),
                                            onConfirmBtnTap: () {
                                              context.pop();
                                              onDeleteBot();
                                            },
                                          );
                                        },
                                      ),
                                    ],
                                  )
                                  : CommonBtn(
                                    title: "Save",
                                    onTap: () {
                                      if (screenState == "create") {
                                        if (editBotFormKey.currentState!
                                            .validate()) {
                                          FocusManager.instance.primaryFocus
                                              ?.unfocus();
                                          onCreateBot();
                                        }
                                      } else if (screenState == "edit") {
                                        if (editBotFormKey.currentState!
                                            .validate()) {
                                          QuickAlert.show(
                                            context: context,
                                            type: QuickAlertType.confirm,
                                            text:
                                                "Are you sure you want to update this bot?",
                                            onCancelBtnTap: () => context.pop(),
                                            onConfirmBtnTap: () async {
                                              FocusManager.instance.primaryFocus
                                                  ?.unfocus();
                                              context.pop();
                                              FocusManager.instance.primaryFocus
                                                  ?.unfocus();
                                              await onUpdateBot();
                                              setState(() {
                                                screenState = "info";
                                              });
                                            },
                                          );
                                        }
                                      }
                                    },
                                  );
                            },
                          ),
                        )
                        : SizedBox.shrink(),
                  ],
                ),
              ),
            ),
            if (screenState != 'create')
              Container(
                width: double.infinity,
                decoration: BoxDecoration(),
                child: SizedBox(
                  height: double.infinity,
                  child: Stack(
                    children: [
                      GestureDetector(
                        onTap:
                            () => FocusManager.instance.primaryFocus?.unfocus(),
                        child: SingleChildScrollView(
                          child: Column(
                            children: [
                              SizedBox(height: viewport.height * .03),
                              context
                                      .watch<BotProvider>()
                                      .previewBotConvoHistoryList
                                      .isEmpty
                                  ? Container(
                                    width: double.infinity,
                                    padding: EdgeInsets.all(15),
                                    decoration: BoxDecoration(),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      spacing: 15,
                                      children: [
                                        Icon(
                                          Icons.smart_toy,
                                          size: 150,
                                          color: omniDarkBlue,
                                        ),
                                        Text(
                                          "Start a conversation to test this bot",
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                            color: omniDarkBlue,
                                          ),
                                        ),
                                      ],
                                    ),
                                  )
                                  : Column(
                                    spacing: 10,
                                    children:
                                        context
                                            .watch<BotProvider>()
                                            .previewBotConvoHistoryList
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
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
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
                                            onTap: () {},
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
                          isPreview: true,
                          ctrlr: chatCtrlr,
                          focusNode: FocusNode(),
                          onType: (value) {
                            if (chatCtrlr.text == "/") {
                              setState(() {
                                showPromptTooltip = true;
                              });
                            } else {
                              setState(() {
                                showPromptTooltip = false;
                              });
                            }
                          },
                          onSendMessage: () {
                            if (chatCtrlr.text.isNotEmpty) {
                              onPreviewChat();
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
                                                context
                                                    .read<ConvoProvider>()
                                                    .setPrompt(prompt);
                                                chatCtrlr.clear();
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
          ],
        ),
      ),
    );
  }
}
