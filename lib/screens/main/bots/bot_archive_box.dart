import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class BotArchiveBox extends StatelessWidget {
  const BotArchiveBox({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => {context.go("/chats/conversation")},
      child: Container(
        padding: const EdgeInsets.only(right: 8),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.symmetric(
            horizontal: BorderSide(
              width: 0.5,
              color: Colors.black.withValues(alpha: 0.05),
            ),
          ),
        ),
        child: Row(
          children: [
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Icon(Icons.circle, size: 60),
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                spacing: 3,
                children: [
                  Text(
                    "StarryAI Bot",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  Text(
                    "Hello! l can provide assistance with your writing needs.",
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    softWrap: false,
                    style: TextStyle(
                      fontWeight: FontWeight.normal,
                      fontSize: 14,
                      color: Colors.black.withValues(alpha: 0.6),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Icon(Icons.more_vert, size: 20),
            ),
          ],
        ),
      ),
    );
  }
}
