import 'package:flutter/material.dart';
import 'package:icons_plus/icons_plus.dart';

enum KnowledgeUnitType {
  file("file", null),
  slack("slack", Brands.slack_new),
  confluence("confluence", Brands.confluence);

  final String name;
  final String? brandCode;
  const KnowledgeUnitType(this.name, this.brandCode);

  static Widget iconize(String name, {double size = 24, Color? color}) {
    final unit = KnowledgeUnitType.values.firstWhere(
      (e) => e.name == name,
      orElse: () => KnowledgeUnitType.file,
    );
    if (unit == KnowledgeUnitType.file) {
      return Icon(Icons.insert_drive_file, size: size, color: color);
    } else {
      return Brand(unit.brandCode!, size: size);
    }
  }
}
