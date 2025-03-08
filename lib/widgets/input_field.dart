import 'package:flutter/material.dart';
import 'package:omni_chat/constants/color.dart';

class InputField extends StatefulWidget {
  final TextEditingController controller;
  final String placeholder;
  final IconData prefixIcon;
  final int minLns;
  final int maxLns;
  final bool isPassword;
  final bool isTelNum;

  const InputField({
    super.key,
    required this.controller,
    required this.placeholder,
    required this.prefixIcon,
    this.isPassword = false,
    this.isTelNum = false,
    this.minLns = 1,
    this.maxLns = 1,
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
      maxLines:
          !widget.isPassword ? widget.maxLns : 1, // Allows unlimited lines
      minLines: !widget.isPassword ? widget.minLns : null,
      decoration: InputDecoration(
        filled: true,
        fillColor: omniLightCyan.withValues(alpha: 0.2),
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
