import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nom_du_projet/app/data/constant.dart';
import 'package:nom_du_projet/app/modules/Conversation/controllers/conv_controller.dart';
import 'package:nom_du_projet/app/modules/Conversation/views/messageScree.dart';

class ConversationListView extends StatelessWidget {
  const ConversationListView({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(ConvController());
    controller.fetchConversations();

    return Scaffold(
      body: Obx(() {
        if (controller.isLoading.value) {
          return Center(child: CircularProgressIndicator());
        }

        return controller.conversations.length == 0
            ? Center(
                child: Text("Aucune discussion"),
              )
            : ListView.builder(
                itemCount: controller.conversations.length,
                itemBuilder: (context, index) {
                  final conversation = controller.conversations[index];
                  return ListTile(
                    leading: CircleAvatar(
                      backgroundImage:
                          conversation.destinataire?.profileImage != null
                              ? NetworkImage(
                                  conversation.destinataire?.profileImage ?? "")
                              : null,
                      child: conversation.destinataire?.profileImage == null
                          ? Icon(Icons.person)
                          : null,
                    ),
                    title: Text("${conversation.destinataire?.getFullName()}"),
                    subtitle: Obx(() => Text(conversation.lastmessage.value)),
                    onTap: () {
                      Get.to(() => MessageScreen(
                            isNewConversation: false,
                            conversation: conversation,
                          ));
                    },
                  );
                },
              );
      }),
    );
  }
}











// import 'dart:developer';

// import 'package:flutter/material.dart';

// import 'package:get/get.dart';
// import 'package:nom_du_projet/app/data/constant.dart';
// import 'package:timeago/timeago.dart' as timeago_fr;

// import '../controllers/conversation_controller.dart';

// import 'package:timeago/timeago.dart' as timeago;

// class ConversationView extends GetView<ConversationController> {
//   const ConversationView({super.key});

//   @override
//   Widget build(BuildContext context) {
//     timeago.setLocaleMessages('fr', timeago_fr.FrMessages());

//     if (box.read('conversation') != 'ok') {
//       controller.getConversation();
//     }

//     return RefreshIndicator(
//       onRefresh: () => controller.getConversation(),
//       child: Scaffold(
//         body: Obx(() {
//           if (controller.isLoading.value) {
//             return const Center(child: CircularProgressIndicator());
//           }

//           if (controller.errorMessage.value.isNotEmpty) {
//             return Center(child: Text(controller.errorMessage.value));
//           }

//           if (controller.conversations.isEmpty) {
//             return const Center(child: Text("Aucune discussion"));
//           }

//           return ListView.separated(
//             itemCount: controller.conversations.length,
//             separatorBuilder: (context, index) => const Divider(height: 1),
//             itemBuilder: (context, index) {
//               final conversation = controller.conversations[index];
//               return ListTile(
//                 leading: CircleAvatar(
//                   backgroundImage: NetworkImage(
//                     conversation.destinataire?.profileImage ??
//                         "https://img.freepik.com/vecteurs-premium/icone-profil-utilisateur-dans-style-plat-illustration-vectorielle-avatar-membre-fond-isole-concept-entreprise-signe-autorisation-humaine_157943-15752.jpg?w=996",
//                   ),
//                   radius: 25,
//                 ),
//                 title: Text(
//                   conversation.destinataire?.getFullName() ?? "",
//                   maxLines: 1,
//                   style: const TextStyle(
//                     fontWeight: FontWeight.bold,
//                     fontSize: 14,
//                   ),
//                 ),
//                 subtitle: Obx(() => Text(
//                       conversation.lastmessage.value,
//                       maxLines: 1,
//                       overflow: TextOverflow.ellipsis,
//                     )),
//                 trailing: SizedBox(
//                   width: 70,
//                   child: Column(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     crossAxisAlignment: CrossAxisAlignment.end,
//                     children: [
//                       Text(
//                         timeago.format(conversation.updatedAt, locale: 'fr'),
//                         style: TextStyle(
//                           color: Colors.grey[600],
//                           fontSize: 8,
//                         ),
//                       ),
//                       if (conversation.messages!
//                           .where((e) => e.isRead == 0)
//                           .isNotEmpty)
//                         Container(
//                           margin: const EdgeInsets.only(top: 5),
//                           padding: const EdgeInsets.symmetric(
//                             horizontal: 8,
//                             vertical: 2,
//                           ),
//                           decoration: BoxDecoration(
//                             color: Theme.of(context).primaryColor,
//                             borderRadius: BorderRadius.circular(10),
//                           ),
//                           child: Text(
//                             conversation.messages!
//                                 .where((e) => e.isRead == 0)
//                                 .length
//                                 .toString(),
//                             style: const TextStyle(
//                               color: Colors.white,
//                               fontSize: 12,
//                             ),
//                           ),
//                         ),
//                     ],
//                   ),
//                 ),
//                 onTap: () {
//                   controller.openDiscussion(conversation);
//                 },
//               );
//             },
//           );
//         }),
//       ),
//     );
//   }
// }
