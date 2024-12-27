class Discussion {
  final String id;
  final String name;
  final String lastMessage;
  final String avatarUrl;
  final DateTime lastMessageTime;
  final int unreadCount;

  Discussion({
    required this.id,
    required this.name,
    required this.lastMessage,
    required this.avatarUrl,
    required this.lastMessageTime,
    required this.unreadCount,
  });
}