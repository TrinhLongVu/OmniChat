import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:omni_chat/widgets/common_btn.dart';
import 'package:omni_chat/widgets/input_field.dart';
import 'package:omni_chat/widgets/input_header.dart';

class KnowledgeCreationScreen extends StatelessWidget {
  final TextEditingController knowledgeNameCtrler = TextEditingController();
  final TextEditingController knowledgeDescCtrler = TextEditingController();

  KnowledgeCreationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Create Knowledge")),
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
                    Icon(Icons.lightbulb_circle_rounded, size: 120),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      spacing: 8,
                      children: [
                        InputHeader(title: "Name", isRequired: true),
                        InputField(
                          controller: knowledgeNameCtrler,
                          placeholder: "Name of the knowledge",
                        ),
                        InputHeader(title: "Description", isRequired: true),
                        InputField(
                          controller: knowledgeDescCtrler,
                          placeholder: "Everything about this knowledge base",
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
                title: "Save",
                onTap: () {
                  context.pop();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
