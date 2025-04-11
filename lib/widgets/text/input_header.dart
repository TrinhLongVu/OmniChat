import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class InputHeader extends StatelessWidget {
  const InputHeader({
    super.key,
    required this.title,
    this.leftPadding = 8,
    this.isRequired = false,
  });

  final String title;
  final double leftPadding;
  final bool isRequired;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: leftPadding),
      child: RichText(
        text: TextSpan(
          style: TextStyle(
            fontWeight: FontWeight.w700,
            fontSize: 15,
            fontFamily: GoogleFonts.poppins().fontFamily,
          ),
          children: [
            TextSpan(text: title, style: TextStyle(color: Colors.black)),
            if (isRequired)
              TextSpan(text: " *", style: TextStyle(color: Colors.red)),
          ],
        ),
      ),
    );
  }
}
