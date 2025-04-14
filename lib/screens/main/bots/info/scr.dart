import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lottie/lottie.dart';
import 'package:omni_chat/apis/bot/controllers/create.dart';
import 'package:omni_chat/apis/bot/controllers/delete.dart';
import 'package:omni_chat/apis/bot/controllers/get_info.dart';
import 'package:omni_chat/apis/bot/controllers/update.dart';
import 'package:omni_chat/constants/color.dart';
import 'package:omni_chat/models/bot.dart';
import 'package:omni_chat/widgets/button/common_btn.dart';
import 'package:omni_chat/widgets/button/ico_txt_btn.dart';
import 'package:omni_chat/widgets/text/info_field.dart';
import 'package:omni_chat/widgets/text/input_field.dart';
import 'package:omni_chat/widgets/text/input_header.dart';
import 'package:omni_chat/widgets/popup/publish_bot.dart';
import 'package:quickalert/quickalert.dart';
import 'package:validatorless/validatorless.dart';

final editBotFormKey = GlobalKey<FormState>();

class BotInfoScreen extends StatefulWidget {
  final String? id;

  const BotInfoScreen({super.key, this.id});

  @override
  State<BotInfoScreen> createState() => _BotInfoScreenState();
}

class _BotInfoScreenState extends State<BotInfoScreen> {
  late TextEditingController nameController;
  late TextEditingController instructionController;
  late TextEditingController descriptionController;

  String screenState = "";
  bool isLoading = true;
  Bot? bot;
  String botNameInfoTxt = "";
  String botInstructionInfoTxt = "";
  String botDescriptionInfoTxt = "";
  final ValueNotifier<bool> loading = ValueNotifier(false);

  @override
  void initState() {
    super.initState();
    if (widget.id == null) {
      screenState = "create";
      nameController = TextEditingController();
      instructionController = TextEditingController();
      descriptionController = TextEditingController();
      isLoading = false;
    } else {
      screenState = "info";
      loadBotInfo();
    }
  }

  @override
  void dispose() {
    nameController.dispose();
    instructionController.dispose();
    descriptionController.dispose();
    super.dispose();
  }

  Future<void> loadBotInfo() async {
    Bot? botInfo = await getBotInfo((id: widget.id!));
    if (mounted && botInfo != null) {
      setState(() {
        bot = botInfo;
        botNameInfoTxt = bot!.name;
        botInstructionInfoTxt = bot!.instruction ?? "";
        botDescriptionInfoTxt = bot!.description ?? "";
        isLoading = false;
      });
      nameController = TextEditingController(text: bot?.name ?? "");
      instructionController = TextEditingController(
        text: bot?.instruction ?? "",
      );
      descriptionController = TextEditingController(
        text: bot?.description ?? "",
      );
    }
  }

  Future<void> onCreateBot() async {
    loading.value = true;
    await createBot((
      name: nameController.text,
      instruction: instructionController.text,
      description: descriptionController.text,
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

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return Scaffold(
        appBar: AppBar(title: const Text("Loading...")),
        body: const Center(child: CircularProgressIndicator()),
      );
    }
    return Scaffold(
      appBar: AppBar(
        title: Text(
          screenState == "create" ? "Create New Bot" : "Bot's Information",
        ),
        actions: [
          (screenState != "create")
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
                padding: const EdgeInsets.only(
                  left: 20,
                  right: 20,
                  top: 20,
                  bottom: 100,
                ),
                child: SingleChildScrollView(
                  child: Column(
                    spacing: 10,
                    children: [
                      const Icon(Icons.smart_toy_outlined, size: 80),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        spacing: 8,
                        children: [
                          InputHeader(title: "Name", isRequired: true),
                          (screenState == "info")
                              ? InfoField(infoText: botNameInfoTxt, fontSz: 16)
                              : InputField(
                                controller: nameController,
                                placeholder: "Bot's Name",
                                validateFunc: Validatorless.required(
                                  "Name of the bot is required",
                                ),
                                formKey: editBotFormKey,
                              ),
                          InputHeader(title: "Instructions", isRequired: false),
                          (screenState == "info")
                              ? InfoField(
                                infoText: botInstructionInfoTxt,
                                fontSz: 16,
                                lineNum: 4,
                              )
                              : InputField(
                                controller: instructionController,
                                placeholder: "Instruct the bot how to reply",
                                minLns: 2,
                                maxLns: 3,
                              ),
                          InputHeader(title: "Description", isRequired: false),
                          (screenState == "info")
                              ? InfoField(
                                infoText: botDescriptionInfoTxt,
                                fontSz: 16,
                                lineNum: 3,
                              )
                              : InputField(
                                controller: descriptionController,
                                placeholder:
                                    "Description of how you would use the bot for",
                                minLns: 2,
                                maxLns: 5,
                              ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              Positioned(
                right: 20,
                left: 20,
                bottom: 20,
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
                                FocusManager.instance.primaryFocus?.unfocus();
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
                                    updateBot((
                                      id: widget.id!,
                                      name: nameController.text,
                                      instruction: instructionController.text,
                                      description: descriptionController.text,
                                    ));
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
              ),
            ],
          ),
        ),
      ),
    );
  }
}
