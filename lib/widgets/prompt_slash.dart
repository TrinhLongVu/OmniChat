import 'package:flutter/material.dart';
import 'package:omni_chat/constants/color.dart';

class PromptSlash extends StatelessWidget {
  const PromptSlash({super.key, required this.title, required this.onUse});

  final String title;
  final Function onUse;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: TextButton(
        onPressed: () => onUse(),
        style: ButtonStyle(
          padding: WidgetStateProperty.all(const EdgeInsets.all(15)),
          shape: WidgetStateProperty.all(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(0)),
            ),
          ),
          foregroundColor: WidgetStateProperty.all(omniDarkBlue),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Expanded(
              child: Text(title, maxLines: 1, overflow: TextOverflow.ellipsis),
            ),
          ],
        ),
      ),
    );
  }
}
