import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:nom_du_projet/app/widgets/message_classe.dart';

class ChatView extends StatefulWidget {
  final String currentUserId;
  final String recipientId;
  final String recipientName;
  final String? recipientAvatar;

  ChatView({
    required this.currentUserId,
    required this.recipientId,
    required this.recipientName,
    this.recipientAvatar,
  });

  @override
  _ChatViewState createState() => _ChatViewState();
}

class _ChatViewState extends State<ChatView> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final List<Message> _messages =
      []; // À remplacer par votre système de gestion d'état
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadMessages();
  }

  void _loadMessages() async {
    setState(() => _isLoading = true);
    // TODO: Charger les messages depuis votre backend
    // Simulation de messages pour l'exemple
    _messages.addAll([
      Message(
        id: '1',
        content: 'Bonjour !',
        senderId: widget.recipientId,
        senderName: widget.recipientName,
        timestamp: DateTime.now().subtract(Duration(minutes: 5)),
      ),
      Message(
        id: '2',
        content: 'Salut, comment ça va ?',
        senderId: widget.currentUserId,
        senderName: 'Moi',
        timestamp: DateTime.now().subtract(Duration(minutes: 4)),
      ),
    ]);
    setState(() => _isLoading = false);
  }

  void _sendMessage() async {
    if (_messageController.text.trim().isEmpty) return;

    final newMessage = Message(
      id: DateTime.now().toString(), // À remplacer par un vrai ID
      content: _messageController.text,
      senderId: widget.currentUserId,
      senderName: 'Moi',
      timestamp: DateTime.now(),
    );

    setState(() {
      _messages.add(newMessage);
      _messageController.clear();
    });

    // Faire défiler jusqu'au dernier message
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });

    // TODO: Envoyer le message à votre backend
  }

  Widget _buildMessageBubble(Message message) {
    final isCurrentUser = message.senderId == widget.currentUserId;
    final bubbleColor = isCurrentUser ? Colors.blue : Colors.grey[300];
    final textColor = isCurrentUser ? Colors.white : Colors.black;
    final alignment =
        isCurrentUser ? MainAxisAlignment.end : MainAxisAlignment.start;

    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4, horizontal: 16),
      child: Row(
        mainAxisAlignment: alignment,
        children: [
          if (!isCurrentUser && message.senderAvatar != null) ...[
            CircleAvatar(
              backgroundImage: NetworkImage(message.senderAvatar!),
              radius: 16,
            ),
            SizedBox(width: 8),
          ],
          Flexible(
            child: Column(
              crossAxisAlignment: isCurrentUser
                  ? CrossAxisAlignment.end
                  : CrossAxisAlignment.start,
              children: [
                if (!isCurrentUser)
                  Padding(
                    padding: EdgeInsets.only(left: 8, bottom: 4),
                    child: Text(
                      message.senderName,
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[600],
                      ),
                    ),
                  ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  decoration: BoxDecoration(
                    color: bubbleColor,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        message.content,
                        style: TextStyle(color: textColor),
                      ),
                      SizedBox(height: 4),
                      Text(
                        DateFormat('HH:mm').format(message.timestamp),
                        style: TextStyle(
                          fontSize: 10,
                          color:
                              isCurrentUser ? Colors.white70 : Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          if (isCurrentUser && message.senderAvatar != null) ...[
            SizedBox(width: 8),
            CircleAvatar(
              backgroundImage: NetworkImage(message.senderAvatar!),
              radius: 16,
            ),
          ],
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            if (widget.recipientAvatar != null)
              CircleAvatar(
                backgroundImage: NetworkImage(widget.recipientAvatar!),
                radius: 20,
              ),
            SizedBox(width: 8),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(widget.recipientName),
                Text(
                  'En ligne', // À remplacer par le vrai statut
                  style: TextStyle(fontSize: 12),
                ),
              ],
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.more_vert),
            onPressed: () {
              // TODO: Ajouter un menu d'options
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: _isLoading
                ? Center(child: CircularProgressIndicator())
                : ListView.builder(
                    controller: _scrollController,
                    padding: EdgeInsets.only(top: 8, bottom: 8),
                    itemCount: _messages.length,
                    itemBuilder: (context, index) {
                      return _buildMessageBubble(_messages[index]);
                    },
                  ),
          ),
          Container(
            decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                  color: Colors.black12,
                  offset: Offset(0, -2),
                  blurRadius: 4,
                ),
              ],
            ),
            child: Padding(
              padding: EdgeInsets.all(8),
              child: Row(
                children: [
                  IconButton(
                    icon: Icon(Icons.attach_file),
                    onPressed: () {
                      // TODO: Implémenter l'envoi de fichiers
                    },
                  ),
                  Expanded(
                    child: TextField(
                      controller: _messageController,
                      decoration: InputDecoration(
                        hintText: 'Écrivez votre message...',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(24),
                        ),
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                      ),
                      maxLines: null,
                      textCapitalization: TextCapitalization.sentences,
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.send),
                    onPressed: _sendMessage,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }
}
