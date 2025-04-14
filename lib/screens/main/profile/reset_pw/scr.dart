import 'package:flutter/material.dart';
import 'package:omni_chat/constants/color.dart';
import 'package:omni_chat/widgets/button/common_btn.dart';
import 'package:omni_chat/widgets/text/input_field.dart';

class ResetPasswordScreen extends StatelessWidget {
  final TextEditingController oldPwCtrlr = TextEditingController();
  ResetPasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Reset Password',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
        ),
      ),
      body: Container(
        height: double.infinity,
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          spacing: 25,
          children: [
            Icon(Icons.lock_reset, color: omniDarkBlue, size: 150),
            InputField(
              controller: oldPwCtrlr,
              placeholder: "Old Password",
              prefixIcon: Icons.lock_clock_rounded,
            ),
            InputField(
              controller: oldPwCtrlr,
              placeholder: "New Password",
              prefixIcon: Icons.lock,
            ),
            InputField(
              controller: oldPwCtrlr,
              placeholder: "Confirm New Password",
              prefixIcon: Icons.lock_reset_sharp,
            ),
            CommonBtn(title: "Reset Password", onTap: () {}),
          ],
        ),
      ),
    );
  }
}
