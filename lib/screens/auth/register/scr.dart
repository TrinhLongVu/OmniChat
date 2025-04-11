import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lottie/lottie.dart';
import 'package:omni_chat/apis/auth/controllers/register.dart';
import 'package:omni_chat/constants/color.dart';
import 'package:omni_chat/widgets/button/common_btn.dart';
import 'package:omni_chat/widgets/text/input_field.dart';
import 'package:validatorless/validatorless.dart';

final registerFormKey = GlobalKey<FormState>();

class RegisterScreen extends StatelessWidget {
  final TextEditingController emailCtrlr = TextEditingController();
  final TextEditingController passwordCtrlr = TextEditingController();
  final TextEditingController confirmPwdCtrlr = TextEditingController();
  final ValueNotifier<bool> loading = ValueNotifier(false);

  RegisterScreen({super.key});

  Future<void> registerUser() async {
    if (registerFormKey.currentState!.validate()) {
      loading.value = true;
      FocusManager.instance.primaryFocus?.unfocus();
      if (registerFormKey.currentState!.validate()) {
        register((
          email: emailCtrlr.text,
          password: passwordCtrlr.text,
          onError: () {
            loading.value = false;
          },
        ));
      }
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
                          text: "Welcome to ",
                          style: TextStyle(color: Colors.black),
                        ),
                        TextSpan(
                          text: "Omni",
                          style: TextStyle(color: omniDarkBlue),
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
                  Form(
                    key: registerFormKey,
                    child: Column(
                      spacing: 15,
                      children: [
                        InputField(
                          controller: emailCtrlr,
                          placeholder: "Enter your email",
                          prefixIcon: Icons.mail,
                          validateFunc: Validatorless.multiple([
                            Validatorless.required("Email is required"),
                            Validatorless.email("Please enter a valid email"),
                          ]),
                          formKey: registerFormKey,
                        ),
                        InputField(
                          controller: passwordCtrlr,
                          placeholder: "Enter your password",
                          prefixIcon: Icons.lock,
                          isPassword: true,
                          validateFunc: Validatorless.multiple([
                            Validatorless.required("Password is required"),
                            Validatorless.min(
                              8,
                              "Password must contain at least 8 characters long",
                            ),
                          ]),
                          formKey: registerFormKey,
                        ),
                        InputField(
                          controller: confirmPwdCtrlr,
                          placeholder: "Confirm your password",
                          prefixIcon: Icons.lock_reset,
                          isPassword: true,
                          validateFunc: Validatorless.multiple([
                            Validatorless.compare(
                              passwordCtrlr,
                              "Passwords do not match",
                            ),
                            Validatorless.required(
                              "Confirm password is required",
                            ),
                          ]),
                          formKey: registerFormKey,
                        ),
                        const SizedBox(height: 5),
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
                                  title: "Register",
                                  onTap: () => registerUser(),
                                );
                          },
                        ),
                      ],
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
                          text: "Already met? ",
                          style: TextStyle(
                            color: Colors.black.withValues(alpha: .6),
                          ),
                        ),
                        TextSpan(
                          text: "Sign In",
                          style: const TextStyle(color: omniDarkBlue),
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
