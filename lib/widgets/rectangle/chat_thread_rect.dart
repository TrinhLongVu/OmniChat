import 'package:flutter/material.dart';
import 'package:omni_chat/constants/color.dart';

class ChatThreadRect extends StatelessWidget {
  final String title;
  final bool isCurrent;
  final Function() onChangeThread;

  const ChatThreadRect({
    super.key,
    required this.title,
    required this.isCurrent,
    required this.onChangeThread,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap:
          () => {
            if (!isCurrent) {onChangeThread()},
          },
      child: Container(
        padding: EdgeInsets.only(left: 8),
        width: double.infinity,
        decoration: BoxDecoration(
          color: isCurrent ? omniDarkCyan : omniLightCyan,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Container(
          padding: EdgeInsets.all(15),
          width: 225,
          child: Text(
            title,
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            softWrap: true,
          ),
        ),
      ),
    );
  }
}
