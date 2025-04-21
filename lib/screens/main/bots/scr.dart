import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:omni_chat/constants/color.dart';
import 'package:omni_chat/providers/bot.dart';
import 'package:omni_chat/widgets/button/fit_ico_btn.dart';
import 'package:omni_chat/widgets/rectangle/bot_rect.dart';
import 'package:omni_chat/widgets/rectangle/search_box.dart';
import 'package:provider/provider.dart';
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

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<BotProvider>().loadList();
    });
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

  void scrollToSearchBar() {
    final ctx = searchBarKey.currentContext;
    if (ctx != null) {
      final box = ctx.findRenderObject() as RenderBox;
      final offset =
          box.localToGlobal(Offset.zero).dy + scrollController.offset;

      scrollController.animateTo(
        offset - searchBarHeight, // scroll to just before the search bar starts
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    Size viewport = MediaQuery.of(context).size;
    return CustomScrollView(
      controller: scrollController,
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
                      onSearch:
                          (value) =>
                              context.read<BotProvider>().searchBot(value),
                      focusNod: searchFocusNode,
                    ),
                  ),
                  IconButton(
                    onPressed: () => context.push("/bots/new"),
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
        SliverFillRemaining(
          hasScrollBody: context.watch<BotProvider>().botList.isNotEmpty,
          child: RefreshIndicator(
            onRefresh: () async {
              context.read<BotProvider>().loadList();
            },
            child: SingleChildScrollView(
              physics: AlwaysScrollableScrollPhysics(),
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight:
                      context.watch<BotProvider>().botList.isEmpty
                          ? 400
                          : MediaQuery.of(context).size.height,
                ),
                child:
                    context.watch<BotProvider>().loadingList
                        ? Column(
                          children: List.generate(
                            5,
                            (index) => BotRect(
                              id: "",
                              title: "",
                              shimmerizing: true,
                              navigateToInfo: () {},
                            ),
                          ),
                        )
                        : context.watch<BotProvider>().botList.isEmpty
                        ? Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "You don't have any bot yet",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.grey,
                                ),
                              ),
                              RichText(
                                textAlign: TextAlign.center,
                                text: TextSpan(
                                  style: TextStyle(
                                    fontSize: 18,
                                    color: Colors.grey,
                                    fontWeight: FontWeight.bold,
                                    fontFamily:
                                        GoogleFonts.poppins().fontFamily,
                                  ),
                                  children: [
                                    TextSpan(text: 'Create one of your own  '),
                                    WidgetSpan(
                                      alignment: PlaceholderAlignment.middle,
                                      child: FitIconBtn(
                                        onTap: () => context.push("/bots/new"),
                                        icon: Icons.add_circle_outline,
                                        iconColor: omniDarkBlue,
                                        iconSize: 30,
                                      ),
                                    ),
                                    TextSpan(text: '  now'),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        )
                        : Column(
                          children:
                              context.watch<BotProvider>().botList.map((bot) {
                                return BotRect(
                                  title: bot.name,
                                  subtitle: bot.description,
                                  id: bot.id,
                                  navigateToInfo:
                                      () => context.push("/bots/${bot.id}"),
                                );
                              }).toList(),
                        ),
              ),
            ),
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
