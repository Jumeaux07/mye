import 'dart:developer';
import 'dart:io';
import 'package:bubble/bubble.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_ui/flutter_chat_ui.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:open_filex/open_filex.dart';
import 'package:path_provider/path_provider.dart';
import 'package:get/get.dart';
import 'package:mime/mime.dart';
import '../../../data/constant.dart';
import '../controllers/message_controller.dart';

class MessageView extends GetView<MessageController> {
  const MessageView({super.key});

  @override
  Widget build(BuildContext context) {
    controller.getMessages(Get.arguments['conversationId'].toString());
    log(Get.arguments.toString());

    return Scaffold(
      appBar: AppBar(
        title: Text('${Get.arguments['receiverName']}'),
        elevation: 1,
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: CircleAvatar(
              backgroundImage: NetworkImage(
                Get.arguments['receiverPhoto'] ??
                    "https://img.freepik.com/vecteurs-premium/icone-profil-utilisateur-dans-style-plat-illustration-vectorielle-avatar-membre-fond-isole-concept-entreprise-signe-autorisation-humaine_157943-15752.jpg?w=996",
              ),
            ),
          ),
        ],
      ),
      body: controller.obx(
        onEmpty: const Center(
          child: Text('Aucun message'),
        ),
        onLoading: const Center(
          child: CircularProgressIndicator(),
        ),
        onError: (error) => Center(
          child: Text(error.toString()),
        ),
        (state) => Chat(
          customStatusBuilder: (message, {required context}) =>
              Icon(Icons.done_all),
          emptyState: const Center(
            child: Text('Aucun message'),
          ),
          hideBackgroundOnEmojiMessages: false,
          theme: DefaultChatTheme(
            errorColor: Colors.red,
            userAvatarNameColors: [Colors.white],
            secondaryColor: Colors.grey,
            primaryColor: yellowColor,
            inputTextColor: Colors.white,
            seenIcon: const Icon(
              Icons.done_all,
              size: 20,
              color: Colors.blue,
            ),
          ),

          messages: _mapMessages(),
          onAttachmentPressed: _handleAttachmentPressed,
          onMessageTap: _handleMessageTap,
          onPreviewDataFetched: _handlePreviewDataFetched,
          onSendPressed: _handleSendPressed,
          // bubbleBuilder: _bubbleBuilder,
          showUserAvatars: true,
          showUserNames: true,
          user: types.User(
              id: Env.userAuth.id.toString(),
              firstName: Env.userAuth.getFullName()
              // Optionnel : ajouter le nom de l'utilisateur connecté
              ),
        ),
      ),
    );
  }

/**
 * Créez un widget Bubble personnalisé pour les messages
 */
  Widget _bubbleBuilder(
    Widget child, {
    required message,
    required nextMessageInGroup,
  }) =>
      Bubble(
        child: child,
        color: Env.userAuth.id == message.author.id ||
                message.type == types.MessageType.image
            ? const Color(0xfff5f5f7)
            : yellowColor,
        margin: nextMessageInGroup
            ? const BubbleEdges.symmetric(horizontal: 6)
            : null,
        nip: nextMessageInGroup
            ? BubbleNip.no
            : Env.userAuth.id == message.author.id
                ? BubbleNip.leftBottom
                : BubbleNip.rightBottom,
      );

  List<types.Message> _mapMessages() {
    return controller.messages.map((msg) {
      // Créer l'auteur en fonction de l'expéditeur
      final author = types.User(
        id: msg.expediteurId.toString(),
        // Vous pouvez ajouter d'autres propriétés comme le nom si disponible
        firstName: msg.expediteurId.toString() == Env.userAuth.toString()
            ? "Moi"
            : Get.arguments['receiverName'],
        imageUrl: msg.expediteurId.toString() == Env.userAuth.toString()
            ? Env.userAuth.profileImage
            : Get.arguments['receiverPhoto'],
      );

      // Si c'est un message avec fichier
      if (msg.fichier != null) {
        final mimeType =
            lookupMimeType(msg.fichier!) ?? 'application/octet-stream';
        final isImage = mimeType.startsWith('image/');

        if (isImage) {
          return types.ImageMessage(
            author: author, // Utilisez l'auteur créé
            createdAt: msg.createdAt?.millisecondsSinceEpoch,
            id: msg.id.toString(),
            name: msg.fichier!.split('/').last,
            size: 0,
            uri: msg.fichier!,
          );
        } else {
          return types.FileMessage(
            author: author, // Utilisez l'auteur créé
            createdAt: msg.createdAt?.millisecondsSinceEpoch,
            id: msg.id.toString(),
            name: msg.fichier!.split('/').last,
            size: 0,
            uri: msg.fichier!,
          );
        }
      }

      // Message texte normal
      return types.TextMessage(
        author: author, // Utilisez l'auteur créé
        createdAt: msg.createdAt?.millisecondsSinceEpoch,
        id: msg.id.toString(),
        text: msg.contenu ?? '',
      );
    }).toList();
  }

  void _handleAttachmentPressed() {
    showModalBottomSheet<void>(
      context: Get.context!,
      builder: (BuildContext context) => SafeArea(
        child: SizedBox(
          height: 100,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  _handleImageSelection();
                },
                child: const Align(
                  alignment: AlignmentDirectional.centerStart,
                  child: Text('image'),
                ),
              ),
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Align(
                  alignment: AlignmentDirectional.centerStart,
                  child: Text('Retour'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _handleFileSelection() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.any,
      allowMultiple: false,
    );

    if (result != null && result.files.single.path != null) {
      final file = File(result.files.single.path!);

      controller.sendFile(
        Get.arguments['conversationId'] ?? null,
        Get.arguments['receiverId'] ?? '',
        file,
      );
    }
  }

  void _handleImageSelection() async {
    final result = await ImagePicker().pickImage(
      imageQuality: 70,
      maxWidth: 1440,
      source: ImageSource.gallery,
    );

    if (result != null) {
      final file = File(result.path);
      controller.sendFile(
        Get.arguments['conversationId'],
        Get.arguments['receiverId'] ?? '',
        file,
      );
    }
  }

  void _handleMessageTap(BuildContext context, types.Message message) async {
    if (message is types.FileMessage) {
      var localPath = message.uri;

      if (message.uri.startsWith('http')) {
        try {
          // Ne pas essayer de modifier la liste des messages directement
          // car ils sont de type MessageModel
          final client = http.Client();
          final request = await client.get(Uri.parse(message.uri));
          final bytes = request.bodyBytes;
          final documentsDir = (await getApplicationDocumentsDirectory()).path;
          localPath = '$documentsDir/${message.name}';

          if (!File(localPath).existsSync()) {
            final file = File(localPath);
            await file.writeAsBytes(bytes);
          }
        } catch (e) {
          log('Erreur lors du téléchargement: $e');
        }
      }

      await OpenFilex.open(localPath);
    }
  }

  void _handlePreviewDataFetched(
    types.TextMessage message,
    types.PreviewData previewData,
  ) {
    // Au lieu de modifier directement la liste
    // Vous devriez probablement appeler une méthode dans votre contrôleur
    controller.updateMessagePreview(message.id, previewData);
  }

  void _handleSendPressed(types.PartialText message) {
    controller.messageController.value.text = message.text;
    controller.sendMessage(
      Get.arguments['conversationId'] ?? null,
      Get.arguments['receiverId'] ?? '',
    );
  }
}
