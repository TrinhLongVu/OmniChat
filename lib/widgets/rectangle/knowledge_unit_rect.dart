import 'package:flutter/material.dart';
import 'package:omni_chat/constants/color.dart';
import 'package:omni_chat/constants/knowledge_unit_type.dart';
import 'package:omni_chat/models/knowledge_unit.dart';
import 'package:omni_chat/widgets/shimmer/shimmer_ln.dart';

class KnowledgeUnitRect extends StatelessWidget {
  const KnowledgeUnitRect({
    super.key,
    required this.unit,
    this.shimmerizing = false,
  });

  final KnowledgeUnit unit;
  final bool shimmerizing;

  @override
  Widget build(BuildContext context) {
    final Size viewport = MediaQuery.of(context).size;
    return Container(
      padding: const EdgeInsets.only(right: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(width: 1.5, color: omniDarkCyan),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: KnowledgeUnitType.iconize(unit.type.toString(), size: 40),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: 3,
              children: [
                shimmerizing
                    ? ShimmerLine(
                      height: viewport.height * 0.03,
                      color: Colors.black54,
                      borderRad: 3,
                    )
                    : Text(
                      unit.name,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
