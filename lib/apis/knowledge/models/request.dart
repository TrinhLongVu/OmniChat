import 'dart:ui';

// Create Knowledge
typedef CreateKnowledgeRequest =
    ({String name, String description, VoidCallback onError});
// Get Knowledge List
typedef GetKnowledgeListRequest = ({String query});
// Update Knowledge
typedef UpdateKnowledgeRequest =
    ({
      String id,
      String name,
      String description,
      VoidCallback onSuccess,
      VoidCallback onError,
    });
// Delete Knowledge
typedef DeleteKnowledgeRequest = ({String id, VoidCallback onError});
// Get Knowledge Units
typedef GetKnowledgeUnitsRequest = ({String id});
// Upload Web To Knowledge
typedef UploadWebToKnowledgeRequest =
    ({String id, String unitName, String webUrl});
// Upload Slack To Knowledge
typedef UploadSlackToKnowledgeRequest =
    ({String id, String unitName, String slackWorkspace, String slackBotToken});
