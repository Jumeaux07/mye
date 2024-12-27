import 'package:get/get.dart';
import 'package:nom_du_projet/app/data/constant.dart';
import 'package:nom_du_projet/app/modules/messagerie/views/messagerie_view.dart';

import 'models/conversassion_model.dart';

class DiscussionsController extends GetxController {
  final discussions = <Discussion>[].obs;

  @override
  void onInit() {
    super.onInit();
    // Simuler des données pour l'exemple
    loadDiscussions();
  }

  void loadDiscussions() {
    // Exemple de données - à remplacer par vos vraies données
    discussions.value = [
      Discussion(
        id: '1',
        name: 'John Doe',
        lastMessage: 'Salut, comment ça va?',
        avatarUrl: 'https://upload.wikimedia.org/wikipedia/commons/thumb/4/48/Outdoors-man-portrait_%28cropped%29.jpg/440px-Outdoors-man-portrait_%28cropped%29.jpg',
        lastMessageTime: DateTime.now().subtract(const Duration(minutes: 5)),
        unreadCount: 2,
      ),
      Discussion(
        id: '2',
        name: 'Alice Smith',
        lastMessage: 'D\'accord, à demain!',
        avatarUrl: 'https://upload.wikimedia.org/wikipedia/commons/thumb/4/48/Outdoors-man-portrait_%28cropped%29.jpg/440px-Outdoors-man-portrait_%28cropped%29.jpg',
        lastMessageTime: DateTime.now().subtract(const Duration(hours: 1)),
        unreadCount: 0,
      ),
      // Ajoutez plus de discussions selon vos besoins
    ];
  }

  void openDiscussion(String discussionId) {
    // Navigation vers la discussion
    Get.to(MessagerieView());
  }
}
