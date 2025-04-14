import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:omni_chat/apis/bot/controllers/get_list.dart';
import 'package:omni_chat/apis/bot/models/response.dart';
import 'package:omni_chat/constants/color.dart';
import 'package:omni_chat/models/bot.dart';
import 'package:omni_chat/widgets/rectangle/bot_rect.dart';
import 'package:omni_chat/widgets/rectangle/search_box.dart';
import 'package:shimmer/shimmer.dart';

class BotListScreen extends StatefulWidget {
  const BotListScreen({super.key});

  @override
  State<BotListScreen> createState() => _BotListScreenState();
}

class _BotListScreenState extends State<BotListScreen> {
  final TextEditingController searchBotCtrlr = TextEditingController();

  final GlobalKey searchBarKey = GlobalKey();
  final ScrollController scrollController = ScrollController();
  final FocusNode searchFocusNode = FocusNode();
  double searchBarHeight = 68.0;

  List<Bot> botList = [];

  @override
  void initState() {
    super.initState();
    loadBotList();

    searchFocusNode.addListener(() {
      if (searchFocusNode.hasFocus) {
        scrollToSearchBar();
      }
    });

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final ctx = searchBarKey.currentContext;
      if (ctx != null) {
        final box = ctx.findRenderObject() as RenderBox;
        setState(() {
          searchBarHeight = box.size.height;
        });
      }
    });
  }

  Future<void> loadBotList() async {
    GetBotListResponse? botListRes = await getBotList();
    if (mounted && botListRes != null) {
      setState(() {
        botList = botListRes.data;
      });
    }
  }

  void scrollToSearchBar() {
    final ctx = searchBarKey.currentContext;
    if (ctx != null) {
      Scrollable.ensureVisible(
        ctx,
        duration: const Duration(milliseconds: 300),
        alignment: 0.0, // top
        curve: Curves.easeInOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    Size viewport = MediaQuery.of(context).size;
    return CustomScrollView(
      slivers: [
        SliverAppBar(
          backgroundColor: Colors.white,
          expandedHeight: viewport.height * 0.25,
          stretch: false,
          pinned: false,
          stretchTriggerOffset: 200.0,
          flexibleSpace: FlexibleSpaceBar(
            background: GestureDetector(
              onTap: () => context.go("/bots/conversation"),
              child: Container(
                padding: const EdgeInsets.all(10),
                color: Colors.white,
                child: Column(
                  spacing: 5,
                  children: [
                    Icon(OctIcons.copilot, color: omniDarkBlue, size: 100),
                    Text(
                      "Omni Chat Bot",
                      style: TextStyle(
                        fontSize: 25,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 5,
                      ),
                      decoration: BoxDecoration(
                        color: omniDarkCyan,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Shimmer.fromColors(
                        baseColor: Colors.white,
                        highlightColor: Colors.grey.shade800,
                        child: Text(
                          "Official",
                          style: TextStyle(
                            color:
                                Colors
                                    .white, // Still needed for the shimmer child
                            fontWeight: FontWeight.bold,
                            fontSize: 13,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        SliverPersistentHeader(
          pinned: true,
          delegate: SearchBarDelegate(
            height: searchBarHeight,
            child: Container(
              key: searchBarKey,
              color: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
              child: Row(
                children: [
                  Expanded(
                    child: SearchBox(
                      ctrlr: searchBotCtrlr,
                      placeholder: "Search Bots...",
                      onSearch: () {},
                      focusNod: searchFocusNode,
                    ),
                  ),
                  IconButton(
                    onPressed: () async {
                      final result = await context.push("/bots/new");
                      if (result == true) {
                        loadBotList();
                      }
                    },
                    icon: Icon(
                      Icons.add_circle_outline,
                      size: 32,
                      color: omniDarkBlue,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),

        /// Bot List
        SliverFillRemaining(
          hasScrollBody: true,
          child: ListView.builder(
            physics: const NeverScrollableScrollPhysics(),
            itemCount: botList.length,
            itemBuilder: (context, index) {
              final bot = botList[index];
              return BotRect(
                title: bot.name,
                subtitle: bot.description,
                id: bot.id,
                navigateToInfo: () async {
                  final result = await context.push("/bots/${bot.id}");
                  if (result == null) {
                    loadBotList();
                  }
                },
              );
            },
          ),
        ),
      ],
    );
  }
}

class SearchBarDelegate extends SliverPersistentHeaderDelegate {
  final Widget child;
  final double height;

  SearchBarDelegate({required this.child, required this.height});

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    return child;
  }

  @override
  double get maxExtent => height;
  @override
  double get minExtent => height;

  @override
  bool shouldRebuild(covariant SearchBarDelegate oldDelegate) {
    return oldDelegate.height != height || oldDelegate.child != child;
  }
}
