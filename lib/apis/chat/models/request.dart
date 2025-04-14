import 'dart:ui';

// Get Conversation History
typedef GetConvoHistoryRequest = ({String convoId});
// Send Message
typedef SendMessageRequest =
    ({String convoId, String msgContent, VoidCallback onError});
// Get Chat Threads
typedef GetConvosRequest = ({String assistantId});
