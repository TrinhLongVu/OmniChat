import 'package:flutter/material.dart';
import 'package:omni_chat/providers/knowledge.dart';
import 'package:omni_chat/widgets/rectangle/knowledge_rect.dart';
import 'package:provider/provider.dart';

class KnowledgeImportPopUp extends StatefulWidget {
  const KnowledgeImportPopUp({super.key});

  @override
  State<KnowledgeImportPopUp> createState() => _KnowledgeImportPopUpState();
}

class _KnowledgeImportPopUpState extends State<KnowledgeImportPopUp> {
  final ValueNotifier<bool> loading = ValueNotifier(false);

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<KnowledgeProvider>().loadList();
    });
  }

  @override
  Widget build(BuildContext context) {
    final Size viewport = MediaQuery.of(context).size;
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: EdgeInsets.all(10),
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          color: Colors.white,
        ),
        padding: EdgeInsets.fromLTRB(10, 20, 10, 20),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: 10,
            children: [
              Center(
                child: Text(
                  "Import Knowledge to Bot",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
              ),
              ConstrainedBox(
                constraints: BoxConstraints(maxHeight: viewport.height * 0.4),
                child: SingleChildScrollView(
                  child: Column(
                    spacing: 10,
                    children:
                        context
                            .watch<KnowledgeProvider>()
                            .knowledgeList
                            .map(
                              (knowledge) => KnowledgeRect(
                                knowledge: knowledge,
                                imported: true,
                              ),
                            )
                            .toList(),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
