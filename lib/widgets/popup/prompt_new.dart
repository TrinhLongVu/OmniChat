import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lottie/lottie.dart';
import 'package:omni_chat/apis/prompt/create.dart';
import 'package:omni_chat/constants/color.dart';
import 'package:omni_chat/providers/prompt.dart';
import 'package:omni_chat/router/index.dart';
import 'package:omni_chat/widgets/button/ico_txt_btn.dart';
import 'package:omni_chat/widgets/input_field.dart';
import 'package:omni_chat/widgets/input_header.dart';
import 'package:provider/provider.dart';
import 'package:validatorless/validatorless.dart';

final newPromptFormKey = GlobalKey<FormState>();

class PromptCreationPopUp extends StatelessWidget {
  final TextEditingController promptNameCtrlr = TextEditingController();
  final TextEditingController promptContentCtrlr = TextEditingController();
  final TextEditingController promptDescriptionCtrlr = TextEditingController();
  final ValueNotifier<bool> loading = ValueNotifier(false);

  PromptCreationPopUp({super.key});

  Future<void> createNewPrompt() async {
    if (newPromptFormKey.currentState!.validate()) {
      loading.value = true;
      await createPrompt(
        title: promptNameCtrlr.text,
        content: promptContentCtrlr.text,
        description: promptDescriptionCtrlr.text,
        onSuccess: () {
          rootNavigatorKey.currentContext!.read<PromptProvider>().loadList(
            isPublic: false,
          );
        },
      );
      loading.value = false;
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
        child: Form(
          key: newPromptFormKey,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: 10,
              children: [
                Center(
                  child: Text(
                    "New private prompt",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                ),
                InputHeader(title: "Name", isRequired: true),
                InputField(
                  controller: promptNameCtrlr,
                  placeholder: "Name of the prompt",
                  fontSz: 14,
                  validateFunc: Validatorless.required(
                    "Prompt's name is required",
                  ),
                  formKey: newPromptFormKey,
                ),
                InputHeader(title: "Prompt", isRequired: true),
                Container(
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: omniLightCyan,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    spacing: 10,
                    children: [
                      Icon(Icons.info, color: omniMilk),
                      Text(
                        "Use '[ ]' to specify user inputs",
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                InputField(
                  controller: promptContentCtrlr,
                  placeholder:
                      "e.g: Write an article about [TOPIC], make sure to include these keywords: [KEYWORDS]",
                  minLns: 3,
                  maxLns: 5,
                  fontSz: 14,
                  validateFunc: Validatorless.required(
                    "Prompt's content is required",
                  ),
                  formKey: newPromptFormKey,
                ),
                InputHeader(title: "Description"),
                InputField(
                  controller: promptDescriptionCtrlr,
                  placeholder: "Note for usage information",
                  minLns: 2,
                  maxLns: 3,
                  fontSz: 14,
                  formKey: newPromptFormKey,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  spacing: 10,
                  children: [
                    TextButton(
                      onPressed: () {
                        context.pop();
                      },
                      child: Text("Cancel"),
                    ),
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
                              title: "Create",
                              onTap: () => createNewPrompt(),
                              fontSz: 14,
                              isExpanded: false,
                            );
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
