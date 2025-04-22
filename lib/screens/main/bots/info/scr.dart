import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lottie/lottie.dart';
import 'package:omni_chat/apis/bot/controllers/create.dart';
import 'package:omni_chat/apis/bot/controllers/delete.dart';
import 'package:omni_chat/apis/bot/controllers/update.dart';
import 'package:omni_chat/constants/color.dart';
import 'package:omni_chat/providers/bot.dart';
import 'package:omni_chat/widgets/button/common_btn.dart';
import 'package:omni_chat/widgets/button/ico_txt_btn.dart';
import 'package:omni_chat/widgets/rectangle/knowledge_rect.dart';
import 'package:omni_chat/widgets/text/info_field.dart';
import 'package:omni_chat/widgets/text/input_field.dart';
import 'package:omni_chat/widgets/text/input_header.dart';
import 'package:omni_chat/widgets/popup/publish_bot.dart';
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

  String screenState = "";
  final ValueNotifier<bool> loading = ValueNotifier(false);

  @override
  void initState() {
    super.initState();
    if (widget.id == null) {
      screenState = "create";
      nameCtrlr = TextEditingController();
      instructionCtrlr = TextEditingController();
      descriptionCtrlr = TextEditingController();
    } else {
      screenState = "info";
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
      });
    }
  }

  @override
  void dispose() {
    nameCtrlr.dispose();
    instructionCtrlr.dispose();
    descriptionCtrlr.dispose();
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          screenState == "create" ? "Create New Bot" : "Bot's Information",
        ),
        actions: [
          (screenState != "create" && !context.watch<BotProvider>().botLoading)
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
      ),
      body: SizedBox(
        height: double.infinity,
        child: Form(
          key: editBotFormKey,
          child: Stack(
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 20, right: 20, bottom: 70),
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      const Icon(Icons.smart_toy_outlined, size: 40),
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
                                    context.watch<BotProvider>().botLoading,
                              )
                              : InputField(
                                controller: nameCtrlr,
                                placeholder: "Bot's Name",
                                validateFunc: Validatorless.required(
                                  "Name of the bot is required",
                                ),
                                formKey: editBotFormKey,
                              ),
                          InputHeader(title: "Instructions", isRequired: false),
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
                                    context.watch<BotProvider>().botLoading,
                              )
                              : InputField(
                                controller: instructionCtrlr,
                                placeholder: "Instruct the bot how to reply",
                                minLns: 3,
                                maxLns: 5,
                              ),
                          InputHeader(title: "Description", isRequired: false),
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
                                    context.watch<BotProvider>().botLoading,
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
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                InputHeader(title: "Knowledges"),
                                TextButton(
                                  onPressed: () {},
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    spacing: 10,
                                    children: [
                                      Text(
                                        "Import",
                                        style: TextStyle(color: omniDarkCyan),
                                      ),
                                      Icon(Icons.add, color: omniDarkBlue),
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
                                  if (editBotFormKey.currentState!.validate()) {
                                    FocusManager.instance.primaryFocus
                                        ?.unfocus();
                                    onCreateBot();
                                  }
                                } else if (screenState == "edit") {
                                  if (editBotFormKey.currentState!.validate()) {
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
    );
  }
}
