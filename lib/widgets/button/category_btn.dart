import 'package:flutter/material.dart';
import 'package:omni_chat/constants/color.dart';

class CategoryBtn extends StatelessWidget {
  const CategoryBtn({super.key, required this.title, required this.filtered});

  final String title;
  final bool filtered;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 5),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30),
        border: Border.all(color: omniDarkBlue, width: 2),
        color: filtered ? omniDarkBlue : Colors.white,
      ),
      child: Text(
        title,
        style: TextStyle(
          color: filtered ? Colors.white : omniDarkBlue,
          fontSize: 15,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
