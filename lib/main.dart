import 'package:flutter/material.dart';

void main() => runApp(const OmniChatApp());

class OmniChatApp extends StatelessWidget {
  const OmniChatApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Omni Chat',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        scaffoldBackgroundColor: const Color(0xffF9F9F9),
        useMaterial3: true,
      ),
      home: const Scaffold(),
    );
  }
}
