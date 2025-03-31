import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:omni_chat/apis/prompt/fav_add.dart';
import 'package:omni_chat/apis/prompt/fav_remove.dart';
import 'package:omni_chat/constants/color.dart';
import 'package:omni_chat/models/prompt.dart';
import 'package:omni_chat/providers/prompt.dart';
import 'package:omni_chat/widgets/info_field.dart';
import 'package:provider/provider.dart';

class PromptInfoPopUp extends StatefulWidget {
  const PromptInfoPopUp({
    super.key,
    required this.prompt,
    required this.onDelete,
  });

  final Prompt prompt;
  final Function onDelete;

  @override
  State<PromptInfoPopUp> createState() => _PromptInfoPopUpState();
}

class _PromptInfoPopUpState extends State<PromptInfoPopUp> {
  late bool isFavorite;

  @override
  void initState() {
    super.initState();
    isFavorite = widget.prompt.isFavorite;
  }

  void toggleFavorite() async {
    if (isFavorite) {
      await removeFromFavorite(
        id: widget.prompt.id,
        onSuccess: () {
          context.read<PromptProvider>().load2List();
          setState(() {
            isFavorite = !isFavorite;
          });
        },
      );
    } else {
      await addToFavorite(
        id: widget.prompt.id,
        onSuccess: () {
          context.read<PromptProvider>().load2List();
          setState(() {
            isFavorite = !isFavorite;
          });
        },
      );
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
                          widget.prompt.title,
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
                  IconButton(
                    onPressed: () => toggleFavorite(),
                    icon: Icon(
                      Icons.favorite,
                      size: 20,
                      color: isFavorite ? Colors.red : Colors.grey,
                    ),
                  ),
                ],
              ),
              widget.prompt.description != ""
                  ? Text(
                    widget.prompt.description.toString(),
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
              InfoField(infoText: widget.prompt.content, lineNum: 5),
              Row(
                mainAxisAlignment:
                    widget.prompt.isPublic
                        ? MainAxisAlignment.end
                        : MainAxisAlignment.spaceBetween,
                spacing: 10,
                children: [
                  widget.prompt.isPublic
                      ? TextButton(
                        onPressed: () {
                          context.pop();
                        },
                        child: Text("Cancel"),
                      )
                      : TextButton(
                        onPressed: () => widget.onDelete(),
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
