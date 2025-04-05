import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:omni_chat/apis/prompt/fav_add.dart';
import 'package:omni_chat/apis/prompt/fav_remove.dart';
import 'package:omni_chat/models/prompt.dart';
import 'package:omni_chat/providers/chat.dart';
import 'package:omni_chat/providers/prompt.dart';
import 'package:omni_chat/widgets/popup/prompt_info.dart';
import 'package:omni_chat/widgets/rectangle/shimmer_ln.dart';
import 'package:provider/provider.dart';

class PromptRect extends StatelessWidget {
  final Prompt prompt;
  final bool shimmerizing;

  const PromptRect({
    super.key,
    required this.prompt,
    this.shimmerizing = false,
  });

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
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: 5,
              children: [
                shimmerizing
                    ? ShimmerLine(
                      height: viewport.height * 0.02,
                      width: viewport.width * 0.3,
                      color: Colors.black38,
                      borderRad: 3,
                    )
                    : Text(
                      prompt.title,
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w900,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      softWrap: false,
                    ),
                shimmerizing
                    ? Column(
                      spacing: 3,
                      children: List.generate(
                        2,
                        (index) => ShimmerLine(
                          height: viewport.height * 0.02,
                          color: Colors.black26,
                          borderRad: 3,
                        ),
                      ),
                    )
                    : Text(
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
              shimmerizing
                  ? Padding(
                    padding: const EdgeInsets.all(15),
                    child: Icon(Icons.favorite, size: 15, color: Colors.grey),
                  )
                  : IconButton(
                    onPressed: () async {
                      if (shimmerizing) return;
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
                      color:
                          prompt.isFavorite && !shimmerizing
                              ? Colors.red
                              : Colors.grey,
                    ),
                  ),
              shimmerizing
                  ? Padding(
                    padding: const EdgeInsets.all(15),
                    child: Icon(Icons.info_outline_rounded, size: 15),
                  )
                  : IconButton(
                    onPressed: () {
                      if (shimmerizing) return;
                      showDialog(
                        context: context,
                        builder: (context) => PromptInfoPopUp(prompt: prompt),
                      );
                    },
                    icon: Icon(Icons.info_outline_rounded, size: 15),
                  ),
              shimmerizing
                  ? Padding(
                    padding: const EdgeInsets.all(15),
                    child: Icon(Icons.arrow_circle_right_outlined, size: 15),
                  )
                  : IconButton(
                    onPressed: () {
                      if (shimmerizing) return;
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
