import 'package:flutter/material.dart';

class PromptModal extends StatelessWidget {
  const PromptModal({super.key});

  @override
  Widget build(BuildContext context) {
    final Size viewport = MediaQuery.of(context).size;
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 10),
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
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  PromptRect(viewport: viewport),
                  PromptRect(viewport: viewport),
                  PromptRect(viewport: viewport),
                  PromptRect(viewport: viewport),
                  PromptRect(viewport: viewport),
                  PromptRect(viewport: viewport),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class PromptRect extends StatelessWidget {
  const PromptRect({super.key, required this.viewport});

  final Size viewport;

  @override
  Widget build(BuildContext context) {
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
                  "Grammar Corrector",
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.w900),
                ),
                Text(
                  "Improve your spelling and grammar by checking your text for errors.",
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
