import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lottie/lottie.dart';
import 'package:omni_chat/apis/auth/controllers/logout.dart';
import 'package:omni_chat/apis/auth/controllers/subscribe.dart';
import 'package:omni_chat/providers/user.dart';
import 'package:omni_chat/widgets/button/profile_btn.dart';
import 'package:provider/provider.dart';
import 'package:quickalert/quickalert.dart';
import 'package:url_launcher/url_launcher.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String email = "example@example.com";
  bool loggingOut = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
            child: Column(
              children: [
                Stack(
                  alignment: Alignment.center,
                  children: [
                    Icon(Icons.account_circle_rounded, size: 200),
                    Positioned(
                      bottom: 0,
                      child: Container(
                        padding: EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color:
                              context.watch<UserProvider>().subscriptionPlan ==
                                      "Starter"
                                  ? Colors.orange
                                  : Colors.grey,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(
                          context.watch<UserProvider>().subscriptionPlan,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                Text(
                  context.watch<UserProvider>().username,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 25,
                  ),
                ),
                Text(
                  context.watch<UserProvider>().email,
                  style: const TextStyle(fontSize: 20),
                ),
                const SizedBox(height: 30),
                Wrap(
                  runSpacing: 20,
                  children: [
                    ProfileBtn(
                      icon: Icons.stars_rounded,
                      title: "Subscription Plans",
                      onNavi: () async {
                        if (context.read<UserProvider>().subscriptionPlan ==
                            "Starter") {
                          QuickAlert.show(
                            context: context,
                            type: QuickAlertType.info,
                            text:
                                "You're already on a starter plan! Enjoy using our app",
                          );
                        }
                        String? subscribeUri = await subscribe();
                        if (subscribeUri == null) return;
                        setState(() {
                          launchUrl(
                            Uri.parse(subscribeUri),
                            mode: LaunchMode.inAppBrowserView,
                          );
                        });
                      },
                    ),
                    ProfileBtn(
                      icon: Icons.lock_reset,
                      title: "Reset Password",
                      onNavi: () {
                        context.go("/me/reset-pw");
                      },
                    ),
                    ProfileBtn(
                      icon: Icons.logout_outlined,
                      title: "Logout",
                      onNavi: () async {
                        setState(() {
                          loggingOut = true;
                        });
                        await logout();
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
          loggingOut
              ? Positioned(
                child: Container(
                  width: double.infinity,
                  height: double.infinity,
                  color: Colors.white,
                  child: Lottie.asset("assets/anims/loading.json"),
                ),
              )
              : SizedBox.shrink(),
        ],
      ),
    );
  }
}
