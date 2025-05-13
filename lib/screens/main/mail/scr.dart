import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:omni_chat/apis/mail/controllers/reply.dart';
import 'package:omni_chat/apis/mail/controllers/respond.dart';
import 'package:omni_chat/apis/mail/models/response.dart';
import 'package:omni_chat/constants/color.dart';
import 'package:omni_chat/providers/convo.dart';
import 'package:omni_chat/widgets/button/ico_txt_btn.dart';
import 'package:omni_chat/widgets/text/info_field.dart';
import 'package:omni_chat/widgets/text/input_field.dart';
import 'package:omni_chat/widgets/text/input_header.dart';
import 'package:provider/provider.dart';
import 'package:validatorless/validatorless.dart';

class MailComposerScreen extends StatefulWidget {
  const MailComposerScreen({super.key});

  @override
  State<MailComposerScreen> createState() => _MailComposerScreenState();
}

class _MailComposerScreenState extends State<MailComposerScreen> {
  final mailFormKey = GlobalKey<FormState>();
  final ScrollController scrollCtrlr = ScrollController();

  final TextEditingController senderCtrlr = TextEditingController();
  final TextEditingController receiverCtrlr = TextEditingController();
  final TextEditingController subjectCtrlr = TextEditingController();
  final TextEditingController contentCtrlr = TextEditingController();
  final TextEditingController ideaCtrlr = TextEditingController();

  final ValueNotifier<bool> generating = ValueNotifier(false);
  bool responding = false;

  String showResults = "";
  List<String> replyIdeas = [];
  String responseEmail = "";

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ConvoProvider>().getCurrentToken();
    });
  }

  @override
  void dispose() {
    senderCtrlr.dispose();
    receiverCtrlr.dispose();
    subjectCtrlr.dispose();
    contentCtrlr.dispose();
    ideaCtrlr.dispose();
    scrollCtrlr.dispose();
    super.dispose();
  }

  void scrollToBottom() {
    Future.delayed(Duration(milliseconds: 300), () {
      scrollCtrlr.animateTo(
        scrollCtrlr.position.maxScrollExtent,
        duration: Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    });
  }

  Future<void> onReply() async {
    generating.value = true;
    ReplyEmailResponse? res = await replyEmail((
      sender: senderCtrlr.text,
      receiver: receiverCtrlr.text,
      subject: subjectCtrlr.text,
      content: contentCtrlr.text,
      onError: () {
        generating.value = false;
      },
    ));
    if (res != null) {
      setState(() {
        showResults = "reply";
        replyIdeas = res.ideas;
      });
      scrollToBottom();
    }
    generating.value = false;
  }

  Future<void> onRespond() async {
    generating.value = true;
    RespondEmailResponse? res = await respondEmail((
      sender: senderCtrlr.text,
      receiver: receiverCtrlr.text,
      subject: subjectCtrlr.text,
      content: contentCtrlr.text,
      mainIdea: ideaCtrlr.text,
      onError: () {
        generating.value = false;
      },
    ));
    if (res != null) {
      setState(() {
        showResults = "respond";
        responseEmail = res.email;
      });
      scrollToBottom();
    }
    generating.value = false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Mail Composer"),
        backgroundColor: Colors.white,
      ),
      body: SafeArea(
        child: Form(
          key: mailFormKey,
          child: SingleChildScrollView(
            controller: scrollCtrlr,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                spacing: 10,
                children: [
                  InputHeader(title: "Sender", isRequired: true),
                  InputField(
                    controller: senderCtrlr,
                    placeholder: "Sender",
                    fontSz: 14,
                    validateFunc: Validatorless.required("Sender is required"),
                    formKey: mailFormKey,
                  ),
                  InputHeader(title: "Receiver", isRequired: true),
                  InputField(
                    controller: receiverCtrlr,
                    placeholder: "someone@example.com",
                    fontSz: 14,
                    validateFunc: Validatorless.required(
                      "Receiver is required",
                    ),
                    formKey: mailFormKey,
                  ),
                  InputHeader(title: "Subject", isRequired: true),
                  InputField(
                    controller: subjectCtrlr,
                    placeholder: "Topics or subjects to be discussed",
                    fontSz: 14,
                    validateFunc: Validatorless.required("Subject is required"),
                    formKey: mailFormKey,
                  ),
                  InputHeader(title: "Content", isRequired: true),
                  InputField(
                    controller: contentCtrlr,
                    placeholder:
                        "Content of the email you want to be replied or responded",
                    isNewLineAction: true,
                    fontSz: 14,
                    minLns: 10,
                    maxLns: 15,
                    validateFunc: Validatorless.required("Content is required"),
                    formKey: mailFormKey,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      InputHeader(
                        title: "Main Idea (to respond)",
                        isRequired: true,
                      ),
                      Row(
                        spacing: 4,
                        children: [
                          Icon(Icons.token_rounded, color: omniDarkBlue),
                          Text(
                            "${context.watch<ConvoProvider>().currentToken}",
                          ),
                        ],
                      ),
                    ],
                  ),
                  InputField(
                    controller: ideaCtrlr,
                    placeholder: "Main idea of the respond email",
                    isNewLineAction: true,
                    fontSz: 14,
                    minLns: 1,
                    maxLns: 2,
                    validateFunc: (value) {
                      if (responding) {
                        return Validatorless.required("Main idea is required")(
                          value,
                        );
                      }
                      return null;
                    },
                    formKey: mailFormKey,
                  ),
                  ValueListenableBuilder<bool>(
                    valueListenable: generating,
                    builder: (context, loading, _) {
                      return loading
                          ? Align(
                            alignment: Alignment.center,
                            child: Lottie.asset(
                              "assets/anims/loading.json",
                              width: 150,
                              height: 100,
                            ),
                          )
                          : Row(
                            spacing: 10,
                            children: [
                              IcoTxtBtn(
                                title: "Generate Ideas",
                                onTap: () async {
                                  FocusScope.of(context).unfocus();
                                  setState(() {
                                    showResults = "";
                                    replyIdeas = [];
                                    responding = false;
                                  });
                                  if (mailFormKey.currentState!.validate()) {
                                    await onReply();
                                  }
                                },
                              ),
                              IcoTxtBtn(
                                title: "Respond",
                                onTap: () {
                                  FocusScope.of(context).unfocus();
                                  setState(() {
                                    showResults = "";
                                    replyIdeas = [];
                                    responding = true;
                                  });
                                  if (mailFormKey.currentState!.validate()) {
                                    onRespond();
                                  }
                                  setState(() {
                                    responding = false;
                                  });
                                },
                              ),
                            ],
                          );
                    },
                  ),
                  if (showResults.isNotEmpty) ...[
                    InputHeader(
                      title:
                          showResults == "reply"
                              ? "Here are ${replyIdeas.length} ideas to reply"
                              : "Here is the generated response email",
                    ),
                    showResults == "reply"
                        ? Column(
                          spacing: 10,
                          children:
                              replyIdeas.map((idea) {
                                return InfoField(
                                  infoText: idea,
                                  lineNum: 2,
                                  copiable: true,
                                );
                              }).toList(),
                        )
                        : InfoField(
                          infoText: responseEmail,
                          lineNum: 10,
                          copiable: true,
                        ),
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
