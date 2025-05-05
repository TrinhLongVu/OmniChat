import 'package:flutter/material.dart';

typedef ReplyEmailRequest =
    ({
      String action,
      String sender,
      String receiver,
      String subject,
      String content,
      String language,
      VoidCallback onError,
    });
