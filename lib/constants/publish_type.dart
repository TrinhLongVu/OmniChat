import 'package:icons_plus/icons_plus.dart';

enum PublishType {
  messenger("messenger", Brands.facebook_messenger),
  slack("slack", Brands.slack_new),
  telegram("telegram", Brands.telegram_app);

  final String name;
  final String icon;
  const PublishType(this.name, this.icon);

  static PublishType fromName(String name) {
    return PublishType.values.firstWhere((e) => e.name == name);
  }
}
