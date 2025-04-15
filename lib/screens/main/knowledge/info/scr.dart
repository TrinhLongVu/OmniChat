import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:omni_chat/apis/knowledge/controllers/create.dart';
import 'package:omni_chat/models/knowledge.dart';
import 'package:omni_chat/widgets/button/common_btn.dart';
import 'package:omni_chat/widgets/text/info_field.dart';
import 'package:omni_chat/widgets/text/input_field.dart';
import 'package:omni_chat/widgets/text/input_header.dart';
import 'package:validatorless/validatorless.dart';

final editKnowledgeFormKey = GlobalKey<FormState>();

class KnowledgeInfoScreen extends StatefulWidget {
  final Knowledge? knowledge;

  const KnowledgeInfoScreen({super.key, this.knowledge});

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
    nameCtrlr = TextEditingController(text: widget.knowledge?.name ?? "");
    descriptionCtrlr = TextEditingController(
      text: widget.knowledge?.description ?? "",
    );
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

  @override
  Widget build(BuildContext context) {
    bool editable = widget.knowledge != null;
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
                          InputHeader(title: "Name", isRequired: !editable),
                          (screenState == "info")
                              ? InfoField(
                                infoText: widget.knowledge?.name ?? "",
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
                                infoText: widget.knowledge?.description ?? "",
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
                        : CommonBtn(
                          title: "Save",
                          onTap: () async {
                            if (screenState == "create") {
                              if (editKnowledgeFormKey.currentState!
                                  .validate()) {
                                FocusManager.instance.primaryFocus?.unfocus();
                                await onCreateKnowledge();
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
