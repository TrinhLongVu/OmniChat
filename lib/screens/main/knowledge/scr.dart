import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:omni_chat/constants/color.dart';
import 'package:omni_chat/models/knowledge.dart';
import 'package:omni_chat/providers/knowledge.dart';
import 'package:omni_chat/widgets/rectangle/knowledge_rect.dart';
import 'package:omni_chat/widgets/rectangle/search_box.dart';
import 'package:provider/provider.dart';

class KnowledgeLibraryScreen extends StatefulWidget {
  const KnowledgeLibraryScreen({super.key});

  @override
  State<KnowledgeLibraryScreen> createState() => _KnowledgeLibraryScreenState();
}

class _KnowledgeLibraryScreenState extends State<KnowledgeLibraryScreen> {
  final TextEditingController searchKnowledgeCtrlr = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<KnowledgeProvider>().loadList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: EdgeInsets.all(10),
          child: Row(
            children: [
              Expanded(
                child: SearchBox(
                  ctrlr: searchKnowledgeCtrlr,
                  placeholder: "Search Knowledges...",
                  onSearch: (value) {
                    context.read<KnowledgeProvider>().searchKnowledge(value);
                  },
                ),
              ),
              IconButton(
                onPressed: () {
                  context.go("/knowledge/new");
                },
                icon: Icon(
                  Icons.add_circle_outline,
                  size: 32,
                  color: omniDarkBlue,
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: RefreshIndicator(
            onRefresh: () async {
              context.read<KnowledgeProvider>().loadList();
            },
            child: SingleChildScrollView(
              physics: AlwaysScrollableScrollPhysics(),
              scrollDirection: Axis.vertical,
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: MediaQuery.of(context).size.height,
                ),
                child:
                    context.watch<KnowledgeProvider>().loadingList
                        ? Column(
                          children: List.generate(
                            10,
                            (index) => KnowledgeRect(
                              knowledge: Knowledge.placeholder(),
                              shimmerizing: true,
                            ),
                          ),
                        )
                        : Column(
                          children:
                              context
                                  .watch<KnowledgeProvider>()
                                  .knowledgeList
                                  .map(
                                    (knowledge) =>
                                        KnowledgeRect(knowledge: knowledge),
                                  )
                                  .toList(),
                        ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
