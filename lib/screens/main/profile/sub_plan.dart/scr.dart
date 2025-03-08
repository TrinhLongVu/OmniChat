import 'package:flutter/material.dart';
import 'package:omni_chat/constants/color.dart';
import 'package:omni_chat/screens/main/profile/sub_plan.dart/sub_detail_ln.dart';
import 'package:omni_chat/screens/main/profile/sub_plan.dart/sub_header.dart';
import 'package:omni_chat/widgets/tab_item.dart';

class SubscriptionPlanScreen extends StatelessWidget {
  const SubscriptionPlanScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            'Subscription Plan',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
          ),
          centerTitle: true,
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(40),
            child: ClipRRect(
              borderRadius: const BorderRadius.all(Radius.circular(10)),
              child: Container(
                height: 40,
                margin: const EdgeInsets.symmetric(horizontal: 20),
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.all(Radius.circular(10)),
                  color: omniLightCyan,
                ),
                child: const TabBar(
                  indicatorSize: TabBarIndicatorSize.tab,
                  dividerColor: Colors.transparent,
                  indicator: BoxDecoration(
                    color: omniDarkBlue,
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                  ),
                  labelColor: Colors.white,
                  unselectedLabelColor: Colors.black54,
                  tabs: [TabItem(title: 'Standard'), TabItem(title: 'Premium')],
                ),
              ),
            ),
          ),
        ),
        body: TabBarView(
          children: [
            Column(
              children: [
                SubscriptionHeader(
                  title: "STANDARD",
                  subTitle: "for free",
                  mainColor: Colors.blue.shade500,
                  price: 0,
                ),
                Column(
                  spacing: 25,
                  children: [
                    SubcriptionDetailLine(
                      isAvailable: true,
                      title: "Chat with up to 2 bots",
                    ),
                    SubcriptionDetailLine(
                      isAvailable: true,
                      title: "Limited to 50 tokens per day",
                    ),
                    SubcriptionDetailLine(
                      isAvailable: false,
                      title: "Share images for discussion",
                    ),
                    SubcriptionDetailLine(
                      isAvailable: false,
                      title: "Compose emails drafts",
                    ),
                    SubcriptionDetailLine(
                      isAvailable: false,
                      title: "Upload files to chat",
                    ),
                    Container(
                      margin: EdgeInsets.symmetric(horizontal: 30),
                      width: double.infinity,
                      child: TextButton(
                        onPressed: () {},
                        style: ButtonStyle(
                          backgroundColor: const WidgetStatePropertyAll(
                            Colors.blueGrey,
                          ),
                          shape: WidgetStateProperty.all(
                            const RoundedRectangleBorder(
                              borderRadius: BorderRadius.all(
                                Radius.circular(10),
                              ), // Sharp corners
                            ),
                          ),
                        ),
                        child: const Text(
                          "Current Plan",
                          style: TextStyle(color: Colors.white, fontSize: 20),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            Column(
              children: [
                SubscriptionHeader(
                  title: "PREMIUM",
                  subTitle: "per month",
                  mainColor: Colors.orange,
                  price: 20,
                ),
                Column(
                  spacing: 25,
                  children: [
                    SubcriptionDetailLine(
                      isAvailable: true,
                      title: "Unlimited bot creation",
                    ),
                    SubcriptionDetailLine(
                      isAvailable: true,
                      title: "Unlimited tokens per day",
                    ),
                    SubcriptionDetailLine(
                      isAvailable: true,
                      title: "Share images for discussion",
                    ),
                    SubcriptionDetailLine(
                      isAvailable: true,
                      title: "Compose emails drafts",
                    ),
                    SubcriptionDetailLine(
                      isAvailable: true,
                      title: "Upload files to chat",
                    ),
                    Container(
                      margin: EdgeInsets.symmetric(horizontal: 30),
                      width: double.infinity,
                      child: TextButton(
                        onPressed: () {},
                        style: ButtonStyle(
                          backgroundColor: const WidgetStatePropertyAll(
                            omniDarkBlue,
                          ),
                          shape: WidgetStateProperty.all(
                            const RoundedRectangleBorder(
                              borderRadius: BorderRadius.all(
                                Radius.circular(10),
                              ), // Sharp corners
                            ),
                          ),
                        ),
                        child: const Text(
                          "Subscribe Now",
                          style: TextStyle(color: Colors.white, fontSize: 20),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
