import 'dart:ui';

// Create Knowledge
typedef CreateKnowledgeRequest =
    ({String name, String description, VoidCallback onError});
// Get Knowledge List
typedef GetKnowledgeListRequest = ({String query});
// Delete Knowledge
typedef DeleteKnowledgeRequest = ({String id, VoidCallback onError});
