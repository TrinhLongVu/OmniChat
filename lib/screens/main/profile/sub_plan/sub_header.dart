import 'package:flutter/material.dart';

class SubscriptionHeader extends StatelessWidget {
  const SubscriptionHeader({
    super.key,
    required this.title,
    required this.subTitle,
    required this.mainColor,
    required this.price,
  });

  final String title;
  final String subTitle;
  final Color mainColor;
  final int price;

  @override
  Widget build(BuildContext context) {
    final Size viewport = MediaQuery.of(context).size;
    return Stack(
      children: [
        SizedBox(
          width: double.infinity,
          child: Column(
            children: [
              Container(
                alignment: Alignment.center,
                width: viewport.width * 0.6,
                height: viewport.height * 0.15,
                decoration: BoxDecoration(
                  color: mainColor,
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(20),
                    bottomRight: Radius.circular(20),
                  ),
                ),
                child: Text(
                  title,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 35,
                    color: Colors.white,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 25),
                child: Column(
                  children: [
                    Text(
                      "\$$price",
                      style: TextStyle(
                        fontSize: 35,
                        color: mainColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(subTitle, style: TextStyle(color: Colors.blueGrey)),
                  ],
                ),
              ),
            ],
          ),
        ),
        Positioned(
          left: -20,
          top: 25,
          child: Icon(Icons.circle, size: 50, color: mainColor),
        ),
        Positioned(
          left: 30,
          top: 10,
          child: Icon(
            Icons.circle,
            size: 25,
            color: mainColor.withValues(green: 0.8),
          ),
        ),
        Positioned(
          left: 25,
          top: 120,
          child: Icon(
            Icons.circle,
            size: 35,
            color: mainColor.withValues(green: 0.8),
          ),
        ),
        Positioned(
          right: 20,
          top: 30,
          child: Icon(Icons.circle, size: 32, color: mainColor),
        ),
        Positioned(
          right: 55,
          top: 155,
          child: Icon(
            Icons.circle,
            size: 20,
            color: mainColor.withValues(green: 0.8),
          ),
        ),
        Positioned(
          left: 10,
          top: 185,
          child: Icon(Icons.circle, size: 20, color: Colors.grey.shade400),
        ),
        Positioned(
          right: -20,
          top: 110,
          child: Icon(Icons.circle, size: 45, color: Colors.grey.shade400),
        ),
      ],
    );
  }
}
