import 'package:flutter_dotenv/flutter_dotenv.dart';

class BaseUrls {
  static final String auth = dotenv.env['AUTH_API_URL'] ?? '';
  static final String jarvis = dotenv.env['JARVIS_API_URL'] ?? '';
  static final String knowledge = dotenv.env['KB_API_URL'] ?? '';
}
