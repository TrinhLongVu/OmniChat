import 'package:flutter/material.dart';

class Destination {
  const Destination({required this.title, this.icon = Icons.home});
  final String title;
  final IconData icon;
}

const List<Destination> mainDestinations = [
  Destination(title: "Bots", icon: Icons.smart_toy_outlined),
  Destination(title: "Knowledge", icon: Icons.lightbulb),
  Destination(title: "Mail", icon: Icons.mail),
  Destination(title: "Profile", icon: Icons.person),
];
