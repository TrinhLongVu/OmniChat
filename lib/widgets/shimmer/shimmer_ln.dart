import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class ShimmerLine extends StatelessWidget {
  const ShimmerLine({
    super.key,
    required this.height,
    this.width = double.infinity,
    required this.color,
    required this.borderRad,
  });

  final double height;
  final double width;
  final Color color;
  final double borderRad;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: height,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(borderRad),
        child: Shimmer.fromColors(
          baseColor: color,
          highlightColor: Colors.grey.shade300,
          child: Container(color: color),
        ),
      ),
    );
  }
}
