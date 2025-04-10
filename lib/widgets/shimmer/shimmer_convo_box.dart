import 'package:flutter/material.dart';
import 'package:omni_chat/widgets/shimmer/shimmer_ln.dart';

class ShimmerConvoBox extends StatelessWidget {
  const ShimmerConvoBox({super.key, required this.isBot});

  final bool isBot;

  @override
  Widget build(BuildContext context) {
    Size viewport = MediaQuery.of(context).size;
    return Align(
      alignment: isBot ? Alignment.centerLeft : Alignment.centerRight,
      child: Container(
        width: viewport.width * 0.75,
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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          spacing: 5,
          children:
              isBot
                  ? List.generate(14, (index) {
                    double? width = viewport.width;
                    return ShimmerLine(
                      width: index == 13 ? viewport.width * 0.3 : width,
                      height: 20,
                      color: Colors.black45,
                      borderRad: 5,
                    );
                  })
                  : List.generate(3, (index) {
                    double? width = viewport.width;
                    return ShimmerLine(
                      width: index == 2 ? viewport.width * 0.5 : width,
                      height: 20,
                      color: Colors.black45,
                      borderRad: 5,
                    );
                  }),
        ),
      ),
    );
  }
}
