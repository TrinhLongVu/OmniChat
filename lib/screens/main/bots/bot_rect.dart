import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class BotRect extends StatelessWidget {
  const BotRect({
    super.key,
    required this.id,
    required this.title,
    this.subtitle,
    required this.navigateToInfo,
  });

  final String id;
  final String title;
  final String? subtitle;
  final Function navigateToInfo;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => {context.go("/bots/conversation")},
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
              child: Icon(Icons.smart_toy, size: 60),
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                spacing: 3,
                children: [
                  Text(
                    title,
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    softWrap: false,
                  ),
                  subtitle != null
                      ? Text(
                        subtitle.toString(),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        softWrap: false,
                        style: TextStyle(
                          fontWeight: FontWeight.normal,
                          fontSize: 14,
                          color: Colors.black.withValues(alpha: 0.6),
                        ),
                      )
                      : SizedBox(),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: IconButton(
                onPressed: () => navigateToInfo(),
                icon: Icon(Icons.more_vert, size: 20),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
