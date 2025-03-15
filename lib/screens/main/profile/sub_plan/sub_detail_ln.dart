import 'package:flutter/material.dart';

class SubcriptionDetailLine extends StatelessWidget {
  final String title;
  final bool isAvailable;
  const SubcriptionDetailLine({
    super.key,
    required this.title,
    required this.isAvailable,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(left: 50),
      color: Color(0xffE4E4E4),
      child: Row(
        spacing: 10,
        children: [
          Icon(
            isAvailable ? Icons.check : Icons.close,
            color: isAvailable ? Colors.green : Colors.red,
            size: 30,
          ),
          Text(title, style: TextStyle(fontSize: 18, color: Colors.black)),
        ],
      ),
    );
  }
}
