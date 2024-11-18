class Message {
  final String id;
  final String content;
  final String senderId;
  final String senderName;
  final String? senderAvatar;
  final DateTime timestamp;

  Message({
    required this.id,
    required this.content,
    required this.senderId,
    required this.senderName,
    this.senderAvatar,
    required this.timestamp,
  });
}
