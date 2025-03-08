import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:omni_chat/widgets/common_btn.dart';
import 'package:omni_chat/widgets/input_field.dart';

class BotCreationScreen extends StatelessWidget {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController instructionController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  BotCreationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Create Bot")),
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
                    Icon(Icons.smart_toy_outlined, size: 100),
                    InputField(
                      controller: nameController,
                      placeholder: "Bot's Name",
                      prefixIcon: Icons.person_4,
                    ),
                    InputField(
                      controller: instructionController,
                      placeholder: "Instructions (Optional)",
                      prefixIcon: Icons.integration_instructions,
                      minLns: 2,
                      maxLns: 3,
                    ),
                    InputField(
                      controller: descriptionController,
                      placeholder: "Description (Optional)",
                      prefixIcon: Icons.note_alt,
                      minLns: 2,
                      maxLns: 5,
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
