import 'dart:ui';

typedef CreatePromptRequest =
    ({
      String title,
      String content,
      String description,
      VoidCallback onSuccess,
    });

typedef GetPromptListRequest =
    ({bool isFavorite, bool isPublic, String query, String category});

typedef UpdatePromptRequest =
    ({
      String id,
      String title,
      String content,
      String description,
      VoidCallback onSuccess,
      VoidCallback onError,
    });

typedef DeletePromptRequest =
    ({String id, VoidCallback onSuccess, VoidCallback onError});

typedef ToggleFavoriteRequest = ({String id, VoidCallback onSuccess});
