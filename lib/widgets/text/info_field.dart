import 'package:delightful_toast/delight_toast.dart';
import 'package:delightful_toast/toast/components/toast_card.dart';
import 'package:delightful_toast/toast/utils/enums.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:omni_chat/constants/color.dart';
import 'package:omni_chat/router/index.dart';
import 'package:omni_chat/widgets/shimmer/shimmer_ln.dart';

class InfoField extends StatefulWidget {
  final String infoText;
  final double fontSz;
  final int lineNum;
  final bool shimmerizing;
  final bool copiable;

  const InfoField({
    super.key,
    required this.infoText,
    this.fontSz = 14,
    this.lineNum = 1,
    this.shimmerizing = false,
    this.copiable = false,
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
    Size viewport = MediaQuery.of(context).size;
    if (widget.shimmerizing) {
      return ShimmerLine(
        height: viewport.height * 0.05 * widget.lineNum,
        color: omniLightCyan,
        borderRad: 3,
      );
    }
    return TextFormField(
      enabled: true,
      readOnly: true,
      minLines: widget.lineNum,
      maxLines: widget.lineNum,
      controller: _controller,
      style: TextStyle(color: Colors.blueGrey, fontSize: widget.fontSz),
      decoration: InputDecoration(
        suffixIcon:
            widget.copiable
                ? IconButton(
                  icon: Icon(Icons.copy),
                  onPressed: () {
                    Clipboard.setData(
                      ClipboardData(text: widget.infoText),
                    ).then((_) {
                      DelightToastBar(
                        builder: (context) {
                          return ToastCard(
                            title: Text(
                              "Copied to clipboard",
                              style: TextStyle(
                                color: omniMilk,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            color: omniLightCyan,
                          );
                        },
                        position: DelightSnackbarPosition.bottom,
                        autoDismiss: true,
                        snackbarDuration: Durations.extralong4,
                      ).show(rootNavigatorKey.currentContext!);
                    });
                  },
                )
                : null,
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
