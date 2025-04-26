import 'package:flutter/material.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:lottie/lottie.dart';
import 'package:omni_chat/apis/knowledge/controllers/upload_slack.dart';
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
  final ValueNotifier<bool> loading = ValueNotifier(false);

  String unitType = "";

  Future<void> onUpload() async {
    if (unitFormKey.currentState!.validate()) {
      uploadSlackToKnowledge((
        id:
            rootNavigatorKey.currentContext!
                .read<KnowledgeProvider>()
                .currentKnowledge
                .id,
        unitName: txtCtrlr1.text,
        slackWorkspace: txtCtrlr2.text,
        slackBotToken: txtCtrlr3.text,
      ));
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
                    "Upload a unit of Knowledge",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                ),
                if (unitType == "") ...[
                  Text(
                    "Please choose a way to upload a unit of knowledge",
                    style: TextStyle(color: Colors.grey, fontSize: 15),
                    textAlign: TextAlign.center,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    spacing: 5,
                    children: [
                      IconButton(
                        onPressed: () {},
                        icon: Icon(Icons.web_sharp, size: 50),
                      ),
                      IconButton(
                        onPressed: () {},
                        icon: Icon(Icons.file_present_rounded, size: 50),
                      ),
                      IconButton(
                        onPressed: () {},
                        icon: Brand(Brands.google_drive, size: 50),
                      ),
                      IconButton(
                        onPressed: () {
                          setState(() {
                            unitType = "Slack";
                          });
                        },
                        icon: Brand(Brands.slack_new, size: 50),
                      ),
                      IconButton(
                        onPressed: () {},
                        icon: Brand(Brands.confluence, size: 50),
                      ),
                    ],
                  ),
                ] else if (unitType == "Slack") ...[
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
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      ValueListenableBuilder<bool>(
                        valueListenable: loading,
                        builder: (context, loading, _) {
                          return loading
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
