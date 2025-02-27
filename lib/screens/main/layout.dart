import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:omni_chat/constants/color.dart';
import 'package:omni_chat/router/destination.dart';

class MainLayout extends StatelessWidget {
  final StatefulNavigationShell navigationShell;
  const MainLayout({super.key, required this.navigationShell});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(child: navigationShell),
      bottomNavigationBar: NavigationBar(
        selectedIndex: navigationShell.currentIndex,
        onDestinationSelected: navigationShell.goBranch,
        indicatorColor: omniViolet,
        backgroundColor: Color(0xffE7E7FF),
        overlayColor: WidgetStatePropertyAll(Colors.greenAccent),
        destinations:
            mainDestinations
                .map(
                  (Destination destination) => NavigationDestination(
                    icon: Icon(destination.icon),
                    selectedIcon: Icon(destination.icon, color: Colors.white),
                    label: destination.title,
                  ),
                )
                .toList(),
      ),
    );
  }
}
