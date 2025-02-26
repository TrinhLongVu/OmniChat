import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:omni_chat/screens/auth/login/scr.dart';
import 'package:omni_chat/screens/auth/register/scr.dart';
import 'package:omni_chat/screens/landing/scr.dart';

final GlobalKey<NavigatorState> rootNavigatorKey = GlobalKey<NavigatorState>();
final GlobalKey<NavigatorState> customerShellKey = GlobalKey<NavigatorState>();

final GoRouter appRouter = GoRouter(
  navigatorKey: rootNavigatorKey,
  initialLocation: "/",
  routes: [
    GoRoute(
      name: "landing",
      path: "/",
      builder: (context, state) => LandingScreen(),
    ),
    GoRoute(
      name: "login",
      path: "/auth/login",
      builder: (context, state) => LoginScreen(),
    ),
    GoRoute(
      name: "register",
      path: "/auth/register",
      builder: (context, state) => RegisterScreen(),
    ),
  ],
);
