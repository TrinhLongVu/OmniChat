import 'package:flutter/material.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:lottie/lottie.dart';
import 'package:omni_chat/apis/knowledge/controllers/upload_confluence.dart';
import 'package:omni_chat/apis/knowledge/controllers/upload_slack.dart';
import 'package:omni_chat/constants/knowledge_unit_type.dart';
import 'package:omni_chat/providers/knowledge.dart';
import 'package:omni_chat/router/index.dart';
import 'package:omni_chat/widgets/button/ico_txt_btn.dart';
import 'package:omni_chat/widgets/text/input_field.dart';
import 'package:omni_chat/widgets/text/input_header.dart';
import 'package:provider/provider.dart';
import 'package:validatorless/validatorless.dart';

class KnowledgeUnitUploadPopUp extends StatefulWidget {
  const KnowledgeUnitUploadPopUp({super.key});

  @override
  State<KnowledgeUnitUploadPopUp> createState() =>
      _KnowledgeUnitUploadPopUpState();
}

class _KnowledgeUnitUploadPopUpState extends State<KnowledgeUnitUploadPopUp> {
  final unitFormKey = GlobalKey<FormState>();

  final TextEditingController txtCtrlr1 = TextEditingController();
  final TextEditingController txtCtrlr2 = TextEditingController();
  final TextEditingController txtCtrlr3 = TextEditingController();
  final TextEditingController txtCtrlr4 = TextEditingController();
  final ValueNotifier<bool> uploading = ValueNotifier(false);

  String unitType = "";

  @override
  void dispose() {
    txtCtrlr1.dispose();
    txtCtrlr2.dispose();
    txtCtrlr3.dispose();
    txtCtrlr4.dispose();
    super.dispose();
  }

  void clearTextControllers() {
    txtCtrlr1.clear();
    txtCtrlr2.clear();
    txtCtrlr3.clear();
    txtCtrlr4.clear();
  }

  Future<void> onUpload() async {
    if (unitFormKey.currentState!.validate()) {
      FocusManager.instance.primaryFocus?.unfocus();
      String knowledgeId =
          rootNavigatorKey.currentContext!
              .read<KnowledgeProvider>()
              .currentKnowledge
              .id;

      switch (unitType) {
        case "slack":
          uploading.value = true;
          uploadSlackToKnowledge((
            id: knowledgeId,
            unitName: txtCtrlr1.text,
            slackWorkspace: txtCtrlr2.text,
            slackBotToken: txtCtrlr3.text,
            onError: () {
              uploading.value = false;
            },
          ));
          break;
        case "confluence":
          uploadConfluenceToKnowledge((
            id: knowledgeId,
            unitName: txtCtrlr1.text,
            wikiUrl: txtCtrlr2.text,
            username: txtCtrlr3.text,
            confluenceToken: txtCtrlr4.text,
          ));
          break;
        default:
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: EdgeInsets.all(10),
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          color: Colors.white,
        ),
        padding: EdgeInsets.fromLTRB(10, 20, 10, 10),
        child: SingleChildScrollView(
          child: Form(
            key: unitFormKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: 10,
              children: [
                Center(
                  child: Text(
                    "Upload a unit of Knowledge to",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                ),
                unitType.isEmpty
                    ? Column(
                      children: [
                        Text(
                          "Please choose a way to upload a unit of knowledge",
                          style: TextStyle(color: Colors.grey, fontSize: 15),
                          textAlign: TextAlign.center,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children:
                              KnowledgeUnitType.values.map((type) {
                                return Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 5,
                                  ),
                                  child: IconButton(
                                    onPressed: () {
                                      setState(() {
                                        unitType = type.name;
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
                        KnowledgeUnitType.iconize(unitType)!.icon,
                        size: 50,
                      ),
                    ),
                if (unitType.isNotEmpty) ...[
                  InputHeader(title: "Name", isRequired: true),
                  InputField(
                    controller: txtCtrlr1,
                    placeholder: "Name of the unit",
                    fontSz: 14,
                    validateFunc: Validatorless.required(
                      "Unit's name is required",
                    ),
                    formKey: unitFormKey,
                  ),
                ],
                ...switch (unitType) {
                  "slack" => [
                    InputHeader(title: "Slack Workspace", isRequired: true),
                    InputField(
                      controller: txtCtrlr2,
                      placeholder: "Name of the workspace",
                      fontSz: 14,
                      validateFunc: Validatorless.required(
                        "Workspace is required",
                      ),
                      formKey: unitFormKey,
                    ),
                    InputHeader(title: "Slack Bot Token", isRequired: true),
                    InputField(
                      controller: txtCtrlr3,
                      placeholder: "Bot token",
                      fontSz: 14,
                      validateFunc: Validatorless.required(
                        "Bot token is required",
                      ),
                      formKey: unitFormKey,
                    ),
                  ],
                  "confluence" => [
                    InputHeader(title: "Wiki Page URL", isRequired: true),
                    InputField(
                      controller: txtCtrlr2,
                      placeholder: "Wiki URL",
                      fontSz: 14,
                      validateFunc: Validatorless.required(
                        "Wiki URL is required",
                      ),
                      formKey: unitFormKey,
                    ),
                    InputHeader(title: "Username", isRequired: true),
                    InputField(
                      controller: txtCtrlr3,
                      placeholder: "Username on Confluence",
                      fontSz: 14,
                      validateFunc: Validatorless.required(
                        "Username is required",
                      ),
                      formKey: unitFormKey,
                    ),
                    InputHeader(title: "Access Token", isRequired: true),
                    InputField(
                      controller: txtCtrlr4,
                      placeholder: "Confluence's Access Token",
                      fontSz: 14,
                      validateFunc: Validatorless.required(
                        "Access token is required",
                      ),
                      formKey: unitFormKey,
                    ),
                  ],
                  _ => [],
                },
                if (unitType.isNotEmpty) ...[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      IcoTxtBtn(
                        title: "Back",
                        onTap:
                            () => {
                              clearTextControllers(),
                              setState(() {
                                unitType = "";
                              }),
                            },
                        fontSz: 14,
                        bgColor: Colors.grey,
                        isExpanded: false,
                      ),
                      ValueListenableBuilder<bool>(
                        valueListenable: uploading,
                        builder: (context, uploading, _) {
                          return uploading
                              ? Lottie.asset(
                                "assets/anims/loading.json",
                                width: 100,
                                height: 60,
                              )
                              : IcoTxtBtn(
                                title: "Upload",
                                onTap: () => onUpload(),
                                fontSz: 14,
                                isExpanded: false,
                              );
                        },
                      ),
                    ],
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
