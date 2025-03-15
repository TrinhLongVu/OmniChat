import 'package:flutter/material.dart';
import 'package:omni_chat/constants/color.dart';

class ChatThreadRect extends StatelessWidget {
  final String title;

  const ChatThreadRect({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(left: 8),
      width: double.infinity,
      decoration: BoxDecoration(
        color: omniLightCyan,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          SizedBox(
            width: 225,
            child: Text(
              title,
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              softWrap: true,
            ),
          ),
          IconButton(
            onPressed: () {},
            icon: Icon(Icons.delete, color: Colors.red, size: 20),
          ),
        ],
      ),
    );
  }
}
