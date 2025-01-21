import 'dart:developer';

import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:timeago/timeago.dart' as timeago_fr;

import '../controllers/conversation_controller.dart';

import 'package:timeago/timeago.dart' as timeago;

class ConversationView extends GetView<ConversationController> {
  const ConversationView({super.key});
  @override
  Widget build(BuildContext context) {
    timeago.setLocaleMessages('fr', timeago_fr.FrMessages());
    controller.getConversation();
    return RefreshIndicator(
      onRefresh: () => controller.getConversation(),
      child: Scaffold(
        body: controller.obx(
          onEmpty: const Center(
            child: Text('Aucune discussion'),
          ),
          onLoading: const Center(
            child: CircularProgressIndicator(),
          ),
          onError: (error) => Center(
            child: Text(error.toString()),
          ),
          (data) => controller.conversations.isEmpty
              ? Center(
                  child: Text("Aucune discussion"),
                )
              : ListView.separated(
                  itemCount: controller.conversations.length,
                  separatorBuilder: (context, index) =>
                      const Divider(height: 1),
                  itemBuilder: (context, index) {
                    final conversation = controller.conversations[index];
                    return ListTile(
                        leading: Visibility(
                          visible: true,
                          child: CircleAvatar(
                            backgroundImage: NetworkImage(conversation
                                    .destinataire?.profileImage ??
                                "https://img.freepik.com/vecteurs-premium/icone-profil-utilisateur-dans-style-plat-illustration-vectorielle-avatar-membre-fond-isole-concept-entreprise-signe-autorisation-humaine_157943-15752.jpg?w=996"),
                            radius: 25,
                          ),
                        ),
                        title: Text(
                          conversation.destinataire?.getFullName() ?? "",
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        subtitle: Obx(() => Text(
                              conversation.lastmessage.value,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            )),
                        trailing: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              timeago.format(conversation.updatedAt,
                                  locale: 'fr'),
                              style: TextStyle(
                                color: Colors.grey[600],
                                fontSize: 12,
                              ),
                            ),
                            if (conversation.messages!
                                    .where((e) => e.isRead == 0)
                                    .toList()
                                    .length >
                                0)
                              Container(
                                margin: const EdgeInsets.only(top: 5),
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 2,
                                ),
                                decoration: BoxDecoration(
                                  color: Theme.of(context).primaryColor,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Text(
                                  conversation.messages!
                                      .where((e) => e.isRead == 0)
                                      .toList()
                                      .length
                                      .toString(),
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 12,
                                  ),
                                ),
                              ),
                          ],
                        ),
                        onTap: () {
                          controller.openDiscussion(conversation);
                        });
                  },
                ),
        ),
      ),
    );
  }
}
