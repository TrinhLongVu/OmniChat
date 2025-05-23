import 'dart:ui';

// Create Bot
typedef CreateBotRequest =
    ({
      String name,
      String instruction,
      String description,
      VoidCallback onError,
    });
// Get Bot List
typedef GetBotListRequest = ({String query});
// Get Bot Info
typedef GetBotInfoRequest = ({String id});
// Update Bot
typedef UpdateBotRequest =
    ({
      String id,
      String name,
      String instruction,
      String description,
      VoidCallback onComplete,
    });
// Delete Bot
typedef DeleteBotRequest = ({String id, VoidCallback onError});
// Chat Preview with Bot
typedef AskRequest = ({String botId, String msgContent});
// Chat with Bot
typedef ChatRequest = ({String botId, String msgContent});
// Get Bot Threads
typedef GetBotThreadsRequest = ({String botId});
// Import Knowledge
typedef ImportKnowledgeRequest = ({String botId, String knowledgeId});
// Remove Knowledge from Bot
typedef UnimportKnowledgeRequest = ({String botId, String knowledgeId});
// Get Imported Knowledges
typedef GetImportedKnowledgeListRequest = ({String botId});
// Publish Bot
// To Telegram
typedef PublishToTelegramRequest =
    ({String botId, String telegramToken, VoidCallback onError});
// To Slack
typedef PublishToSlackRequest =
    ({
      String botId,
      String botToken,
      String clientId,
      String clientSecret,
      String signingSecret,
      VoidCallback onError,
    });
// To Messenger
typedef PublishToMessengerRequest =
    ({
      String botId,
      String botToken,
      String pageId,
      String appSecret,
      VoidCallback onError,
    });
