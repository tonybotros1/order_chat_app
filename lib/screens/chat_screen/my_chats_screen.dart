import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:get/get.dart';
import 'package:orders_chat_app/controller/chat_controllers/my_chats_controller.dart';
import 'package:intl/intl.dart';

class MyChats extends GetView<MyChatsController> {
  MyChats({super.key});

  final MyChatsController myChatsController = Get.put(MyChatsController());

  TextStyle fontStyle = const TextStyle(
    color: Colors.grey,
    fontWeight: FontWeight.bold,
    fontSize: 17,
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Current Chats'),
        backgroundColor: const Color(0xffd35400),
      ),
      body: Obx(() {
        final chatsWithDetails = myChatsController.chatsWithDetails;
        if (chatsWithDetails.isEmpty) {
          return const Center(
              child: Text(
            'No chats yet',
            style: TextStyle(fontSize: 20),
          ));
        } else {
          return ListView.builder(
              shrinkWrap: true,
              itemCount: chatsWithDetails.length,
              itemBuilder: (context, i) {
                final chat = chatsWithDetails[i];

                String? lastMessageee = chat.lastMessage;
                if (lastMessageee!.length > 20) {
                  lastMessageee = '${lastMessageee.substring(0, 30)}...';
                }

                final now = DateTime.now();
                final messageTime =
                    DateTime.fromMillisecondsSinceEpoch(chat.timestamp!);

                final diff = now.difference(messageTime);
                final String lastMessageTime;

                if (diff.inDays == 0) {
                  lastMessageTime = DateFormat.jm()
                      .format(messageTime); // Format as hh:mm AM/PM
                  print('if');
                } else if (diff.inDays == 1) {
                  lastMessageTime = 'Yesterday';
                  print('else if');
                } else {
                  lastMessageTime = DateFormat('dd/MM')
                      .format(messageTime); // Format as dd/MM
                  print('else');
                }

                return Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: InkWell(
                        highlightColor: Colors.transparent,
                        onTap: () {
                          controller.goToChat(chat.chatId, chat.currentUserId,
                              chat.anotherUserId, chat.orderId);
                        },
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            CircleAvatar(
                              backgroundImage: chat.user!.profilePicture != ''
                                  ? NetworkImage(
                                      '${chat.user!.profilePicture}',
                                    )
                                  : null,
                              minRadius: 30,
                              backgroundColor: Colors.grey,
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  chat.user?.name != ''
                                      ? Text(
                                          '${chat.user?.name}',
                                          style: fontStyle,
                                        )
                                      : Text('${chat.user?.profilePicture}'),
                                  const SizedBox(
                                    height: 7,
                                  ),
                                  Text(lastMessageee)
                                ],
                              ),
                            ),
                            Text(lastMessageTime)
                          ],
                        ),
                      ),
                    )
                  ],
                );
              });
        }
      }),
    );
  }
}
