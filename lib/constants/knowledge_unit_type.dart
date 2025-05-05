import 'package:flutter/material.dart';
import 'package:icons_plus/icons_plus.dart';

enum KnowledgeUnitType {
  web("web", null),
  file("file", null),
  slack("slack", Brands.slack_new),
  confluence("confluence", Brands.confluence);

  final String name;
  final String? brandCode;
  const KnowledgeUnitType(this.name, this.brandCode);

  static KnowledgeUnitType fromName(String name) {
    return KnowledgeUnitType.values.firstWhere(
      (e) => e.name == name,
      orElse: () => KnowledgeUnitType.file,
    );
  }

  static Widget iconize(String name, {double size = 24, Color? color}) {
    final unit = fromName(name);
    switch (unit) {
      case KnowledgeUnitType.web:
        return Icon(BoxIcons.bx_globe, size: size, color: color);
      case KnowledgeUnitType.file:
        return Icon(Icons.insert_drive_file, size: size, color: color);
      default:
        return Brand(unit.brandCode!, size: size);
    }
  }
}
