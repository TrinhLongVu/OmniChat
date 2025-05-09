import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:omni_chat/apis/mail/models/request.dart';
import 'package:omni_chat/constants/base_urls.dart';
import 'package:omni_chat/router/index.dart';
import 'package:omni_chat/services/dio_client.dart';
import 'package:quickalert/quickalert.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> respondEmail(RespondEmailRequest req) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String? accessToken = prefs.getString("access_token");

  var headers = {
    'x-jarvis-guid': '',
    'Authorization': 'Bearer $accessToken',
    'Content-Type': 'application/json',
  };

  Dio dio = DioClient(baseUrl: BaseUrls.jarvis).dio;

  try {
    Response response = await dio.post(
      "/api/v1/ai-email/",
      data: {
        "action": "Reply to this email",
        "mainIdea":
            "Thank you for the update! I will explore the new features in Wave 8.",
        "email":
            "Download Wave 8: Cascade Gets Even Smarter in JetBrains\n\nHello Surfers,\n\nWave 8 is here with some of the most requested features finally landing in the Windsurf JetBrains Plugin. If you're using IntelliJ, PyCharm, WebStorm, or GoLand — this one's for you.\n\nLet's dive right in!\n\n**Cascade Memories**\nCascade now remembers key information from your session and uses it to make better decisions later. No need to repeat yourself — just keep building.\n\nDownload\n\n**File-Based Rules**\nBring consistency to your AI workflows.\n- Add a `.windsurfrules` file to guide how Cascade behaves\n- Great for enforcing package use, syntax rules, or team preferences\n- Works out-of-the-box for any JetBrains project\n\nDownload\n\n**MCP Integration**\nConnect Cascade in JetBrains to any local MCP server.\n- Tap into external data sources without writing custom logic\n- Add tools to Cascade without code changes\n- Based on the growing open standard from Anthropic\n\nDownload\n\n**Upcoming Events**\nWant to see these features (and more) in action? We're hosting a “What's New in Windsurf” webinar on May 14 — join us for a fast-paced live walkthrough of the latest product updates, how teams are using them, and what's coming next. It's 45 minutes, practical, and packed with insights.\n\nRegister Now\n\nSmarter, Smoother, Jetbrains-Ready\n\nWave 8 brings Cascade in JetBrains to the next level—with Memories, Rules, and MCP now supported, plus dozens of thoughtful improvements to keep you in flow.\n\nReady to bring Windsurf to your team? We support enterprises of all sizes. Contact us today.\n\nSurf's up.\n\nCurious about everything we shipped? Read Blog Post\n\n900 Villa St, 94041, Mountain View\n\nThis email was sent to tt26419@gmail.com. You've received it because you've subscribed to our newsletter.\n\nView in browser | Unsubscribe",
        "availableImprovedActions": [
          "More engaging",
          "More Informative",
          "Add humor",
          "Add details",
          "More apologetic",
          "Make it polite",
          "Add clarification",
          "Simplify language",
          "Improve structure",
          "Add empathy",
          "Add a summary",
          "Insert professional jargon",
          "Make longer",
          "Make shorter",
        ],
        "metadata": {
          "context": [],
          "subject": "Wave 8: Big Updates for JetBrains Users",
          "sender": "Windsurf Team",
          "receiver": "me",
          "style": {
            "length": "long",
            "formality": "neutral",
            "tone": "friendly",
          },
        },
      },
      options: Options(headers: headers),
    );
    debugPrint(response.statusCode.toString());
    debugPrint(response.data.toString());
    switch (response.statusCode) {
      case 200:
        break;
      default:
        req.onError();
        QuickAlert.show(
          context: rootNavigatorKey.currentContext!,
          type: QuickAlertType.error,
          text: "Something went wrong! Please try again later.",
        );
    }
  } catch (e) {
    req.onError();
    debugPrint("Error: $e");
  }
}
