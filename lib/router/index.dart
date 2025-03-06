import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:omni_chat/screens/auth/login/scr.dart';
import 'package:omni_chat/screens/auth/register/scr.dart';
import 'package:omni_chat/screens/landing/scr.dart';
import 'package:omni_chat/screens/main/chat/conversation/scr.dart';
import 'package:omni_chat/screens/main/chat/scr.dart';
import 'package:omni_chat/screens/main/layout.dart';
import 'package:omni_chat/screens/main/profile/scr.dart';
import 'package:omni_chat/screens/main/profile/sub_plan.dart/scr.dart';

final GlobalKey<NavigatorState> rootNavigatorKey = GlobalKey<NavigatorState>();

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
    StatefulShellRoute.indexedStack(
      builder:
          (context, state, navigationShell) =>
              MainLayout(navigationShell: navigationShell),
      branches: [
        StatefulShellBranch(
          routes: [
            GoRoute(
              name: "all-chats",
              path: "/chats",
              builder: (context, state) => const ChatScreen(),
              routes: [
                GoRoute(
                  name: 'conversation',
                  path: 'conversation',
                  builder: (context, state) => ConversationScreen(),
                ),
              ],
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              name: "explore",
              path: "/explore",
              builder: (context, state) => const Text("Explore"),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              name: "create",
              path: "/new",
              builder: (context, state) => const Text("Create"),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              name: "messages",
              path: "/messages",
              builder: (context, state) => const Text("Messages"),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              name: "profile",
              path: "/me",
              builder: (context, state) => const ProfileScreen(),
              routes: [
                GoRoute(
                  name: 'subscription',
                  path: 'sub-plan',
                  builder: (context, state) => const SubscriptionPlanScreen(),
                ),
              ],
            ),
          ],
        ),
      ],
    ),
  ],
);
