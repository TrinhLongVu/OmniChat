import 'package:flutter/material.dart';
import 'package:omni_chat/widgets/popup/prompt_info.dart';

class PromptRect extends StatelessWidget {
  const PromptRect({
    super.key,
    required this.title,
    required this.description,
    required this.content,
    required this.isFav,
    required this.onHeartTap,
  });

  final String title;
  final String description;
  final String content;
  final bool isFav;
  final Function onHeartTap;

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
                  title,
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.w900),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  softWrap: false,
                ),
                Text(
                  description,
                  style: TextStyle(fontSize: 13, color: Colors.black54),
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
                  color: isFav ? Colors.red : Colors.grey,
                ),
              ),
              IconButton(
                onPressed: () {
                  showDialog(
                    context: context,
                    builder:
                        (context) => PromptInfoPopUp(
                          name: title,
                          description: description,
                          content: content,
                          isFav: isFav,
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
