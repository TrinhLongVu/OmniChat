import 'package:flutter/material.dart';
import 'package:omni_chat/constants/color.dart';

class FlexCommonBtn extends StatelessWidget {
  const FlexCommonBtn({
    super.key,
    required this.title,
    this.bgColor = omniDarkBlue,
    required this.onTap,
  });

  final String title;
  final Color bgColor;
  final Function onTap;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: TextButton(
        onPressed: () => onTap(),
        style: ButtonStyle(
          padding: WidgetStateProperty.all(
            const EdgeInsets.symmetric(vertical: 15),
          ),
          backgroundColor: WidgetStatePropertyAll(bgColor),
          shape: WidgetStateProperty.all(
            const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(
                Radius.circular(30),
              ), // Sharp corners
            ),
          ),
        ),
        child: Text(
          title,
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}
