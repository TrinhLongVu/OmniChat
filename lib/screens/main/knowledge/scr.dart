import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:omni_chat/constants/color.dart';
import 'package:omni_chat/constants/knowledge_type.dart';
import 'package:omni_chat/screens/main/knowledge/knowledge_rect.dart';
import 'package:omni_chat/widgets/search_box.dart';

class KnowledgeLibraryScreen extends StatelessWidget {
  final TextEditingController searchKnowledgeCtrlr = TextEditingController();

  KnowledgeLibraryScreen({super.key});

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
          child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Column(
              children: List.generate(2, (index) {
                return Column(
                  children: [
                    KnowledgeRect(
                      name: "Tech Overview",
                      description:
                          "Technology is a vast field that encompasses hardware, software, networks, AI, cybersecurity, and much more.",
                      type: KnowledgeType.normal,
                    ),
                    KnowledgeRect(
                      name: "Tech Overview",
                      description:
                          "Technology is a vast field that encompasses hardware, software, networks, AI, cybersecurity, and much more.",
                      type: KnowledgeType.file,
                    ),
                    KnowledgeRect(
                      name: "Tech Overview",
                      description:
                          "Technology is a vast field that encompasses hardware, software, networks, AI, cybersecurity, and much more.",
                      type: KnowledgeType.ggdrive,
                    ),
                    KnowledgeRect(
                      name: "Tech Overview",
                      description:
                          "Technology is a vast field that encompasses hardware, software, networks, AI, cybersecurity, and much more.",
                      type: KnowledgeType.web,
                    ),
                    KnowledgeRect(
                      name: "Tech Overview",
                      description:
                          "Technology is a vast field that encompasses hardware, software, networks, AI, cybersecurity, and much more.",
                      type: KnowledgeType.slack,
                    ),
                    KnowledgeRect(
                      name: "Tech Overview",
                      description:
                          "Technology is a vast field that encompasses hardware, software, networks, AI, cybersecurity, and much more.",
                      type: KnowledgeType.confluence,
                    ),
                  ],
                );
              }),
            ),
          ),
        ),
      ],
    );
  }
}
