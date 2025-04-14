import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class ConvoBox extends StatelessWidget {
  final String? message;
  final bool isBot;
  const ConvoBox({super.key, this.message, required this.isBot});

  @override
  Widget build(BuildContext context) {
    Size viewport = MediaQuery.of(context).size;
    return Align(
      alignment: isBot ? Alignment.centerLeft : Alignment.centerRight,
      child: Container(
        width: message == null ? viewport.width * 0.3 : viewport.width * 0.75,
        margin: EdgeInsets.symmetric(horizontal: 10),
        padding: EdgeInsets.all(message == null ? 0 : 10),
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
        child:
            message == null
                ? Lottie.asset(
                  "assets/anims/loading.json",
                  width: 100,
                  height: 80,
                )
                : Text(
                  message.toString(),
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.w400),
                ),
      ),
    );
  }
}
