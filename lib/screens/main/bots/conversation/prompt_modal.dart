import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:omni_chat/apis/prompt/get_list.dart';
import 'package:omni_chat/constants/color.dart';
import 'package:omni_chat/models/api/prompt/prompt_list_res.dart';
import 'package:omni_chat/models/prompt.dart';
import 'package:omni_chat/widgets/popup/prompt_new.dart';
import 'package:omni_chat/widgets/prompt_rect.dart';
import 'package:omni_chat/widgets/search_box.dart';
import 'package:omni_chat/widgets/tab_item.dart';

class PromptModal extends StatefulWidget {
  const PromptModal({super.key});

  @override
  State<PromptModal> createState() => _PromptModalState();
}

class _PromptModalState extends State<PromptModal> {
  final TextEditingController searchPromptCtrlr = TextEditingController();

  List<Prompt> prompts = [];

  @override
  void initState() {
    super.initState();
    loadPromptList();
  }

  Future<void> loadPromptList() async {
    PromptListResponse? promptListResponse = await getPromptList(
      isFavorite: false,
      isPublic: true,
    );
    if (mounted && promptListResponse != null) {
      setState(() {
        prompts = promptListResponse.items;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final Size viewport = MediaQuery.of(context).size;
    return Container(
      height: viewport.height * 0.8,
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: DefaultTabController(
        length: 2,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(width: 50),
                  Text(
                    "Prompt Library",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  IconButton(
                    onPressed: () {
                      context.pop();
                    },
                    icon: Icon(Icons.keyboard_arrow_down_sharp),
                  ),
                ],
              ),
            ),
            Row(
              children: [
                Expanded(
                  child: SearchBox(
                    ctrlr: searchPromptCtrlr,
                    placeholder: "Search Prompts...",
                  ),
                ),
                IconButton(
                  onPressed: () {},
                  icon: Icon(
                    Icons.favorite_border,
                    size: 25,
                    color: Colors.red,
                  ),
                ),
              ],
            ),
            SizedBox(height: 20),
            const TabBar(
              indicatorSize: TabBarIndicatorSize.tab,
              dividerColor: Colors.transparent,
              indicator: BoxDecoration(
                color: omniDarkBlue,
                borderRadius: BorderRadius.all(Radius.circular(10)),
              ),
              labelColor: Colors.white,
              unselectedLabelColor: Colors.black54,
              tabs: [TabItem(title: 'Public'), TabItem(title: 'Private')],
            ),
            Expanded(
              child: TabBarView(
                children: [
                  SingleChildScrollView(
                    child: Column(
                      children:
                          prompts
                              .map(
                                (prompt) => PromptRect(
                                  title: prompt.title,
                                  description: prompt.description.toString(),
                                ),
                              )
                              .toList(),
                    ),
                  ),
                  SingleChildScrollView(
                    child: Column(
                      children: [
                        Padding(
                          padding: EdgeInsets.symmetric(vertical: 10),
                          child: TextButton(
                            onPressed: () {
                              showDialog(
                                context: context,
                                builder: (context) => PromptCreationPopUp(),
                              );
                            },
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              spacing: 10,
                              children: [
                                Text(
                                  "Add Prompt",
                                  style: TextStyle(color: omniDarkCyan),
                                ),
                                Icon(Icons.add, color: omniDarkBlue),
                              ],
                            ),
                          ),
                        ),
                        Column(
                          children: List.generate(
                            3,
                            (index) => PromptRect(
                              title:
                                  "Grammar Corrector for English language (English (United States))",
                              description:
                                  "Improve your spelling and grammar by checking your text for errors.",
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
