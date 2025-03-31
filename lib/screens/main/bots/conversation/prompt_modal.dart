import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:omni_chat/apis/prompt/fav_add.dart';
import 'package:omni_chat/apis/prompt/fav_remove.dart';
import 'package:omni_chat/apis/prompt/get_list.dart';
import 'package:omni_chat/constants/color.dart';
import 'package:omni_chat/constants/prompt_category.dart';
import 'package:omni_chat/models/api/prompt/prompt_list_res.dart';
import 'package:omni_chat/models/prompt.dart';
import 'package:omni_chat/widgets/button/category_btn.dart';
import 'package:omni_chat/widgets/popup/prompt_new.dart';
import 'package:omni_chat/widgets/rectangle/prompt_rect.dart';
import 'package:omni_chat/widgets/search_box.dart';
import 'package:omni_chat/widgets/tab_item.dart';

class PromptModal extends StatefulWidget {
  const PromptModal({super.key});

  @override
  State<PromptModal> createState() => _PromptModalState();
}

class _PromptModalState extends State<PromptModal> {
  final TextEditingController searchPromptCtrlr = TextEditingController();

  List<Prompt> publicPrompts = [];
  List<Prompt> privatePrompts = [];
  String filteredCategory = "";
  bool favFiltered = false;

  @override
  void initState() {
    super.initState();
    loadPromptList(true, "");
    loadPromptList(false, "");
  }

  Future<void> loadPromptList(bool isPublic, String query) async {
    PromptListResponse? promptListResponse = await getPromptList(
      isFavorite: favFiltered,
      isPublic: isPublic,
      query: query,
      category: filteredCategory,
    );
    if (mounted && promptListResponse != null) {
      if (isPublic) {
        setState(() {
          publicPrompts = promptListResponse.items;
        });
      } else {
        setState(() {
          privatePrompts = promptListResponse.items;
        });
      }
    }
  }

  Future<void> toggleFavorite(Prompt prompt) async {
    if (prompt.isFavorite) {
      await removeFromFavorite(id: prompt.id);
    } else {
      await addToFavorite(id: prompt.id);
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
                    onSearch: (value) {
                      loadPromptList(true, value);
                      loadPromptList(false, value);
                    },
                  ),
                ),
                IconButton(
                  onPressed: () {
                    setState(() {
                      favFiltered = !favFiltered;
                    });
                    loadPromptList(true, "");
                    loadPromptList(false, "");
                  },
                  icon: Icon(
                    favFiltered ? Icons.favorite : Icons.favorite_border,
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
                  // PUBLIC
                  Column(
                    children: [
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: ToggleButtons(
                            splashColor: Colors.transparent,
                            renderBorder: false,
                            fillColor: Colors.transparent,
                            isSelected:
                                PromptCategory.values
                                    .map((e) => e.name == filteredCategory)
                                    .toList(),
                            onPressed: (int index) {
                              String strToFilter = "";
                              if (PromptCategory.values[index].name ==
                                  filteredCategory) {
                                strToFilter = "";
                              } else {
                                strToFilter = PromptCategory.values[index].name;
                              }
                              setState(() {
                                filteredCategory = strToFilter;
                              });
                              loadPromptList(true, searchPromptCtrlr.text);
                            },
                            borderRadius: BorderRadius.circular(30),
                            children:
                                PromptCategory.values
                                    .map(
                                      (e) => CategoryBtn(
                                        title: e.name,
                                        filtered: e.name == filteredCategory,
                                      ),
                                    )
                                    .toList(),
                          ),
                        ),
                      ),
                      Expanded(
                        child: SingleChildScrollView(
                          child: Column(
                            children:
                                publicPrompts
                                    .map(
                                      (prompt) => PromptRect(
                                        title: prompt.title,
                                        description:
                                            prompt.description.toString(),
                                        content: prompt.content.toString(),
                                        isFav: prompt.isFavorite,
                                        onHeartTap: () async {
                                          await toggleFavorite(prompt);
                                          loadPromptList(true, "");
                                        },
                                      ),
                                    )
                                    .toList(),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SingleChildScrollView(
                    child: Column(
                      children: [
                        Padding(
                          padding: EdgeInsets.symmetric(vertical: 10),
                          child: TextButton(
                            onPressed: () async {
                              final result = await showDialog(
                                context: context,
                                builder: (context) => PromptCreationPopUp(),
                              );
                              if (result == true) {
                                loadPromptList(false, "");
                              }
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
                          children:
                              privatePrompts
                                  .map(
                                    (prompt) => PromptRect(
                                      title: prompt.title,
                                      description:
                                          prompt.description.toString(),
                                      content: prompt.content.toString(),
                                      isFav: prompt.isFavorite,
                                      onHeartTap: () async {
                                        await toggleFavorite(prompt);
                                        loadPromptList(false, "");
                                      },
                                    ),
                                  )
                                  .toList(),
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
