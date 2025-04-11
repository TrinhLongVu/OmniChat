import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lottie/lottie.dart';
import 'package:omni_chat/apis/prompt/controllers/delete.dart';
import 'package:omni_chat/apis/prompt/controllers/fav_add.dart';
import 'package:omni_chat/apis/prompt/controllers/fav_remove.dart';
import 'package:omni_chat/apis/prompt/controllers/update.dart';
import 'package:omni_chat/constants/color.dart';
import 'package:omni_chat/models/prompt.dart';
import 'package:omni_chat/providers/convo.dart';
import 'package:omni_chat/providers/prompt.dart';
import 'package:omni_chat/widgets/button/ico_txt_btn.dart';
import 'package:omni_chat/widgets/text/info_field.dart';
import 'package:omni_chat/widgets/text/input_field.dart';
import 'package:omni_chat/widgets/text/input_header.dart';
import 'package:provider/provider.dart';
import 'package:quickalert/quickalert.dart';
import 'package:validatorless/validatorless.dart';

final editPromptFormKey = GlobalKey<FormState>();

class PromptInfoPopUp extends StatefulWidget {
  const PromptInfoPopUp({super.key, required this.prompt, required this.used});

  final Prompt prompt;
  final bool used;

  @override
  State<PromptInfoPopUp> createState() => _PromptInfoPopUpState();
}

class _PromptInfoPopUpState extends State<PromptInfoPopUp> {
  bool editing = false;
  String promptTitle = "";
  String promptContent = "";
  String promptDescription = "";

  late bool isFavorite;
  late TextEditingController nameCtrlr;
  late TextEditingController contentCtrlr;
  late TextEditingController descriptionCtrlr;

  final ValueNotifier<bool> loading = ValueNotifier(false);

  @override
  void initState() {
    super.initState();
    isFavorite = widget.prompt.isFavorite;
    nameCtrlr = TextEditingController(text: widget.prompt.title);
    contentCtrlr = TextEditingController(text: widget.prompt.content);
    descriptionCtrlr = TextEditingController(text: widget.prompt.description);
    promptTitle = widget.prompt.title;
    promptContent = widget.prompt.content;
    promptDescription = widget.prompt.description.toString();
  }

  void toggleFavorite() async {
    if (isFavorite) {
      await removeFromFavorite((
        id: widget.prompt.id,
        onSuccess: () {
          context.read<PromptProvider>().load2List();
          setState(() {
            isFavorite = !isFavorite;
          });
        },
      ));
    } else {
      await addToFavorite((
        id: widget.prompt.id,
        onSuccess: () {
          context.read<PromptProvider>().load2List();
          setState(() {
            isFavorite = !isFavorite;
          });
        },
      ));
    }
  }

  Future<void> updateThisPrompt() async {
    if (editPromptFormKey.currentState!.validate()) {
      QuickAlert.show(
        context: context,
        type: QuickAlertType.confirm,
        title: "Save changes?",
        text: "Are you sure you want to update this prompt?",
        confirmBtnText: "Yes",
        cancelBtnText: "No",
        onConfirmBtnTap: () async {
          FocusManager.instance.primaryFocus?.unfocus();
          loading.value = true;
          context.pop();
          await updatePrompt((
            id: widget.prompt.id,
            title: nameCtrlr.text,
            content: contentCtrlr.text,
            description: descriptionCtrlr.text,
            onSuccess: () {
              setState(() {
                promptTitle = nameCtrlr.text;
                promptContent = contentCtrlr.text;
                promptDescription = descriptionCtrlr.text;
                editing = !editing;
              });
              loading.value = false;
              context.read<PromptProvider>().loadList(isPublic: false);
            },
            onError: () {
              loading.value = false;
            },
          ));
        },
      );
    }
  }

