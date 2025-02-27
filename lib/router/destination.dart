import 'package:flutter/material.dart';

class Destination {
  const Destination({required this.title, this.icon = Icons.home});
  final String title;
  final IconData icon;
}

const List<Destination> mainDestinations = [
  Destination(title: "Chat", icon: Icons.chat),
  Destination(title: "Explore", icon: Icons.explore),
  Destination(title: "Create", icon: Icons.add_circle),
  Destination(title: "Message", icon: Icons.notifications),
  Destination(title: "Profile", icon: Icons.person),
];
