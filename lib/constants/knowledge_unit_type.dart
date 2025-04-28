import 'package:icons_plus/icons_plus.dart';

enum KnowledgeUnitType {
  slack("slack", Brands.slack_new),
  confluence("confluence", Brands.confluence);

  final String icon;
  final String name;
  const KnowledgeUnitType(this.name, this.icon);

  static KnowledgeUnitType? iconize(String? type) {
    if (type == null) return null;
    for (final e in KnowledgeUnitType.values) {
      if (e.name == type) return e;
    }
    return null;
  }
}
