import 'package:flutter/material.dart';
import 'package:omni_chat/constants/color.dart';

class IcoTxtBtn extends StatelessWidget {
  const IcoTxtBtn({
    super.key,
    this.icon,
    required this.title,
    this.fontSz = 18,
    this.bgColor = omniDarkBlue,
    required this.onTap,
    this.borderRadius = 30,
    this.isExpanded = true,
  });

  final IconData? icon;
  final String title;
  final double fontSz;
  final Color bgColor;
  final Function onTap;
  final double borderRadius;
  final bool isExpanded;

  @override
  Widget build(BuildContext context) {
    var widget = TextButton(
      onPressed: () => onTap(),
      style: ButtonStyle(
        padding: WidgetStateProperty.all(const EdgeInsets.all(15)),
        backgroundColor: WidgetStatePropertyAll(bgColor),
        shape: WidgetStateProperty.all(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(borderRadius)),
          ),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        spacing: 10,
        children: [
          if (icon != null) Icon(icon, color: Colors.white),
          Text(
            title,
            style: TextStyle(
              color: Colors.white,
              fontSize: fontSz,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
    if (isExpanded) {
      return Expanded(child: widget);
    }
    return TextButton(
      onPressed: () => onTap(),
      style: ButtonStyle(
        padding: WidgetStateProperty.all(const EdgeInsets.all(15)),
        backgroundColor: WidgetStatePropertyAll(bgColor),
        shape: WidgetStateProperty.all(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(borderRadius)),
          ),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        spacing: 10,
        children: [
          if (icon != null) Icon(icon, color: Colors.white),
          Text(
            title,
            style: TextStyle(
              color: Colors.white,
              fontSize: fontSz,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
