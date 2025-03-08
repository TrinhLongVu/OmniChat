import 'package:flutter/material.dart';
import 'package:omni_chat/constants/color.dart';

class InputField extends StatefulWidget {
  final TextEditingController controller;
  final String placeholder;
  final IconData prefixIcon;
  final bool isPassword;
  final bool isTelNum;

  const InputField({
    super.key,
    required this.controller,
    required this.placeholder,
    required this.prefixIcon,
    this.isPassword = false,
    this.isTelNum = false,
  });

  @override
  State<InputField> createState() => _InputFieldState();
}

class _InputFieldState extends State<InputField> {
  bool isPasswordVisible = false;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: widget.controller,
      obscureText: !isPasswordVisible && widget.isPassword,
      textAlignVertical: TextAlignVertical.center,
      keyboardType: widget.isTelNum ? TextInputType.phone : TextInputType.text,
      decoration: InputDecoration(
        filled: true,
        fillColor: Color(0xff98D2C0).withValues(alpha: 0.2),
        prefixIcon: Icon(widget.prefixIcon),
        prefixIconColor: omniDarkBlue,
        focusColor: omniDarkBlue,
        hintText: widget.placeholder,
        hintStyle: const TextStyle(color: Colors.grey),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide.none,
          borderRadius: BorderRadius.circular(20),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: omniDarkBlue, width: 2),
          borderRadius: BorderRadius.circular(20),
        ),
        suffixIcon:
            widget.isPassword
                ? IconButton(
                  onPressed: () {
                    setState(() {
                      isPasswordVisible = !isPasswordVisible;
                    });
                  },
                  icon: Icon(
                    isPasswordVisible ? Icons.visibility : Icons.visibility_off,
                    color: omniDarkBlue,
                  ),
                )
                : null,
      ),
    );
  }
}
