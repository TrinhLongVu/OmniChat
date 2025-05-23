import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lottie/lottie.dart';
import 'package:omni_chat/apis/knowledge/controllers/create.dart';
import 'package:omni_chat/apis/knowledge/controllers/delete.dart';
import 'package:omni_chat/apis/knowledge/controllers/update.dart';
import 'package:omni_chat/constants/color.dart';
import 'package:omni_chat/models/knowledge.dart';
import 'package:omni_chat/providers/knowledge.dart';
import 'package:omni_chat/widgets/button/common_btn.dart';
import 'package:omni_chat/widgets/button/ico_txt_btn.dart';
import 'package:omni_chat/widgets/popup/knowledge_unit_upload.dart';
import 'package:omni_chat/widgets/rectangle/knowledge_unit_rect.dart';
import 'package:omni_chat/widgets/text/info_field.dart';
import 'package:omni_chat/widgets/text/input_field.dart';
import 'package:omni_chat/widgets/text/input_header.dart';
import 'package:provider/provider.dart';
import 'package:quickalert/models/quickalert_type.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';
import 'package:validatorless/validatorless.dart';

class KnowledgeInfoScreen extends StatefulWidget {
  final String? id;

  const KnowledgeInfoScreen({super.key, this.id});

  @override
  State<KnowledgeInfoScreen> createState() => _KnowledgeInfoScreenState();
}

class _KnowledgeInfoScreenState extends State<KnowledgeInfoScreen> {
  final editKnowledgeFormKey = GlobalKey<FormState>();
  late TextEditingController nameCtrlr;
  late TextEditingController descriptionCtrlr;

  bool editing = false;
  String screenState = "";
  final ValueNotifier<bool> loading = ValueNotifier(false);

  @override
  void initState() {
    super.initState();
    if (widget.id == null) {
      screenState = "create";
      nameCtrlr = TextEditingController();
      descriptionCtrlr = TextEditingController();
    } else {
      screenState = "info";
      nameCtrlr = TextEditingController(
        text: context.read<KnowledgeProvider>().currentKnowledge.name,
      );
      descriptionCtrlr = TextEditingController(
        text: context.read<KnowledgeProvider>().currentKnowledge.description,
      );
    }
  }

  @override
  void dispose() {
    nameCtrlr.dispose();
    descriptionCtrlr.dispose();
    super.dispose();
  }

  Future<void> onCreateKnowledge() async {
    loading.value = true;
    await createKnowledge((
      name: nameCtrlr.text,
      description: descriptionCtrlr.text,
      onError: () {
        loading.value = false;
      },
    ));
  }

  Future<void> onDeleteKnowledge() async {
    loading.value = true;
    await deleteKnowledge((
      id: widget.id!,
      onError: () {
        loading.value = false;
      },
    ));
  }

