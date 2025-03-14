import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:omni_chat/models/bot_model.dart';
import 'package:omni_chat/widgets/common_btn.dart';
import 'package:omni_chat/widgets/info_field.dart';
import 'package:omni_chat/widgets/input_field.dart';
import 'package:omni_chat/widgets/input_header.dart';

class BotInfoScreen extends StatefulWidget {
  final Bot? bot;

  const BotInfoScreen({super.key, this.bot});

  @override
  State<BotInfoScreen> createState() => _BotInfoScreenState();
}

class _BotInfoScreenState extends State<BotInfoScreen> {
  late TextEditingController nameController;
  late TextEditingController instructionController;
  late TextEditingController descriptionController;

  bool editing = false;

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController(text: widget.bot?.name ?? "");
    instructionController = TextEditingController(
      text: widget.bot?.instruction ?? "",
    );
    descriptionController = TextEditingController(
      text: widget.bot?.description ?? "",
    );
  }

  @override
  void dispose() {
    nameController.dispose();
    instructionController.dispose();
    descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    bool editable = widget.bot != null;
    return Scaffold(
      appBar: AppBar(title: Text(editable ? "Bot's Info" : "Create New Bot")),
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
                  spacing: 10,
                  children: [
                    const Icon(Icons.smart_toy_outlined, size: 80),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      spacing: 8,
                      children: [
                        InputHeader(title: "Name", isRequired: !editable),
                        (editable && !editing)
                            ? InfoField(
                              infoText: widget.bot?.name ?? "",
                              fontSz: 16,
                            )
                            : InputField(
                              controller: nameController,
                              placeholder: "Bot's Name",
                            ),
                        InputHeader(title: "Instructions", isRequired: false),
                        (editable && !editing)
                            ? InfoField(
                              infoText: widget.bot?.instruction ?? "",
                              fontSz: 16,
                              lineNum: 4,
                            )
                            : InputField(
                              controller: instructionController,
                              placeholder: "Instruct the bot how to reply",
                              minLns: 2,
                              maxLns: 3,
                            ),
                        InputHeader(title: "Description", isRequired: false),
                        (editable && !editing)
                            ? InfoField(
                              infoText: widget.bot?.description ?? "",
                              fontSz: 16,
                              lineNum: 3,
                            )
                            : InputField(
                              controller: descriptionController,
                              placeholder: "Description (Optional)",
                              minLns: 2,
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
