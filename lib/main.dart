import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:omni_chat/providers/chat.dart';
import 'package:omni_chat/providers/prompt.dart';
import 'package:omni_chat/router/index.dart';
import 'package:provider/provider.dart';

void main() => runApp(const OmniChatApp());

class OmniChatApp extends StatelessWidget {
  const OmniChatApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => PromptProvider()),
        ChangeNotifierProvider(create: (context) => ChatProvider()),
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