  Future<void> onUpdateKnowledge() async {
    loading.value = true;
    await updateKnowledge((
      id: widget.id!,
      name: nameCtrlr.text,
      description: descriptionCtrlr.text,
      onSuccess: () {
        Knowledge updatedKnowledge = Knowledge(
          id: widget.id!,
          name: nameCtrlr.text,
          description: descriptionCtrlr.text,
          userId: context.read<KnowledgeProvider>().currentKnowledge.userId,
          numUnits: context.read<KnowledgeProvider>().currentKnowledge.numUnits,
          totalSize:
              context.read<KnowledgeProvider>().currentKnowledge.totalSize,
          createdAt:
              context.read<KnowledgeProvider>().currentKnowledge.createdAt,
          updatedAt:
              context.read<KnowledgeProvider>().currentKnowledge.updatedAt,
        );
        context.read<KnowledgeProvider>().setCurrentKnowledge(updatedKnowledge);
        loading.value = false;
      },
      onError: () {
        loading.value = false;
      },
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          screenState == "create" ? "New Knowledge" : "Knowledge's Information",
        ),
      ),
      body: SizedBox(
        height: double.infinity,
        child: Form(
          key: editKnowledgeFormKey,
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
                      Icon(Icons.lightbulb_circle_rounded, size: 50),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        spacing: 8,
                        children: [
                          InputHeader(title: "Name", isRequired: true),
                          (screenState == "info")
                              ? InfoField(
                                infoText:
                                    context
                                        .watch<KnowledgeProvider>()
                                        .currentKnowledge
                                        .name,
                                fontSz: 16,
                                shimmerizing:
                                    context
                                        .watch<KnowledgeProvider>()
                                        .knowledgeLoading,
                              )
                              : InputField(
                                controller: nameCtrlr,
                                placeholder: "Name of the knowledge",
                                validateFunc: Validatorless.required(
                                  "Name of knowledge is required",
                                ),
                                formKey: editKnowledgeFormKey,
                              ),
                          InputHeader(title: "Description"),
                          (screenState == "info")
                              ? InfoField(
                                infoText:
                                    context
                                        .watch<KnowledgeProvider>()
                                        .currentKnowledge
                                        .description,
                                fontSz: 16,
                                lineNum: 5,
                                shimmerizing:
                                    context
                                        .watch<KnowledgeProvider>()
                                        .knowledgeLoading,
                              )
                              : InputField(
                                controller: descriptionCtrlr,
                                placeholder:
                                    "Description about this knowledge base",
                                minLns: 3,
                                maxLns: 5,
                              ),
                          if (screenState == "info" &&
                              !context
                                  .watch<KnowledgeProvider>()
                                  .knowledgeLoading) ...[
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                InputHeader(title: "Knowledge Units"),
                                TextButton(
                                  onPressed: () {
                                    showDialog(
                                      context: context,
                                      builder:
                                          (context) =>
                                              KnowledgeUnitUploadPopUp(),
                                    );
                                  },
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    spacing: 10,
                                    children: [
                                      Text(
                                        "Upload",
                                        style: TextStyle(color: omniDarkCyan),
                                      ),
                                      Icon(Icons.upload, color: omniDarkBlue),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            Consumer<KnowledgeProvider>(
                              builder: (context, provider, _) {
                                final knowledgeUnits =
                                    provider.currentKnowledgeUnits;

                                if (knowledgeUnits.isEmpty) {
                                  return const Align(
                                    alignment: Alignment.center,
                                    child: Text(
                                      "No Uploaded Knowledge Units Yet",
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black54,
                                      ),
                                    ),
                                  );
                                }
                                return Column(
                                  spacing: 10,
                                  children:
                                      knowledgeUnits
                                          .map(
                                            (unit) =>
                                                KnowledgeUnitRect(unit: unit),
                                          )
                                          .toList(),
                                );
                              },
                            ),
                          ],
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              if (!context.watch<KnowledgeProvider>().knowledgeLoading)
                Positioned(
                  right: 20,
                  left: 20,
                  bottom: 20,
                  child: ValueListenableBuilder<bool>(
                    valueListenable: loading,
                    builder: (context, isLoading, _) {
                      if (isLoading) {
                        return Lottie.asset(
                          "assets/anims/loading.json",
                          width: 120,
                          height: 80,
                        );
                      }

                      if (screenState == "info") {
                        return Row(
                          children: [
                            IcoTxtBtn(
                              title: "Edit",
                              onTap: () => setState(() => screenState = "edit"),
                            ),
                            const SizedBox(width: 10),
                            IcoTxtBtn(
                              title: "Delete",
                              bgColor: Colors.red,
                              onTap: () {
                                QuickAlert.show(
                                  context: context,
                                  type: QuickAlertType.confirm,
                                  text:
                                      "Are you sure you want to delete this knowledge?",
                                  onCancelBtnTap: () => context.pop(),
                                  onConfirmBtnTap: () {
                                    context.pop();
                                    onDeleteKnowledge();
                                  },
                                );
                              },
                            ),
                          ],
                        );
                      }
                      return CommonBtn(
                        title: "Save",
                        onTap: () async {
                          if (!editKnowledgeFormKey.currentState!.validate()) {
                            return;
                          }
                          FocusManager.instance.primaryFocus?.unfocus();
                          if (screenState == "create") {
                            await onCreateKnowledge();
                          } else if (screenState == "edit") {
                            QuickAlert.show(
                              context: context,
                              type: QuickAlertType.confirm,
                              text: "Are you sure you want to save changes?",
                              onCancelBtnTap: () => context.pop(),
                              onConfirmBtnTap: () async {
                                FocusManager.instance.primaryFocus?.unfocus();
                                context.pop();
                                await onUpdateKnowledge();
                                setState(() => screenState = "info");
                              },
                            );
                          }
                        },
                      );
                    },
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
