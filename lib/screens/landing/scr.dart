import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:omni_chat/constants/color.dart';
import 'package:omni_chat/widgets/button/common_btn.dart';

class LandingScreen extends StatelessWidget {
  const LandingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xffE7E7FF), Color(0xffF8F8FF)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SafeArea(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(OctIcons.copilot, color: omniDarkBlue, size: 180),
                Text(
                  "Hello\nIt's Omni Bot Here\nYour Own Chat Assistant",
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 25,
                    height: 1.5,
                  ),
                ),
                const SizedBox(height: 50),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: 15,
                    horizontal: 25,
                  ),
                  child: CommonBtn(
                    title: "Continue",
                    onTap: () {
                      context.pushNamed("login");
                    },
                  ),
                ),
                SizedBox(height: 30),
                RichText(
                  textAlign: TextAlign.center,
                  text: TextSpan(
                    style: TextStyle(
                      fontWeight: FontWeight.w400,
                      fontFamily: GoogleFonts.inter().fontFamily,
                      fontSize: 14,
                      height: 1.5,
                    ),
                    children: [
                      TextSpan(
                        text: "By continuing, you agree to our\n",
                        style: TextStyle(
                          color: Colors.black.withValues(alpha: 0.4),
                        ),
                      ),
                      TextSpan(
                        text: "User Agreement",
                        style: TextStyle(
                          color: Colors.black.withValues(alpha: 0.9),
                        ),
                      ),
                      TextSpan(
                        text: " and ",
                        style: TextStyle(
                          color: Colors.black.withValues(alpha: 0.4),
                        ),
                      ),
                      TextSpan(
                        text: "Privacy Policy",
                        style: TextStyle(
                          color: Colors.black.withValues(alpha: 0.9),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
