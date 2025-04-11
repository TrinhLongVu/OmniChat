import 'package:flutter/material.dart';
import 'package:omni_chat/constants/color.dart';

class InfoField extends StatefulWidget {
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
  State<InfoField> createState() => _InfoFieldState();
}

class _InfoFieldState extends State<InfoField> {
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.infoText);
  }

  @override
  void didUpdateWidget(covariant InfoField oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.infoText != widget.infoText) {
      debugPrint(widget.infoText);
      _controller = TextEditingController(text: widget.infoText);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      enabled: true,
      readOnly: true,
      minLines: widget.lineNum,
      maxLines: widget.lineNum,
      controller: _controller,
      style: TextStyle(color: Colors.blueGrey, fontSize: widget.fontSz),
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
