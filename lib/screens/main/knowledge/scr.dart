import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:omni_chat/constants/color.dart';
import 'package:omni_chat/models/knowledge.dart';
import 'package:omni_chat/providers/knowledge.dart';
import 'package:omni_chat/widgets/button/fit_ico_btn.dart';
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
            color: omniDarkBlue,
            backgroundColor: Colors.white,
            onRefresh: () async {
              context.read<KnowledgeProvider>().loadList();
            },
            child: SingleChildScrollView(
              physics: AlwaysScrollableScrollPhysics(),
              scrollDirection: Axis.vertical,
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: MediaQuery.of(context).size.height * 0.75,
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
                        : context
                            .watch<KnowledgeProvider>()
                            .knowledgeList
                            .isEmpty
                        ? Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "No knowledges found",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.grey,
                                ),
                              ),
                              RichText(
                                textAlign: TextAlign.center,
                                text: TextSpan(
                                  style: TextStyle(
                                    fontSize: 18,
                                    color: Colors.grey,
                                    fontWeight: FontWeight.bold,
                                    fontFamily:
                                        GoogleFonts.poppins().fontFamily,
                                  ),
                                  children: [
                                    TextSpan(text: 'Create one '),
                                    WidgetSpan(
                                      alignment: PlaceholderAlignment.middle,
                                      child: FitIconBtn(
                                        onTap: () => context.push("/bots/new"),
                                        icon: Icons.add_circle_outline,
                                        iconColor: omniDarkBlue,
                                        iconSize: 30,
                                      ),
                                    ),
                                    TextSpan(text: '  now'),
                                  ],
                                ),
                              ),
                            ],
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