  Future<void> deleteThisPrompt() async {
    QuickAlert.show(
      context: context,
      type: QuickAlertType.confirm,
      text: 'Are you sure you want to delete this prompt?',
      onCancelBtnTap: () {
        context.pop();
      },
      onConfirmBtnTap: () async {
        context.pop();
        loading.value = true;
        await deletePrompt((
          id: widget.prompt.id,
          onSuccess: () {
            context.read<PromptProvider>().loadList(isPublic: false);
          },
          onError: () {
            loading.value = false;
          },
        ));
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: EdgeInsets.all(10),
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          color: Colors.white,
        ),
        padding: EdgeInsets.fromLTRB(15, 20, 15, 10),
        child: SingleChildScrollView(
          child: Form(
            key: editPromptFormKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: 8,
              children: [
                editing
                    ? Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      spacing: 10,
                      children: [
                        Center(
                          child: Text(
                            "Editing Prompt",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        InputHeader(
                          title: "Name",
                          leftPadding: 0,
                          isRequired: true,
                        ),
                        InputField(
                          controller: nameCtrlr,
                          placeholder: "Name of the prompt",
                          fontSz: 14,
                          validateFunc: Validatorless.required(
                            "Prompt's name is required",
                          ),
                          formKey: editPromptFormKey,
                        ),
                      ],
                    )
                    : Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          spacing: 10,
                          children: [
                            Icon(
                              Icons.sticky_note_2_rounded,
                              color: omniDarkCyan,
                              size: 25,
                            ),
                            SizedBox(
                              width: 255,
                              child: Text(
                                promptTitle,
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                softWrap: false,
                              ),
                            ),
                          ],
                        ),
                        IconButton(
                          onPressed: () => toggleFavorite(),
                          icon: Icon(
                            Icons.favorite,
                            size: 20,
                            color: isFavorite ? Colors.red : Colors.grey,
                          ),
                        ),
                      ],
                    ),
                promptDescription != "" && !editing
                    ? Text(
                      promptDescription,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: Colors.black45,
                      ),
                    )
                    : SizedBox.shrink(),
                InputHeader(
                  title: "Prompt",
                  leftPadding: 0,
                  isRequired: editing,
                ),
                editing
                    ? InputField(
                      controller: contentCtrlr,
                      placeholder:
                          "e.g: Write an article about [TOPIC], make sure to include these keywords: [KEYWORDS]",
                      minLns: 3,
                      maxLns: 5,
                      formKey: editPromptFormKey,
                    )
                    : InfoField(infoText: promptContent, lineNum: 5),
                if (editing) ...[
                  InputHeader(
                    title: "Description",
                    leftPadding: 0,
                    isRequired: false,
                  ),
                  InputField(
                    controller: descriptionCtrlr,
                    placeholder: "Note for usage information",
                    minLns: 2,
                    maxLns: 3,
                    formKey: editPromptFormKey,
                  ),
                ] else
                  SizedBox.shrink(),
                ValueListenableBuilder<bool>(
                  valueListenable: loading,
                  builder: (context, loading, _) {
                    if (loading) {
                      return Center(
                        child: Lottie.asset(
                          "assets/anims/loading.json",
                          width: 120,
                          height: 120,
                        ),
                      );
                    }
                    return Column(
                      spacing: 8,
                      children: [
                        !widget.prompt.isPublic && !editing
                            ? Padding(
                              padding: const EdgeInsets.symmetric(vertical: 10),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  IcoTxtBtn(
                                    icon: Icons.edit,
                                    title: "Edit",
                                    fontSz: 14,
                                    bgColor: Colors.green,
                                    onTap: () {
                                      setState(() {
                                        editing = !editing;
                                      });
                                    },
                                    borderRadius: 5,
                                    isExpanded: false,
                                  ),
                                  IcoTxtBtn(
                                    icon: Icons.delete,
                                    title: "Delete",
                                    fontSz: 14,
                                    bgColor: Colors.red,
                                    onTap: () => deleteThisPrompt(),
                                    borderRadius: 5,
                                    isExpanded: false,
                                  ),
                                ],
                              ),
                            )
                            : SizedBox.shrink(),
                        Row(
                          mainAxisAlignment:
                              widget.prompt.isPublic
                                  ? MainAxisAlignment.end
                                  : MainAxisAlignment.center,
                          spacing: 10,
                          children: [
                            widget.prompt.isPublic || editing
                                ? TextButton(
                                  onPressed: () {
                                    if (editing) {
                                      setState(() {
                                        editing = !editing;
                                      });
                                    } else {
                                      context.pop();
                                    }
                                  },
                                  child: Text(widget.used ? "Close" : "Cancel"),
                                )
                                : SizedBox.shrink(),
                            !widget.used
                                ? IcoTxtBtn(
                                  icon: editing ? Icons.save : null,
                                  title: editing ? "Save" : "Use this prompt",
                                  onTap: () {
                                    if (editing) {
                                      updateThisPrompt();
                                    } else {
                                      context.read<ConvoProvider>().setPrompt(
                                        widget.prompt,
                                      );
                                      context.pop();
                                      context.pop();
                                    }
                                  },
                                  fontSz: 14,
                                  borderRadius: editing ? 5 : 30,
                                  isExpanded: false,
                                )
                                : SizedBox.shrink(),
                          ],
                        ),
                      ],
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
