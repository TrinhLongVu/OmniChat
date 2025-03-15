import 'package:flutter/material.dart';
import 'package:omni_chat/constants/color.dart';
import 'package:omni_chat/widgets/common_btn.dart';
import 'package:omni_chat/widgets/input_field.dart';
import 'package:omni_chat/widgets/input_header.dart';

const List<Widget> languages = <Widget>[
  Text('VIE', style: TextStyle(fontWeight: FontWeight.bold)),
  Text('ENG', style: TextStyle(fontWeight: FontWeight.bold)),
];

class MailComposerScreen extends StatefulWidget {
  const MailComposerScreen({super.key});

  @override
  State<MailComposerScreen> createState() => _MailComposerScreenState();
}

class _MailComposerScreenState extends State<MailComposerScreen> {
  final TextEditingController senderCtrlr = TextEditingController();
  final TextEditingController receiverCtrlr = TextEditingController();
  final TextEditingController subjectCtrlr = TextEditingController();
  final TextEditingController contentCtrlr = TextEditingController();
  final TextEditingController actionCtrlr = TextEditingController();

  final List<bool> selectedLanguage = <bool>[true, false];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Mail Composer"),
        backgroundColor: Colors.white,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: 10,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    ToggleButtons(
                      direction: Axis.horizontal,
                      onPressed: (int index) {
                        setState(() {
                          for (int i = 0; i < selectedLanguage.length; i++) {
                            selectedLanguage[i] = i == index;
                          }
                        });
                      },
                      borderRadius: const BorderRadius.all(Radius.circular(8)),
                      selectedBorderColor: omniDarkBlue,
                      selectedColor: omniMilk,
                      fillColor: omniDarkCyan,
                      color: omniDarkBlue,
                      constraints: const BoxConstraints(
                        minHeight: 40.0,
                        minWidth: 50.0,
                      ),
                      isSelected: selectedLanguage,
                      children: languages,
                    ),
                  ],
                ),
                InputHeader(title: "Sender", isRequired: true),
                InputField(
                  controller: senderCtrlr,
                  placeholder: "Sender",
                  fontSz: 14,
                ),
                InputHeader(title: "Receiver", isRequired: true),
                InputField(
                  controller: receiverCtrlr,
                  placeholder: "someone@example.com",
                  fontSz: 14,
                ),
                InputHeader(title: "Subject", isRequired: true),
                InputField(
                  controller: subjectCtrlr,
                  placeholder: "Topics or subjects to be discussed",
                  fontSz: 14,
                ),
                InputHeader(title: "Content", isRequired: true),
                InputField(
                  controller: contentCtrlr,
                  placeholder:
                      "Content of the email you want to be replied or responsed",
                  isNewLineAction: true,
                  fontSz: 14,
                  minLns: 10,
                  maxLns: 15,
                ),
                InputHeader(title: "Action", isRequired: true),
                InputField(
                  controller: actionCtrlr,
                  placeholder: "Suggest 3 ideas to reply this email",
                  fontSz: 14,
                  minLns: 1,
                  maxLns: 3,
                ),
                CommonBtn(title: "Generate Ideas", onTap: () {}),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
