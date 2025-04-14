import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lottie/lottie.dart';
import 'package:omni_chat/apis/auth/controllers/get_me.dart';
import 'package:omni_chat/apis/auth/controllers/logout.dart';
import 'package:omni_chat/apis/auth/models/response.dart';
import 'package:omni_chat/widgets/button/profile_btn.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String username = "Loading...";
  String email = "example@example.com";
  bool loggingOut = false;

  @override
  void initState() {
    super.initState();
    loadUserData();
  }

  Future<void> loadUserData() async {
    GetMeResponse? fetchedUser = await getMe();
    if (mounted && fetchedUser != null) {
      setState(() {
        username = fetchedUser.username;
        email = fetchedUser.email;
      });
    }
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
                          color: Colors.grey,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(
                          "Standard",
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
                  username,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 25,
                  ),
                ),
                Text(email, style: const TextStyle(fontSize: 20)),
                const SizedBox(height: 30),
                Wrap(
                  runSpacing: 20,
                  children: [
                    ProfileBtn(
                      icon: Icons.stars_rounded,
                      title: "Subscription Plans",
                      onNavi: () {
                        context.go("/me/sub-plan");
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
