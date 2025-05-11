import 'package:flutter/material.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:omni_chat/apis/bot/controllers/publish_slack.dart';
import 'package:omni_chat/apis/bot/controllers/publish_telegram.dart';
import 'package:omni_chat/constants/publish_type.dart';
import 'package:omni_chat/providers/bot.dart';
import 'package:omni_chat/router/index.dart';
import 'package:omni_chat/widgets/button/ico_txt_btn.dart';
import 'package:omni_chat/widgets/text/input_field.dart';
import 'package:omni_chat/widgets/text/input_header.dart';
import 'package:provider/provider.dart';
import 'package:validatorless/validatorless.dart';

class BotPublishingPopUp extends StatefulWidget {
  const BotPublishingPopUp({super.key});

  @override
  State<BotPublishingPopUp> createState() => _BotPublishingPopUpState();
}

class _BotPublishingPopUpState extends State<BotPublishingPopUp> {
  final publishBotFormKey = GlobalKey<FormState>();

  final TextEditingController txtCtrlr1 = TextEditingController();
  final TextEditingController txtCtrlr2 = TextEditingController();
  final TextEditingController txtCtrlr3 = TextEditingController();
  final TextEditingController txtCtrlr4 = TextEditingController();

  String publishType = "";

  @override
  void dispose() {
    txtCtrlr1.dispose();
    txtCtrlr2.dispose();
    txtCtrlr3.dispose();
    txtCtrlr4.dispose();
    super.dispose();
  }

  void clearPublishForm() {
    txtCtrlr1.clear();
    txtCtrlr2.clear();
    txtCtrlr3.clear();
    txtCtrlr4.clear();
    setState(() {
      publishType = "";
    });
  }

  Future<void> onPublish() async {
    if (publishBotFormKey.currentState!.validate()) {
      FocusManager.instance.primaryFocus?.unfocus();
      String botId =
          rootNavigatorKey.currentContext!.read<BotProvider>().currentBot.id;
      final type = PublishType.fromName(publishType);
      switch (type) {
        case PublishType.messenger:
          break;
        case PublishType.telegram:
          await publishToTelegram((
            botId: botId,
            telegramToken: txtCtrlr1.text,
          ));
        case PublishType.slack:
          await publishToSlack((
            botId: botId,
            botToken: txtCtrlr1.text,
            clientId: txtCtrlr2.text,
            clientSecret: txtCtrlr3.text,
            signingSecret: txtCtrlr4.text,
          ));
          break;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: EdgeInsets.all(10),
      child: Form(
        key: publishBotFormKey,
        child: Container(
          width: double.infinity,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            color: Colors.white,
          ),
          padding: EdgeInsets.fromLTRB(10, 20, 10, 10),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: 10,
              children: [
                Center(
                  child: Text(
                    "Publishing this bot to",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                ),
                publishType.isEmpty
                    ? Column(
                      children: [
                        Text(
                          "Please choose a platform in these 3 to publish this bot",
                          style: TextStyle(color: Colors.grey, fontSize: 15),
                          textAlign: TextAlign.center,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children:
                              PublishType.values.map((type) {
                                return Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 5,
                                  ),
                                  child: IconButton(
                                    onPressed: () {
                                      setState(() {
                                        publishType = type.name;
                                      });
                                    },
                                    icon: Brand(type.icon, size: 50),
                                  ),
                                );
                              }).toList(),
                        ),
                      ],
                    )
                    : Align(
                      child: Brand(
                        PublishType.fromName(publishType).icon,
                        size: 50,
                      ),
                    ),
                if (publishType == "telegram") ...[
                  InputHeader(title: "Bot Token", isRequired: true),
                  InputField(
                    controller: txtCtrlr1,
                    placeholder: "Telegram Bot Token",
                    fontSz: 14,
                    validateFunc: Validatorless.required(
                      "Telegram Bot Token is required",
                    ),
                    formKey: publishBotFormKey,
                  ),
                ] else if (publishType == "slack") ...[
                  InputHeader(title: "Bot Token", isRequired: true),
                  InputField(
                    controller: txtCtrlr1,
                    placeholder: "Slack User Bot Token",
                    fontSz: 14,
                    validateFunc: Validatorless.required(
                      "Slack Bot Token is required",
                    ),
                    formKey: publishBotFormKey,
                  ),
                  InputHeader(title: "Client ID", isRequired: true),
                  InputField(
                    controller: txtCtrlr2,
                    placeholder: "Slack Client ID",
                    fontSz: 14,
                    validateFunc: Validatorless.required(
                      "Slack Client ID is required",
                    ),
                    formKey: publishBotFormKey,
                  ),
                  InputHeader(title: "Client Secret", isRequired: true),
                  InputField(
                    controller: txtCtrlr3,
                    placeholder: "Slack Client Secret",
                    fontSz: 14,
                    validateFunc: Validatorless.required(
                      "Slack Client Secret is required",
                    ),
                    formKey: publishBotFormKey,
                  ),
                  InputHeader(title: "Signing Secret", isRequired: true),
                  InputField(
                    controller: txtCtrlr4,
                    placeholder: "Slack Signing Secret",
                    fontSz: 14,
                    validateFunc: Validatorless.required(
                      "Slack Signing Secret is required",
                    ),
                    formKey: publishBotFormKey,
                  ),
                ],
                publishType.isNotEmpty
                    ? Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      spacing: 10,
                      children: [
                        IcoTxtBtn(
                          title: "Back",
                          onTap: () => clearPublishForm(),
                          fontSz: 14,
                          bgColor: Colors.grey,
                          isExpanded: false,
                        ),
                        IcoTxtBtn(
                          title: "Publish",
                          isExpanded: false,
                          onTap: () {
                            onPublish();
                          },
                        ),
                      ],
                    )
                    : SizedBox.shrink(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
