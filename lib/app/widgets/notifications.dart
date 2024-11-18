import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'notification_class.dart';

class NotificationsView extends StatefulWidget {
  @override
  _NotificationsViewState createState() => _NotificationsViewState();
}

class _NotificationsViewState extends State<NotificationsView> {
  final List<NotificationItem> _notifications =
      []; // À remplacer par votre système de gestion d'état
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadNotifications();
  }

  void _loadNotifications() {
    setState(() => _isLoading = true);
    // TODO: Charger les notifications depuis votre backend
    // Simulation de notifications pour l'exemple
    _notifications.addAll([
      NotificationItem(
        id: '1',
        title: 'Nouveau message',
        message: 'Marie vous a envoyé un message',
        timestamp: DateTime.now().subtract(Duration(minutes: 5)),
        type: NotificationType.message,
        avatarUrl: 'https://example.com/avatar1.jpg',
      ),
      NotificationItem(
        id: '2',
        title: 'Nouvel abonné',
        message: 'Pierre a commencé à vous suivre',
        timestamp: DateTime.now().subtract(Duration(hours: 2)),
        type: NotificationType.follow,
        avatarUrl: 'https://example.com/avatar2.jpg',
      ),
      NotificationItem(
        id: '3',
        title: 'Mise à jour système',
        message: 'Une nouvelle version de l\'application est disponible',
        timestamp: DateTime.now().subtract(Duration(days: 1)),
        type: NotificationType.system,
      ),
    ]);
    setState(() => _isLoading = false);
  }

  Icon _getNotificationIcon(NotificationType type) {
    switch (type) {
      case NotificationType.message:
        return Icon(Icons.message, color: Colors.blue);
      case NotificationType.like:
        return Icon(Icons.favorite, color: Colors.red);
      case NotificationType.follow:
        return Icon(Icons.person_add, color: Colors.green);
      case NotificationType.system:
        return Icon(Icons.info, color: Colors.orange);
      case NotificationType.subscription:
        return Icon(Icons.star, color: Colors.purple);
    }
  }

  String _formatTimestamp(DateTime timestamp) {
    final now = DateTime.now();
    final difference = now.difference(timestamp);

    if (difference.inMinutes < 60) {
      return 'Il y a ${difference.inMinutes} min';
    } else if (difference.inHours < 24) {
      return 'Il y a ${difference.inHours}h';
    } else if (difference.inDays < 7) {
      return 'Il y a ${difference.inDays}j';
    } else {
      return DateFormat('dd/MM/yyyy').format(timestamp);
    }
  }

  void _markAsRead(String id) {
    setState(() {
      final notification = _notifications.firstWhere((n) => n.id == id);
      notification.isRead = true;
    });
    // TODO: Mettre à jour le statut sur le backend
  }

  void _markAllAsRead() {
    setState(() {
      for (var notification in _notifications) {
        notification.isRead = true;
      }
    });
    // TODO: Mettre à jour le statut sur le backend
  }

  void _deleteNotification(String id) {
    setState(() {
      _notifications.removeWhere((n) => n.id == id);
    });
    // TODO: Supprimer la notification sur le backend
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Notifications'),
        actions: [
          if (_notifications.any((n) => !n.isRead))
            IconButton(
              icon: Icon(Icons.done_all),
              onPressed: _markAllAsRead,
              tooltip: 'Tout marquer comme lu',
            ),
          PopupMenuButton<String>(
            onSelected: (String value) {
              switch (value) {
                case 'settings':
                  // TODO: Navigation vers les paramètres de notification
                  break;
                case 'clear':
                  setState(() {
                    _notifications.clear();
                  });
                  break;
              }
            },
            itemBuilder: (BuildContext context) => [
              // PopupMenuItem(
              //   value: 'settings',
              //   child: ListTile(
              //     leading: Icon(Icons.settings),
              //     title: Text('Paramètres'),
              //   ),
              // ),
              PopupMenuItem(
                value: 'clear',
                child: ListTile(
                  leading: Icon(Icons.clear_all),
                  title: Text('Tout effacer'),
                ),
              ),
            ],
          ),
        ],
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : _notifications.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.notifications_none,
                        size: 64,
                        color: Colors.grey,
                      ),
                      SizedBox(height: 16),
                      Text(
                        'Aucune notification',
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                )
              : RefreshIndicator(
                  onRefresh: () async {
                    // TODO: Rafraîchir les notifications
                    await Future.delayed(Duration(seconds: 1));
                    _loadNotifications();
                  },
                  child: ListView.builder(
                    itemCount: _notifications.length,
                    itemBuilder: (context, index) {
                      final notification = _notifications[index];
                      return Dismissible(
                        key: Key(notification.id),
                        background: Container(
                          color: Colors.red,
                          alignment: Alignment.centerRight,
                          padding: EdgeInsets.only(right: 16),
                          child: Icon(
                            Icons.delete,
                            color: Colors.white,
                          ),
                        ),
                        direction: DismissDirection.endToStart,
                        onDismissed: (direction) {
                          _deleteNotification(notification.id);
                        },
                        child: Container(
                          color: notification.isRead
                              ? null
                              : Colors.blue.withOpacity(0.1),
                          child: ListTile(
                            leading: notification.avatarUrl != null
                                ? CircleAvatar(
                                    backgroundImage:
                                        NetworkImage(notification.avatarUrl!),
                                  )
                                : CircleAvatar(
                                    child:
                                        _getNotificationIcon(notification.type),
                                    backgroundColor: Colors.grey[200],
                                  ),
                            title: Text(
                              notification.title,
                              style: TextStyle(
                                fontWeight: notification.isRead
                                    ? FontWeight.normal
                                    : FontWeight.bold,
                              ),
                            ),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(notification.message),
                                SizedBox(height: 4),
                                Text(
                                  _formatTimestamp(notification.timestamp),
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey,
                                  ),
                                ),
                              ],
                            ),
                            onTap: () {
                              _markAsRead(notification.id);
                              // TODO: Gérer l'action de la notification
                              if (notification.actionUrl != null) {
                                // Navigation vers l'URL d'action
                              }
                            },
                            trailing: !notification.isRead
                                ? Container(
                                    width: 8,
                                    height: 8,
                                    decoration: BoxDecoration(
                                      color: Colors.blue,
                                      shape: BoxShape.circle,
                                    ),
                                  )
                                : null,
                          ),
                        ),
                      );
                    },
                  ),
                ),
    );
  }
}
