import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:lottie/lottie.dart';
import 'package:omni_chat/apis/auth/login.dart';
import 'package:omni_chat/constants/color.dart';
import 'package:omni_chat/widgets/button/common_btn.dart';
import 'package:omni_chat/widgets/input_field.dart';
import 'package:validatorless/validatorless.dart';

final loginFormKey = GlobalKey<FormState>();

class LoginScreen extends StatelessWidget {
  final TextEditingController emailCtrlr = TextEditingController();
  final TextEditingController passwordCtrlr = TextEditingController();
  final ValueNotifier<bool> loading = ValueNotifier(false);

  LoginScreen({super.key});

  Future<void> loginUser() async {
    if (loginFormKey.currentState!.validate()) {
      loading.value = true;
      login(
        email: emailCtrlr.text,
        password: passwordCtrlr.text,
        onError: () {
          loading.value = false;
        },
      );
    }
  }

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
                          text: "Welcome ",
                          style: TextStyle(color: Colors.black),
                        ),
                        TextSpan(
                          text: "Back",
                          style: TextStyle(color: omniDarkBlue),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    "Omni's been waiting for you! Sign in to pick up right where we left off.",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.black.withValues(alpha: 0.55),
                    ),
                  ),
                  const SizedBox(height: 40),
                  Form(
                    key: loginFormKey,
                    child: Column(
                      spacing: 10,
                      children: [
                        InputField(
                          controller: emailCtrlr,
                          placeholder: "Enter your email",
                          prefixIcon: Icons.mail,
                          validateFunc: Validatorless.multiple([
                            Validatorless.required("Email is required"),
                            Validatorless.email("Please enter a valid email"),
                          ]),
                          formKey: loginFormKey,
                        ),
                        InputField(
                          controller: passwordCtrlr,
                          placeholder: "Enter your password",
                          prefixIcon: Icons.lock,
                          isPassword: true,
                          validateFunc: Validatorless.required(
                            "Password is required",
                          ),
                          formKey: loginFormKey,
                        ),
                        const SizedBox(
                          width: double.infinity,
                          child: Text(
                            "Forgot Password?",
                            textAlign: TextAlign.end,
                            style: TextStyle(fontWeight: FontWeight.w500),
                          ),
                        ),

                        ValueListenableBuilder<bool>(
                          valueListenable: loading,
                          builder: (context, loading, _) {
                            return loading
                                ? Lottie.asset(
                                  "assets/anims/loading.json",
                                  width: 150,
                                  height: 100,
                                )
                                : CommonBtn(
                                  title: "Login",
                                  onTap: () => loginUser(),
                                );
                          },
                        ),
                      ],
                    ),
                  ),
                  const Row(
                    children: [
                      Expanded(
                        child: Divider(
                          color: Colors.grey, // Line color
                          thickness: 1, // Line thickness
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 10),
                        child: Text(
                          "Or continue with",
                          style: TextStyle(
                            color: Colors.grey, // Text color
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Expanded(
                        child: Divider(
                          color: Colors.grey, // Line color
                          thickness: 1, // Line thickness
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 30),
                    child: IconButton(
                      onPressed: () {},
                      icon: Brand(Brands.google, size: 50),
                    ),
                  ),
                  RichText(
                    text: TextSpan(
                      style: const TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 16,
                      ),
                      children: [
                        TextSpan(
                          text: "First time meet Omni? ",
                          style: TextStyle(
                            color: Colors.black.withValues(alpha: .6),
                          ),
                        ),
                        TextSpan(
                          text: "Sign Up",
                          style: const TextStyle(color: omniDarkBlue),
                          recognizer:
                              TapGestureRecognizer()
                                ..onTap = () {
                                  context.pushNamed("register");
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
