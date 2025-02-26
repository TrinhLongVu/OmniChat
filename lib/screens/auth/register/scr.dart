import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:omni_chat/constants/color.dart';
import 'package:omni_chat/widgets/input_field.dart';

class RegisterScreen extends StatelessWidget {
  final TextEditingController emailCtrlr = TextEditingController();
  final TextEditingController passwordCtrlr = TextEditingController();

  RegisterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: Stack(
          children: [
            TextButton(
              onPressed: () {
                context.goNamed("landing");
              },
              child: const Icon(Icons.arrow_back),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: [
                  SizedBox(height: 100),
                  RichText(
                    text: const TextSpan(
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 25,
                      ),
                      children: [
                        TextSpan(
                          text: "Welcome to ",
                          style: TextStyle(color: Colors.black),
                        ),
                        TextSpan(
                          text: "Omni",
                          style: TextStyle(color: omniViolet),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    "One step away from endless AI chats! Sign up and start our conversation.",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.black.withValues(alpha: 0.55),
                    ),
                  ),
                  const SizedBox(height: 40),
                  Column(
                    children: [
                      InputField(
                        controller: emailCtrlr,
                        placeholder: "Enter your email",
                        prefixIcon: Icons.mail,
                      ),
                      SizedBox(height: 10),
                      InputField(
                        controller: passwordCtrlr,
                        placeholder: "Choose your username",
                        prefixIcon: Icons.person,
                      ),
                      const SizedBox(height: 10),
                      InputField(
                        controller: passwordCtrlr,
                        placeholder: "Enter your password",
                        prefixIcon: Icons.lock,
                        isPassword: true,
                      ),
                      const SizedBox(height: 10),
                      InputField(
                        controller: passwordCtrlr,
                        placeholder: "Confirm your password",
                        prefixIcon: Icons.lock_reset,
                        isPassword: true,
                      ),
                      const SizedBox(height: 20),
                      Container(
                        margin: const EdgeInsets.symmetric(vertical: 15),
                        width: double.infinity,
                        child: TextButton(
                          onPressed: () {},
                          style: ButtonStyle(
                            padding: WidgetStateProperty.all(
                              const EdgeInsets.symmetric(vertical: 15),
                            ),
                            backgroundColor: const WidgetStatePropertyAll(
                              omniViolet,
                            ),
                            shape: WidgetStateProperty.all(
                              const RoundedRectangleBorder(
                                borderRadius: BorderRadius.all(
                                  Radius.circular(30),
                                ), // Sharp corners
                              ),
                            ),
                          ),
                          child: const Text(
                            "Register",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  RichText(
                    text: TextSpan(
                      style: const TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 16,
                      ),
                      children: [
                        TextSpan(
                          text: "Already met? ",
                          style: TextStyle(
                            color: Colors.black.withValues(alpha: .6),
                          ),
                        ),
                        TextSpan(
                          text: "Sign In",
                          style: const TextStyle(color: omniViolet),
                          recognizer:
                              TapGestureRecognizer()
                                ..onTap = () {
                                  context.pop();
                                },
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
