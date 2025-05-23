import 'package:flutter/material.dart';
import 'package:omni_chat/constants/color.dart';

class InputField extends StatefulWidget {
  final TextEditingController controller;
  final String placeholder;
  final IconData? prefixIcon;
  final double? fontSz;
  final int minLns;
  final int maxLns;
  final bool isPassword;
  final bool isTelNum;
  final bool isNewLineAction;
  final FormFieldValidator<String>? validateFunc;
  final GlobalKey<FormState>? formKey;

  const InputField({
    super.key,
    required this.controller,
    required this.placeholder,
    this.prefixIcon,
    this.fontSz = 16,
    this.isPassword = false,
    this.isTelNum = false,
    this.minLns = 1,
    this.maxLns = 1,
    this.isNewLineAction = false,
    this.validateFunc,
    this.formKey,
  });

  @override
  State<InputField> createState() => _InputFieldState();
}

class _InputFieldState extends State<InputField> {
  bool isPasswordVisible = false;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.controller,
      obscureText: !isPasswordVisible && widget.isPassword,
      textInputAction:
          widget.isNewLineAction
              ? TextInputAction.newline
              : TextInputAction.done,
      textAlignVertical: TextAlignVertical.center,
      keyboardType:
          widget.isNewLineAction
              ? TextInputType.multiline
              : (widget.isTelNum ? TextInputType.phone : TextInputType.text),
      maxLines: !widget.isPassword ? widget.maxLns : 1,
      minLines: !widget.isPassword ? widget.minLns : null,
      style: TextStyle(fontSize: widget.fontSz),
      decoration: InputDecoration(
        filled: true,
        fillColor: omniLightCyan.withValues(alpha: 0.2),
        prefixIcon: widget.prefixIcon != null ? Icon(widget.prefixIcon) : null,
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
        errorStyle: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
        errorBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.red, width: 1.5),
          borderRadius: BorderRadius.circular(20),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderSide: BorderSide(color: omniDarkBlue, width: 2),
          borderRadius: BorderRadius.circular(20),
        ),
      ),
      validator: widget.validateFunc,
      onEditingComplete: () {
        widget.formKey?.currentState?.validate();
        FocusScope.of(context).unfocus();
      },
    );
  }
}
