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
// Upload File To Knowledge
typedef UploadFileToKnowledgeRequest =
    ({String id, String fileName, String filePath, VoidCallback onError});
// Upload Web To Knowledge
typedef UploadWebToKnowledgeRequest =
    ({String id, String unitName, String webUrl, VoidCallback onError});
// Upload Slack To Knowledge
typedef UploadSlackToKnowledgeRequest =
    ({
      String id,
      String unitName,
      String slackWorkspace,
      String slackBotToken,
      VoidCallback onError,
    });
// Upload Confluence To Knowledge
typedef UploadConfluenceToKnowledgeRequest =
    ({
      String id,
      String unitName,
      String wikiUrl,
      String username,
      String confluenceToken,
    });
