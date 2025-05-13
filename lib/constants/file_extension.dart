import 'package:http_parser/http_parser.dart';

enum FileExtensionType {
  docx,
  pdf,
  json,
  txt,
  html,
  java,
  cpp,
  py,
  rb,
  md,
  tex,
  php,
  pptx;

  MediaType get mediaType {
    switch (this) {
      case FileExtensionType.pdf:
        return MediaType("application", "pdf");
      case FileExtensionType.docx:
        return MediaType(
          "application",
          "vnd.openxmlformats-officedocument.wordprocessingml.document",
        );
      case FileExtensionType.json:
        return MediaType("application", "json");
      case FileExtensionType.txt:
        return MediaType("text", "plain");
      case FileExtensionType.html:
        return MediaType("text", "html");
      case FileExtensionType.java:
        return MediaType("text", "x-java");
      case FileExtensionType.cpp:
        return MediaType("text", "x-c++");
      case FileExtensionType.py:
        return MediaType("text", "x-python");
      case FileExtensionType.rb:
        return MediaType("text", "x-ruby");
      case FileExtensionType.md:
        return MediaType("text", "markdown");
      case FileExtensionType.tex:
        return MediaType("text", "x-tex");
      case FileExtensionType.php:
        return MediaType("text", "x-php");
      case FileExtensionType.pptx:
        return MediaType(
          "application",
          "vnd.openxmlformats-officedocument.presentationml.presentation",
        );
    }
  }
}
