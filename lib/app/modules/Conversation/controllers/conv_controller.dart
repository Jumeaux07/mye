import 'dart:convert';

import 'package:get/get.dart';
import 'package:nom_du_projet/app/data/constant.dart';
import 'package:nom_du_projet/app/data/models/conversation_model.dart';
import 'package:http/http.dart' as http;

class ConvController extends GetxController {
  final isLoading = true.obs;
  var conversations = <ConversationModel>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchConversations();
  }

  Future<void> fetchConversations() async {
    try {
      final url = baseUrl + getConversationUrl;
      isLoading(true);
      final response = await http.get(
        Uri.parse(url),
        headers: {'Authorization': 'Bearer ${box.read("token")}'},
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body)['data'];
        conversations.value = List<ConversationModel>.from(
          data.map((item) => ConversationModel.fromJson(item)),
        );
      } else {
        print("Erreur: ${response.body}");
      }
    } catch (e) {
      print("Erreur de chargement des conversations: $e");
    } finally {
      isLoading(false);
    }
  }
}
