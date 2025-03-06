import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:omni_chat/screens/main/profile/profile_btn.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
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
              "Someone's Name",
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 25),
            ),
            Text("email_123@example.com", style: const TextStyle(fontSize: 20)),
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
                  icon: Icons.edit,
                  title: "Edit Profile",
                  onNavi: () {},
                ),
                ProfileBtn(
                  icon: Icons.lock_reset,
                  title: "Reset Password",
                  onNavi: () {},
                ),
                ProfileBtn(
                  icon: Icons.logout_outlined,
                  title: "Logout",
                  onNavi: () async {
                    context.goNamed("landing");
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
