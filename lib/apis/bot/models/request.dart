// Create Bot
typedef CreateBotRequest =
    ({String name, String instruction, String description});
// Get Bot Info
typedef GetBotInfoRequest = ({String id});
// Update Bot
typedef UpdateBotRequest =
    ({String id, String name, String instruction, String description});
// Delete Bot
typedef DeleteBotRequest = ({String id});
