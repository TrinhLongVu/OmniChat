import 'package:flutter/material.dart';

typedef ReplyEmailRequest =
    ({
      String sender,
      String receiver,
      String subject,
      String content,
      VoidCallback onError,
    });

typedef RespondEmailRequest = ({VoidCallback onError});
