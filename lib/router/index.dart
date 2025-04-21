import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:omni_chat/screens/auth/login/scr.dart';
import 'package:omni_chat/screens/auth/register/scr.dart';
import 'package:omni_chat/screens/landing/scr.dart';
import 'package:omni_chat/screens/main/bots/info/scr.dart';
import 'package:omni_chat/screens/main/bots/conversation/scr.dart';
import 'package:omni_chat/screens/main/bots/scr.dart';
import 'package:omni_chat/screens/main/knowledge/info/scr.dart';
import 'package:omni_chat/screens/main/knowledge/scr.dart';
import 'package:omni_chat/screens/main/layout.dart';
import 'package:omni_chat/screens/main/mail/scr.dart';
import 'package:omni_chat/screens/main/profile/reset_pw/scr.dart';
import 'package:omni_chat/screens/main/profile/scr.dart';
import 'package:omni_chat/screens/main/profile/sub_plan/scr.dart';

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
      parentNavigatorKey: rootNavigatorKey,
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
              name: "all-bots",
              path: "/bots",
              builder: (context, state) => BotListScreen(),
              routes: [
                GoRoute(
                  name: 'bot-create',
                  path: 'new',
                  builder: (context, state) => BotInfoScreen(),
                ),
                GoRoute(
                  name: 'conversation',
                  path: 'conversation',
                  builder: (context, state) => ConversationScreen(),
                ),
                GoRoute(
                  name: 'bot-convo',
                  path: 'convo/:id',
                  builder: (context, state) {
                    final botId = state.pathParameters['id'];
                    return ConversationScreen(id: botId);
                  },
                ),
                GoRoute(
                  name: 'bot-info',
                  path: ':id',
                  builder: (context, state) {
                    final botId = state.pathParameters['id'];
                    return BotInfoScreen(id: botId);
                  },
                ),
              ],
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              name: "knowledge library",
              path: "/knowledge",
              builder: (context, state) => KnowledgeLibraryScreen(),
              routes: [
                GoRoute(
                  name: 'knowledge-create',
                  path: 'new',
                  builder: (context, state) => KnowledgeInfoScreen(),
                ),
                GoRoute(
                  name: 'knowledge-info',
                  path: ':id',
                  builder: (context, state) {
                    final knowledgeId = state.pathParameters['id'];
                    return KnowledgeInfoScreen(id: knowledgeId);
                  },
                ),
              ],
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              name: "mail",
              path: "/mail",
              builder: (context, state) => MailComposerScreen(),
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
                GoRoute(
                  name: 'reset password',
                  path: 'reset-pw',
                  builder: (context, state) => ResetPasswordScreen(),
                ),
              ],
            ),
          ],
        ),
      ],
    ),
  ],
);
