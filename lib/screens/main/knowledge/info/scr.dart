import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:omni_chat/models/knowledge_model.dart';
import 'package:omni_chat/widgets/button/common_btn.dart';
import 'package:omni_chat/widgets/info_field.dart';
import 'package:omni_chat/widgets/input_field.dart';
import 'package:omni_chat/widgets/input_header.dart';

class KnowledgeInfoScreen extends StatefulWidget {
  final Knowledge? knowledge;

  const KnowledgeInfoScreen({super.key, this.knowledge});

  @override
  State<KnowledgeInfoScreen> createState() => _KnowledgeInfoScreenState();
}

class _KnowledgeInfoScreenState extends State<KnowledgeInfoScreen> {
  late TextEditingController knowledgeNameCtrlr;
  late TextEditingController knowledgeDescCtrlr;

  bool editing = false;

  @override
  void initState() {
    super.initState();
    knowledgeNameCtrlr = TextEditingController(
      text: widget.knowledge?.name ?? "",
    );
    knowledgeDescCtrlr = TextEditingController(
      text: widget.knowledge?.description ?? "",
    );
  }

  @override
  void dispose() {
    knowledgeNameCtrlr.dispose();
    knowledgeDescCtrlr.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    bool editable = widget.knowledge != null;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          editable ? "Knowledge's Information" : "Create New Knowledge",
        ),
      ),
      body: SizedBox(
        height: double.infinity,
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.only(
                left: 20,
                right: 20,
                top: 20,
                bottom: 100,
              ),
              child: SingleChildScrollView(
                child: Column(
                  spacing: 20,
                  children: [
                    Icon(Icons.lightbulb_circle_rounded, size: 80),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      spacing: 8,
                      children: [
                        InputHeader(title: "Name", isRequired: !editable),
                        (editable && !editing)
                            ? InfoField(
                              infoText: widget.knowledge?.name ?? "",
                              fontSz: 16,
                            )
                            : InputField(
                              controller: knowledgeNameCtrlr,
                              placeholder: "Name of the knowledge",
                            ),
                        InputHeader(
                          title: "Description",
                          isRequired: !editable,
                        ),
                        (editable && !editing)
                            ? InfoField(
                              infoText: widget.knowledge?.description ?? "",
                              fontSz: 16,
                              lineNum: 5,
                            )
                            : InputField(
                              controller: knowledgeDescCtrlr,
                              placeholder:
                                  "Everything about this knowledge base",
                              minLns: 3,
                              maxLns: 5,
                            ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            Positioned(
              right: 20,
              left: 20,
              bottom: 20,
              child: CommonBtn(
                title: editable && !editing ? "Edit" : "Save",
                onTap: () {
                  if (!editable) {
                    context.pop();
                  } else {
                    setState(() {
                      editing = !editing;
                    });
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
