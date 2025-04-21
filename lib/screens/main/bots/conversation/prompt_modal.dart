import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:omni_chat/constants/color.dart';
import 'package:omni_chat/constants/prompt_category.dart';
import 'package:omni_chat/models/prompt.dart';
import 'package:omni_chat/providers/prompt.dart';
import 'package:omni_chat/widgets/button/category_btn.dart';
import 'package:omni_chat/widgets/popup/prompt_new.dart';
import 'package:omni_chat/widgets/rectangle/prompt_rect.dart';
import 'package:omni_chat/widgets/rectangle/search_box.dart';
import 'package:omni_chat/widgets/tab_item.dart';
import 'package:provider/provider.dart';

class PromptModal extends StatefulWidget {
  const PromptModal({super.key});

  @override
  State<PromptModal> createState() => _PromptModalState();
}

class _PromptModalState extends State<PromptModal> {
  final TextEditingController searchPromptCtrlr = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<PromptProvider>().initPromptLibrary();
    });
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
      padding: const EdgeInsets.symmetric(horizontal: 6),
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
                      context.read<PromptProvider>().searchPrompt(value);
                    },
                  ),
                ),
                IconButton(
                  onPressed: () {
                    context.read<PromptProvider>().toggleFavoriteFilter();
                  },
                  icon: Icon(
                    context.watch<PromptProvider>().favFiltered
                        ? Icons.favorite
                        : Icons.favorite_border,
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
                                    .map(
                                      (e) =>
                                          e.name ==
                                          context
                                              .watch<PromptProvider>()
                                              .filteredCategory,
                                    )
                                    .toList(),
                            onPressed: (int index) {
                              String filteredValue =
                                  context
                                      .read<PromptProvider>()
                                      .filteredCategory;
                              String strToFilter = "";
                              if (PromptCategory.values[index].name ==
                                  filteredValue) {
                                strToFilter = "";
                              } else {
                                strToFilter = PromptCategory.values[index].name;
                              }
                              context
                                  .read<PromptProvider>()
                                  .setFilteredCategory(strToFilter);
                            },
                            borderRadius: BorderRadius.circular(30),
                            children:
                                PromptCategory.values
                                    .map(
                                      (e) => CategoryBtn(
                                        title: e.name,
                                        filtered:
                                            e.name ==
                                            context
                                                .watch<PromptProvider>()
                                                .filteredCategory,
                                      ),
                                    )
                                    .toList(),
                          ),
                        ),
                      ),
                      Expanded(
                        child: RefreshIndicator(
                          color: omniDarkBlue,
                          backgroundColor: Colors.white,
                          onRefresh: () async {
                            context.read<PromptProvider>().loadList(
                              isPublic: true,
                            );
                          },
                          child: SingleChildScrollView(
                            physics: AlwaysScrollableScrollPhysics(),
                            child: ConstrainedBox(
                              constraints: BoxConstraints(
                                minHeight: MediaQuery.of(context).size.height,
                              ),
                              child: Consumer<PromptProvider>(
                                builder: (context, provider, child) {
                                  return Column(
                                    children:
                                        provider.publicLoading
                                            ? List.generate(
                                              10,
                                              (index) => PromptRect(
                                                prompt: Prompt.placeholder(),
                                                shimmerizing: true,
                                              ),
                                            ).toList()
                                            : provider.publicPrompts.isEmpty
                                            ? [
                                              SizedBox(
                                                height: viewport.height * 0.2,
                                              ),
                                              Center(
                                                child: Text(
                                                  "No public prompts meet the criteria you specified",
                                                  textAlign: TextAlign.center,
                                                ),
                                              ),
                                            ]
                                            : provider.publicPrompts
                                                .map(
                                                  (prompt) => PromptRect(
                                                    prompt: prompt,
                                                    shimmerizing: false,
                                                  ),
                                                )
                                                .toList(),
                                  );
                                },
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  RefreshIndicator(
                    color: omniDarkBlue,
                    backgroundColor: Colors.white,
                    onRefresh: () async {
                      context.read<PromptProvider>().loadList(isPublic: false);
                    },
                    child: SingleChildScrollView(
                      physics: AlwaysScrollableScrollPhysics(),
                      child: ConstrainedBox(
                        constraints: BoxConstraints(
                          minHeight: MediaQuery.of(context).size.height,
                        ),
                        child: Column(
                          children: [
                            if (context
                                .watch<PromptProvider>()
                                .privatePrompts
                                .isEmpty) ...[
                              SizedBox(height: viewport.height * 0.2),
                              Center(
                                child: Text(
                                  "You don't have any private prompts yet",
                                ),
                              ),
                            ] else ...[
                              SizedBox.shrink(),
                            ],
                            Padding(
                              padding: EdgeInsets.symmetric(vertical: 10),
                              child: TextButton(
                                onPressed: () async {
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
                            Consumer<PromptProvider>(
                              builder: (context, provider, child) {
                                return Column(
                                  children:
                                      provider.privateLoading
                                          ? List.generate(
                                            10,
                                            (index) => PromptRect(
                                              prompt: Prompt.placeholder(),
                                              shimmerizing: true,
                                            ),
                                          ).toList()
                                          : provider.privatePrompts
                                              .map(
                                                (prompt) => PromptRect(
                                                  prompt: prompt,
                                                  shimmerizing: false,
                                                ),
                                              )
                                              .toList(),
                                );
                              },
                            ),
                          ],
                        ),
                      ),
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
