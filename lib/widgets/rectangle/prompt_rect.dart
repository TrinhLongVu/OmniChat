import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:omni_chat/apis/prompt/delete.dart';
import 'package:omni_chat/models/prompt.dart';
import 'package:omni_chat/widgets/popup/prompt_info.dart';
import 'package:quickalert/quickalert.dart';

class PromptRect extends StatelessWidget {
  const PromptRect({
    super.key,
    required this.prompt,
    required this.onHeartTap,
    required this.onReload,
  });

  final Prompt prompt;
  final Function onHeartTap;
  final Function onReload;

  @override
  Widget build(BuildContext context) {
    final Size viewport = MediaQuery.of(context).size;
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
          SizedBox(
            width: viewport.width * .7,
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
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  softWrap: false,
                ),
              ],
            ),
          ),
          Row(
            children: [
              IconButton(
                onPressed: () => onHeartTap(),
                icon: Icon(
                  Icons.favorite,
                  size: 18,
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
                                await deletePrompt(id: prompt.id);
                                onReload();
                              },
                            );
                          },
                        ),
                  );
                },
                icon: Icon(Icons.info_outline_rounded, size: 18),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
