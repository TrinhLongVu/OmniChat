import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:omni_chat/apis/prompt/delete.dart';
import 'package:omni_chat/apis/prompt/fav_add.dart';
import 'package:omni_chat/apis/prompt/fav_remove.dart';
import 'package:omni_chat/models/prompt.dart';
import 'package:omni_chat/providers/chat.dart';
import 'package:omni_chat/providers/prompt.dart';
import 'package:omni_chat/widgets/popup/prompt_info.dart';
import 'package:provider/provider.dart';
import 'package:quickalert/quickalert.dart';

class PromptRect extends StatelessWidget {
  const PromptRect({super.key, required this.prompt});

  final Prompt prompt;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.symmetric(
          horizontal: BorderSide(
            width: 0.5,
            color: Colors.black.withValues(alpha: 0.1),
          ),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  prompt.title,
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.w900),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  softWrap: false,
                ),
                Text(
                  prompt.description.toString(),
                  style: TextStyle(fontSize: 13, color: Colors.black54),
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                  softWrap: false,
                ),
              ],
            ),
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              IconButton(
                onPressed: () async {
                  if (prompt.isFavorite) {
                    await removeFromFavorite(
                      id: prompt.id,
                      onSuccess: () {
                        context.read<PromptProvider>().load2List();
                      },
                    );
                  } else {
                    await addToFavorite(
                      id: prompt.id,
                      onSuccess: () {
                        context.read<PromptProvider>().load2List();
                      },
                    );
                  }
                },
                icon: Icon(
                  Icons.favorite,
                  size: 15,
                  color: prompt.isFavorite ? Colors.red : Colors.grey,
                ),
              ),
              IconButton(
                onPressed: () {
                  showDialog(
                    context: context,
                    builder:
                        (context) => PromptInfoPopUp(
                          prompt: prompt,
                          onDelete: () {
                            QuickAlert.show(
                              context: context,
                              type: QuickAlertType.confirm,
                              text:
                                  'Are you sure you want to delete this prompt?',
                              onCancelBtnTap: () {
                                context.pop();
                              },
                              onConfirmBtnTap: () async {
                                context.pop();
                                await deletePrompt(
                                  id: prompt.id,
                                  onSuccess: () {
                                    context.read<PromptProvider>().loadList(
                                      isPublic: false,
                                    );
                                  },
                                );
                              },
                            );
                          },
                        ),
                  );
                },
                icon: Icon(Icons.info_outline_rounded, size: 15),
              ),
              IconButton(
                onPressed: () {
                  context.read<ChatProvider>().setPrompt(prompt.content);
                  context.pop();
                },
                icon: Icon(Icons.arrow_circle_right_outlined, size: 15),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
