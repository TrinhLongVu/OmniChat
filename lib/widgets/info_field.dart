import 'package:flutter/material.dart';
import 'package:omni_chat/constants/color.dart';

class InfoField extends StatelessWidget {
  final String infoText;
  final double fontSz;
  final int lineNum;

  const InfoField({
    super.key,
    required this.infoText,
    this.fontSz = 14,
    this.lineNum = 1,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      enabled: true,
      readOnly: true,
      minLines: lineNum,
      maxLines: lineNum,
      initialValue: infoText,
      style: TextStyle(color: Colors.blueGrey, fontSize: fontSz),
      decoration: InputDecoration(
        filled: true,
        fillColor: omniLightCyan.withValues(alpha: 0.2),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide.none,
          borderRadius: BorderRadius.circular(20),
        ),
        disabledBorder: OutlineInputBorder(
          borderSide: BorderSide.none,
          borderRadius: BorderRadius.circular(20),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide.none,
          borderRadius: BorderRadius.circular(20),
        ),
      ),
    );
  }
}
