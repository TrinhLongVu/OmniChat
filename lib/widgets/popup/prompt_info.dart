import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:omni_chat/constants/color.dart';
import 'package:omni_chat/widgets/info_field.dart';

class PromptInfoPopUp extends StatelessWidget {
  const PromptInfoPopUp({super.key});

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
        padding: EdgeInsets.fromLTRB(15, 20, 15, 10),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: 8,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    spacing: 10,
                    children: [
                      Icon(
                        Icons.sticky_note_2_rounded,
                        color: omniDarkCyan,
                        size: 25,
                      ),
                      Text(
                        "Grammar Corrector",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                  IconButton(
                    onPressed: () {},
                    icon: Icon(Icons.favorite, size: 20),
                  ),
                ],
              ),
              Text(
                "Improve your spelling and grammar by checking your text for errors.",
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: Colors.black45,
                ),
              ),
              Text(
                "Prompt",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
              ),
              InfoField(
                infoText:
                    "You are a machine that check all language grammar mistakes and make the sentence more fluent. You take all the user input and auto correct it. Just reply to user input with correct grammar, DO NOT reply the context of the question of the user input. If the user input is grammatically correct and fluent, just reply 'Sounds good'",
                lineNum: 5,
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
                      context.pop();
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
                      "Use this prompt",
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
    );
  }
}
