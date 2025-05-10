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
// Delete Knowledge Units
typedef DeleteKnowledgeUnitRequest = ({String knowledgeId, String unitId});
// Upload File To Knowledge
typedef UploadFileToKnowledgeRequest =
    ({String id, String fileName, String filePath, VoidCallback onError});
// Upload Slack To Knowledge
typedef UploadSlackToKnowledgeRequest =
    ({String id, String unitName, String slackBotToken, VoidCallback onError});
// Upload Confluence To Knowledge
typedef UploadConfluenceToKnowledgeRequest =
    ({
      String id,
      String unitName,
      String wikiUrl,
      String username,
      String confluenceToken,
      VoidCallback onError,
    });
