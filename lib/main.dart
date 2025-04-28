import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:omni_chat/providers/bot.dart';
import 'package:omni_chat/providers/convo.dart';
import 'package:omni_chat/providers/knowledge.dart';
import 'package:omni_chat/providers/prompt.dart';
import 'package:omni_chat/providers/user.dart';
import 'package:omni_chat/router/index.dart';
import 'package:provider/provider.dart';

Future<void> main() async {
  await dotenv.load();
  runApp(const OmniChatApp());
}

class OmniChatApp extends StatelessWidget {
  const OmniChatApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => UserProvider()),
        ChangeNotifierProvider(create: (context) => BotProvider()),
        ChangeNotifierProvider(create: (context) => KnowledgeProvider()),
        ChangeNotifierProvider(create: (context) => PromptProvider()),
        ChangeNotifierProvider(create: (context) => ConvoProvider()),
      ],
      child: MaterialApp.router(
        debugShowCheckedModeBanner: false,
        title: 'Omni Chat',
        theme: ThemeData(
          textTheme: GoogleFonts.poppinsTextTheme(),
          scaffoldBackgroundColor: const Color(0xffF9F9F9),
          useMaterial3: true,
        ),
        routerConfig: appRouter,
      ),
    );
  }
}
