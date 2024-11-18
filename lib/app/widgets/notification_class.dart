enum NotificationType { message, like, follow, system, subscription }

class NotificationItem {
  final String id;
  final String title;
  final String message;
  final DateTime timestamp;
  final NotificationType type;
  final String? avatarUrl;
  final String? actionUrl;
  bool isRead;

  NotificationItem({
    required this.id,
    required this.title,
    required this.message,
    required this.timestamp,
    required this.type,
    this.avatarUrl,
    this.actionUrl,
    this.isRead = false,
  });
}
