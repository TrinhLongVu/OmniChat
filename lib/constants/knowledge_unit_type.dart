import 'package:icons_plus/icons_plus.dart';

enum KnowledgeUnitType {
  slack(Brands.slack_new),
  confluence(Brands.confluence);

  final String icon;
  const KnowledgeUnitType(this.icon);

  static KnowledgeUnitType? fromString(String? type) {
    if (type == null) return null;
    for (final e in KnowledgeUnitType.values) {
      if (e.name == type) return e;
    }
    return null;
  }
}
