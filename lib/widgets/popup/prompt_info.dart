import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:omni_chat/constants/color.dart';
import 'package:omni_chat/models/prompt.dart';
import 'package:omni_chat/widgets/info_field.dart';

class PromptInfoPopUp extends StatelessWidget {
  const PromptInfoPopUp({
    super.key,
    required this.prompt,
    required this.onDelete,
  });

  final Prompt prompt;
  final Function onDelete;

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
                      SizedBox(
                        width: 255,
                        child: Text(
                          prompt.title,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          softWrap: false,
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Icon(
                      Icons.favorite,
                      size: 20,
                      color: prompt.isFavorite ? Colors.red : Colors.grey,
                    ),
                  ),
                ],
              ),
              prompt.description != ""
                  ? Text(
                    prompt.description.toString(),
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: Colors.black45,
                    ),
                  )
                  : SizedBox.shrink(),
              Text(
                "Prompt",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
              ),
              InfoField(infoText: prompt.content, lineNum: 5),
              Row(
                mainAxisAlignment:
                    prompt.isPublic
                        ? MainAxisAlignment.end
                        : MainAxisAlignment.spaceBetween,
                spacing: 10,
                children: [
                  prompt.isPublic
                      ? TextButton(
                        onPressed: () {
                          context.pop();
                        },
                        child: Text("Cancel"),
                      )
                      : TextButton(
                        onPressed: () => onDelete(),
                        style: ButtonStyle(
                          padding: WidgetStateProperty.all(
                            const EdgeInsets.all(15),
                          ),
                          backgroundColor: const WidgetStatePropertyAll(
                            Colors.red,
                          ),
                          shape: WidgetStateProperty.all(
                            const RoundedRectangleBorder(
                              borderRadius: BorderRadius.all(
                                Radius.circular(5),
                              ), // Sharp corners
                            ),
                          ),
                        ),
                        child: Row(
                          spacing: 10,
                          children: [
                            Icon(Icons.delete, color: Colors.white),
                            Text(
                              "Delete",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
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
