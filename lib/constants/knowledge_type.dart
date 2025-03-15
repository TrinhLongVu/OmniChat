import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

enum KnowledgeType {
  normal(Icons.lightbulb_circle_rounded),
  file(FontAwesomeIcons.fileZipper),
  web(Icons.wifi),
  ggdrive(FontAwesomeIcons.googleDrive),
  slack(FontAwesomeIcons.slack),
  confluence(FontAwesomeIcons.confluence);

  final IconData icon;
  const KnowledgeType(this.icon);
}
