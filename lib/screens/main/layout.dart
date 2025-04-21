import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:omni_chat/constants/color.dart';
import 'package:omni_chat/router/destination.dart';

class MainLayout extends StatelessWidget {
  final StatefulNavigationShell navigationShell;
  const MainLayout({super.key, required this.navigationShell});

  @override
  Widget build(BuildContext context) {
    final String currentRoute = GoRouterState.of(context).uri.toString();
    final bool isConversationScreen =
        currentRoute.contains('/bots/conversation') ||
        currentRoute.startsWith('/bots/convo/');

    return Scaffold(
      body: SafeArea(child: navigationShell),
      bottomNavigationBar:
          isConversationScreen
              ? null
              : NavigationBar(
                selectedIndex: navigationShell.currentIndex,
                onDestinationSelected: navigationShell.goBranch,
                indicatorColor: omniDarkBlue,
                backgroundColor: Colors.grey.shade200,
                destinations:
                    mainDestinations
                        .map(
                          (Destination destination) => NavigationDestination(
                            icon: Icon(destination.icon),
                            selectedIcon: Icon(
                              destination.icon,
                              color: Colors.white,
                            ),
                            label: destination.title,
                          ),
                        )
                        .toList(),
              ),
    );
  }
}
