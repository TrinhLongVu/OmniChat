import 'package:flutter/material.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:omni_chat/constants/color.dart';
import 'package:omni_chat/providers/convo.dart';
import 'package:omni_chat/providers/prompt.dart';
import 'package:omni_chat/screens/main/bots/conversation/prompt_modal.dart';
import 'package:omni_chat/widgets/button/fit_ico_btn.dart';
import 'package:provider/provider.dart';

class ChatBox extends StatefulWidget {
  const ChatBox({
    super.key,
    required this.ctrlr,
    required this.focusNode,
    required this.onType,
    required this.onSendMessage,
    this.isPreview = false,
  });

  final bool isPreview;
  final TextEditingController ctrlr;
  final FocusNode focusNode;
  final Function onType;
  final Function onSendMessage;

  @override
  State<ChatBox> createState() => _ChatBoxState();
}

class _ChatBoxState extends State<ChatBox> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<PromptProvider>().loadSlashList();
      if (!widget.isPreview) {
        context.read<ConvoProvider>().getCurrentToken();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withValues(alpha: .5),
            spreadRadius: 2,
            blurRadius: 5,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        children: [
          TextField(
            controller: widget.ctrlr,
            focusNode: widget.focusNode,
            textInputAction: TextInputAction.newline,
            style: TextStyle(fontSize: 14),
            minLines: 1,
            maxLines: 3,
            decoration: InputDecoration(
              filled: true,
              fillColor: Colors.white,
              hintText:
                  context.watch<ConvoProvider>().currentPrompt.id != ""
                      ? "Asking with promt activated"
                      : "Ask me anything or type '/' to use a prompt",
              hintStyle: TextStyle(color: Colors.grey),
              border: OutlineInputBorder(
                borderSide: BorderSide.none,
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            onChanged: (value) => widget.onType(value),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(10, 0, 10, 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    spacing: 10,
                    children: [
                      !widget.isPreview
                          ? Row(
                            spacing: 4,
                            children: [
                              Icon(Icons.token_rounded, color: omniDarkBlue),
                              Text(
                                "${context.watch<ConvoProvider>().currentToken}",
                              ),
                            ],
                          )
                          : SizedBox.shrink(),
                      FitIconBtn(
                        icon: FontAwesome.envelope_open_text_solid,
                        onTap: () {
                          showModalBottomSheet(
                            context: context,
                            isScrollControlled: true,
                            builder: (context) {
                              return PromptModal();
                            },
                          );
                        },
                      ),
                    ],
                  ),
                ),
                Row(
                  spacing: 10,
                  children: [
                    FitIconBtn(onTap: () {}, icon: Icons.photo),
                    FitIconBtn(
                      icon: Icons.send,
                      iconColor:
                          widget.ctrlr.text.isEmpty
                              ? Colors.grey
                              : omniDarkBlue,
                      onTap: () => widget.onSendMessage(),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
