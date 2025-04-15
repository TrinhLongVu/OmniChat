import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:omni_chat/apis/knowledge/controllers/get_list.dart';
import 'package:omni_chat/apis/knowledge/models/response.dart';
import 'package:omni_chat/constants/color.dart';
import 'package:omni_chat/models/knowledge.dart';
import 'package:omni_chat/widgets/rectangle/knowledge_rect.dart';
import 'package:omni_chat/widgets/rectangle/search_box.dart';

class KnowledgeLibraryScreen extends StatefulWidget {
  const KnowledgeLibraryScreen({super.key});

  @override
  State<KnowledgeLibraryScreen> createState() => _KnowledgeLibraryScreenState();
}

class _KnowledgeLibraryScreenState extends State<KnowledgeLibraryScreen> {
  final TextEditingController searchKnowledgeCtrlr = TextEditingController();

  List<Knowledge> knowledgeList = [];

  @override
  void initState() {
    super.initState();
    loadList();
  }

  Future<void> loadList() async {
    GetKnowledgeListResponse? res = await getKnowledgeList();
    if (mounted && res != null) {
      setState(() {
        knowledgeList = res.data;
      });
    }
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
                  onSearch: () {},
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
            onRefresh: () => loadList(),
            child: SingleChildScrollView(
              physics: AlwaysScrollableScrollPhysics(),
              scrollDirection: Axis.vertical,
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: MediaQuery.of(context).size.height,
                ),
                child: Column(
                  children:
                      knowledgeList
                          .map(
                            (knowledge) => KnowledgeRect(
                              name: knowledge.name,
                              description: knowledge.description,
                            ),
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
