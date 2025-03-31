import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:omni_chat/apis/prompt/create.dart';
import 'package:omni_chat/constants/color.dart';
import 'package:omni_chat/widgets/input_field.dart';
import 'package:omni_chat/widgets/input_header.dart';
import 'package:validatorless/validatorless.dart';

final newPromptFormKey = GlobalKey<FormState>();

class PromptCreationPopUp extends StatelessWidget {
  final TextEditingController promptNameCtrlr = TextEditingController();
  final TextEditingController promptContentCtrlr = TextEditingController();
  final TextEditingController promptDescriptionCtrlr = TextEditingController();

  PromptCreationPopUp({super.key});

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
                    TextButton(
                      onPressed: () {
                        if (newPromptFormKey.currentState!.validate()) {
                          createPrompt(
                            title: promptNameCtrlr.text,
                            content: promptContentCtrlr.text,
                            description: promptDescriptionCtrlr.text,
                          );
                        }
                      },
                      style: ButtonStyle(
                        padding: WidgetStateProperty.all(
                          const EdgeInsets.all(15),
                        ),
                        backgroundColor: const WidgetStatePropertyAll(
                          omniDarkBlue,
                        ),
                        shape: WidgetStateProperty.all(
                          const RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(
                              Radius.circular(30),
                            ), // Sharp corners
                          ),
                        ),
                      ),
                      child: Text(
                        "Create",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
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
