import 'package:flutter/material.dart';

typedef ReplyEmailRequest =
    ({
      String sender,
      String receiver,
      String subject,
      String content,
      VoidCallback onError,
    });

typedef RespondEmailRequest =
    ({
      String sender,
      String receiver,
      String subject,
      String content,
      String mainIdea,
      VoidCallback onError,
    });
