import 'package:flutter/material.dart';
import 'package:omni_chat/constants/color.dart';

class CommonBtn extends StatelessWidget {
  final String title;
  final Function onTap;

  const CommonBtn({super.key, required this.title, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: TextButton(
        onPressed: () => onTap(),
        style: ButtonStyle(
          padding: WidgetStateProperty.all(
            const EdgeInsets.symmetric(vertical: 15),
          ),
          backgroundColor: const WidgetStatePropertyAll(omniDarkBlue),
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
