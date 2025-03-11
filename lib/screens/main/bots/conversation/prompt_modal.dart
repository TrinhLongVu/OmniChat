import 'package:flutter/material.dart';
import 'package:omni_chat/constants/color.dart';
import 'package:omni_chat/widgets/search_box.dart';
import 'package:omni_chat/widgets/tab_item.dart';

class PromptModal extends StatelessWidget {
  final TextEditingController searchPromptCtrlr = TextEditingController();

  PromptModal({super.key});

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
              padding: const EdgeInsets.symmetric(vertical: 20),
              child: Text(
                "Prompt Library",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
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
                      children: List.generate(
                        9,
                        (index) => PromptRect(
                          title:
                              "Grammar Corrector for English language (English (United States))",
                          description:
                              "Improve your spelling and grammar by checking your text for errors.",
                        ),
                      ),
                    ),
                  ),
                  SingleChildScrollView(
                    child: Column(
                      children: [
                        Padding(
                          padding: EdgeInsets.symmetric(vertical: 10),
                          child: TextButton(
                            onPressed: () {},
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

class PromptRect extends StatelessWidget {
  const PromptRect({super.key, required this.title, required this.description});

  final String title;
  final String description;

  @override
  Widget build(BuildContext context) {
    final Size viewport = MediaQuery.of(context).size;
    return Container(
      padding: EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.symmetric(
          horizontal: BorderSide(
            width: 0.5,
            color: Colors.black.withValues(alpha: 0.1),
          ),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: viewport.width * .7,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.w900),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  softWrap: false,
                ),
                Text(
                  description,
                  style: TextStyle(fontSize: 13, color: Colors.black54),
                ),
              ],
            ),
          ),
          Row(
            children: [
              IconButton(
                onPressed: () {},
                icon: Icon(Icons.favorite, size: 18),
              ),
              IconButton(
                onPressed: () {},
                icon: Icon(Icons.info_outline_rounded, size: 18),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
