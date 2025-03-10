import 'package:flutter/material.dart';

class ConvoBox extends StatelessWidget {
  final String message;
  final bool isBot;
  const ConvoBox({super.key, required this.message, required this.isBot});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: isBot ? Alignment.centerLeft : Alignment.centerRight,
      child: Container(
        width: 280,
        margin: EdgeInsets.symmetric(horizontal: 10),
        padding: EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
            bottomLeft: isBot ? Radius.circular(0) : Radius.circular(20),
            bottomRight: isBot ? Radius.circular(20) : Radius.circular(0),
          ),
          boxShadow: [
            BoxShadow(color: Colors.grey, blurRadius: 1, offset: Offset(2, 2)),
          ],
        ),
        child: Text(
          message,
          style: TextStyle(fontSize: 15, fontWeight: FontWeight.w400),
        ),
      ),
    );
  }
}
