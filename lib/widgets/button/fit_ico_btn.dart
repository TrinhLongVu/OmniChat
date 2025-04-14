import 'package:flutter/material.dart';
import 'package:omni_chat/constants/color.dart';

class FitIconBtn extends StatelessWidget {
  const FitIconBtn({
    super.key,
    required this.onTap,
    required this.icon,
    this.iconColor = omniDarkBlue,
  });

  final IconData icon;
  final Function onTap;
  final Color iconColor;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () => onTap(),
      iconSize: 20,
      padding: EdgeInsets.all(5),
      constraints: const BoxConstraints(),
      style: const ButtonStyle(tapTargetSize: MaterialTapTargetSize.shrinkWrap),
      icon: Icon(icon, color: iconColor),
    );
  }
}
