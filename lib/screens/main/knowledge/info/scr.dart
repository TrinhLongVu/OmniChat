import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lottie/lottie.dart';
import 'package:omni_chat/apis/knowledge/controllers/create.dart';
import 'package:omni_chat/apis/knowledge/controllers/delete.dart';
import 'package:omni_chat/apis/knowledge/controllers/update.dart';
import 'package:omni_chat/models/knowledge.dart';
import 'package:omni_chat/providers/knowledge.dart';
import 'package:omni_chat/widgets/button/common_btn.dart';
import 'package:omni_chat/widgets/button/ico_txt_btn.dart';
import 'package:omni_chat/widgets/text/info_field.dart';
import 'package:omni_chat/widgets/text/input_field.dart';
import 'package:omni_chat/widgets/text/input_header.dart';
import 'package:provider/provider.dart';
import 'package:quickalert/models/quickalert_type.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';
import 'package:validatorless/validatorless.dart';

final editKnowledgeFormKey = GlobalKey<FormState>();

class KnowledgeInfoScreen extends StatefulWidget {
  final String? id;

  const KnowledgeInfoScreen({super.key, this.id});

  @override
  State<KnowledgeInfoScreen> createState() => _KnowledgeInfoScreenState();
}

class _KnowledgeInfoScreenState extends State<KnowledgeInfoScreen> {
  late TextEditingController nameCtrlr;
  late TextEditingController descriptionCtrlr;

  bool editing = false;
  String screenState = "";
  final ValueNotifier<bool> loading = ValueNotifier(false);

  @override
  void initState() {
    super.initState();
    screenState = "create";
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
                      Icon(Icons.lightbulb_circle_rounded, size: 80),
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
                              )
                              : InputField(
                                controller: descriptionCtrlr,
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
                child: ValueListenableBuilder<bool>(
                  valueListenable: loading,
                  builder: (context, loading, _) {
                    return loading
                        ? Lottie.asset(
                          "assets/anims/loading.json",
                          width: 120,
                          height: 80,
                        )
                        : (screenState == "info")
                        ? Row(
                          spacing: 10,
                          children: [
                            IcoTxtBtn(
                              title: "Edit",
                              onTap: () {
                                setState(() {
                                  screenState = "edit";
                                });
                              },
                            ),
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
                        )
                        : CommonBtn(
                          title: "Save",
                          onTap: () async {
                            if (screenState == "create") {
                              if (editKnowledgeFormKey.currentState!
                                  .validate()) {
                                FocusManager.instance.primaryFocus?.unfocus();
                                await onCreateKnowledge();
                              }
                            } else if (screenState == "edit") {
                              if (editKnowledgeFormKey.currentState!
                                  .validate()) {
                                QuickAlert.show(
                                  context: context,
                                  type: QuickAlertType.confirm,
                                  text:
                                      "Are you sure you want to save changes?",
                                  onCancelBtnTap: () => context.pop(),
                                  onConfirmBtnTap: () async {
                                    FocusManager.instance.primaryFocus
                                        ?.unfocus();
                                    context.pop();
                                    await onUpdateKnowledge();
                                    setState(() {
                                      screenState = "info";
                                    });
                                  },
                                );
                              }
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
