import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:omni_chat/widgets/shimmer/shimmer_ln.dart';

class BotRect extends StatelessWidget {
  const BotRect({
    super.key,
    required this.id,
    required this.title,
    this.subtitle,
    required this.navigateToInfo,
    this.shimmerizing = false,
  });

  final String id;
  final String title;
  final String? subtitle;
  final Function navigateToInfo;
  final bool shimmerizing;

  @override
  Widget build(BuildContext context) {
    final Size viewport = MediaQuery.of(context).size;
    return GestureDetector(
      onTap:
          () => {
            if (!shimmerizing) {context.go('/bots/convo/$id')},
          },
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
              child: Icon(Icons.smart_toy, size: 60, color: Colors.black),
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                spacing: shimmerizing ? 5 : 3,
                children: [
                  shimmerizing
                      ? ShimmerLine(
                        height: viewport.height * 0.02,
                        color: Colors.black54,
                        borderRad: 3,
                      )
                      : Text(
                        title,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        softWrap: false,
                      ),
                  shimmerizing
                      ? ShimmerLine(
                        height: viewport.height * 0.02,
                        width: viewport.width * 0.4,
                        color: Colors.black38,
                        borderRad: 3,
                      )
                      : subtitle != null
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
              padding: EdgeInsets.all(shimmerizing ? 20 : 10),
              child:
                  shimmerizing
                      ? Icon(Icons.more_vert, size: 20)
                      : IconButton(
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
