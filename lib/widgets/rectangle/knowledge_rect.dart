import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:omni_chat/apis/bot/controllers/import_knowledge.dart';
import 'package:omni_chat/apis/bot/controllers/unimport_knowledge.dart';
import 'package:omni_chat/constants/color.dart';
import 'package:omni_chat/models/knowledge.dart';
import 'package:omni_chat/providers/bot.dart';
import 'package:omni_chat/providers/knowledge.dart';
import 'package:omni_chat/widgets/shimmer/shimmer_ln.dart';
import 'package:provider/provider.dart';
import 'package:quickalert/quickalert.dart';

class KnowledgeRect extends StatelessWidget {
  const KnowledgeRect({
    super.key,
    required this.knowledge,
    this.shimmerizing = false,
    this.imported = false,
    this.importing = true,
  });

  final Knowledge knowledge;
  final bool shimmerizing;
  final bool imported;
  final bool importing;

  @override
  Widget build(BuildContext context) {
    final Size viewport = MediaQuery.of(context).size;
    return GestureDetector(
      onTap: () async {
        if (importing) {
          QuickAlert.show(
            context: context,
            type: QuickAlertType.confirm,
            text: 'Are you sure you want to import this knowledge?',
            onConfirmBtnTap: () async {
              await importKnowledge((
                botId: context.read<BotProvider>().currentBot.id,
                knowledgeId: knowledge.id,
              ));
            },
          );
          return;
        }
        context.read<KnowledgeProvider>().setCurrentKnowledge(knowledge);
        context.push('/knowledge/${knowledge.id}');
      },
      child: Container(
        padding: const EdgeInsets.only(right: 8),
        decoration: BoxDecoration(
          color: Colors.white,
          border:
              imported
                  ? Border.all(width: 1.5, color: omniDarkCyan)
                  : Border.symmetric(
                    horizontal: BorderSide(
                      width: 0.5,
                      color: Colors.black.withValues(alpha: 0.05),
                    ),
                  ),
          borderRadius: imported ? BorderRadius.circular(10) : null,
        ),
        child: Row(
          children: [
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Icon(
                Icons.lightbulb_circle_rounded,
                size: imported ? 40 : 60,
                color: omniDarkBlue,
              ),
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                spacing: 3,
                children: [
                  shimmerizing
                      ? ShimmerLine(
                        height: viewport.height * 0.03,
                        color: Colors.black54,
                        borderRad: 3,
                      )
                      : Text(
                        knowledge.name,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                  imported
                      ? SizedBox.shrink()
                      : shimmerizing
                      ? ShimmerLine(
                        height: viewport.height * 0.025,
                        width: viewport.width * 0.5,
                        color: Colors.black38,
                        borderRad: 3,
                      )
                      : Text(
                        knowledge.description,
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
            imported
                ? IconButton(
                  onPressed: () {
                    QuickAlert.show(
                      context: context,
                      type: QuickAlertType.confirm,
                      text:
                          'Are you sure you want to remove this knowledge from this bot?',
                      onConfirmBtnTap: () async {
                        context.pop();
                        await unimportKnowledge((
                          botId: context.read<BotProvider>().currentBot.id,
                          knowledgeId: knowledge.id,
                        ));
                      },
                    );
                  },
                  icon: Icon(Icons.remove_circle_outline, color: Colors.red),
                )
                : SizedBox.shrink(),
          ],
        ),
      ),
    );
  }
}
