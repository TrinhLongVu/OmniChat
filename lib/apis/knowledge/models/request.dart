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
