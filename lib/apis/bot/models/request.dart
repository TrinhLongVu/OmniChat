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
// Get Imported Knowledges
typedef GetImportedKnowledgeListRequest = ({String botId});
