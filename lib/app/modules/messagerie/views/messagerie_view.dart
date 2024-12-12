// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import '../controllers/messagerie_controller.dart';

// class MessagerieView extends GetView<MessagerieController> {
//   const MessagerieView({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Messagerie'),
//         centerTitle: true,
//       ),
//       body: Column(
//         children: [
//           Expanded(
//             child: Obx(() {
//               // Utilisation de Obx pour réagir aux changements de la liste de messages
//               return ListView.builder(
//                 itemCount: controller.messages.length,
//                 itemBuilder: (context, index) {
//                   final message = controller.messages[index];
//                   return ListTile(
//                     title: Text(message.sender),
//                     subtitle: Text(message.content),
//                     leading: CircleAvatar(
//                       child: Text(message.sender[0]),
//                     ),
//                   );
//                 },
//               );
//             }),
//           ),
//           Padding(
//             padding: const EdgeInsets.all(8.0),
//             child: Row(
//               children: [
//                 Expanded(
//                   child: TextField(
//                     controller: controller.messageController,
//                     decoration: const InputDecoration(
//                       hintText: 'Écrire un message...',
//                       border: OutlineInputBorder(),
//                     ),
//                   ),
//                 ),
//                 IconButton(
//                   icon: const Icon(Icons.send),
//                   onPressed: () {
//                     controller.sendMessage();
//                   },
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
