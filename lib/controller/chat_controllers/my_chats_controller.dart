import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:orders_chat_app/models/user_details_model.dart';

import '../../models/chat_model.dart';
import '../../screens/chat_screen/chat_screen.dart';

class MyChatsController extends GetxController {
  Rx<ChatModel> argument = Rx<ChatModel>(ChatModel());
  final RxList<ChatModel> _chats = RxList<ChatModel>([]);
  final RxList<UserDetailsModel> _userDetails = RxList<UserDetailsModel>([]);

  RxBool isLoading = RxBool(true);
  RxBool isLoading2 = RxBool(true);
  var chatModel = ChatModel().obs;

  @override
  void onInit() {
    argument = Get.arguments;
    _userDetails.bindStream(getUserDetails().asBroadcastStream());
    _chats.bindStream(getChatsDetails().asBroadcastStream());

    super.onInit();
  }

  
  //==========================================================
  Stream<List<ChatModel>> getChatsDetails() {
    final chatSnapshot = FirebaseFirestore.instance
        .collection('chats')
        .where('another_user_id', isEqualTo: argument.value.anotherUserId)
        .where('order_id', isEqualTo: argument.value.orderId)
        .orderBy('time_stamp', descending: false)
        .snapshots();
    return chatSnapshot.map((event) => event.docs
        .map((e) => ChatModel(
              anotherUserId: e.data()['created_by'],
              chatId: e.id,
              currentUserId: e.data()['another_user_id'],
              orderId: e.data()['order_id'],
              lastMessage: e.data()['last_message'],
              timestamp: e.data()['time_stamp'],
            ))
        .toList());
  }

  //==========================================================
  Stream<List<UserDetailsModel>> getUserDetails() { 
    final userSnapshot = 
        FirebaseFirestore.instance.collection('user_roles').snapshots();
    return userSnapshot.map((event) => event.docs
        .map((e) => UserDetailsModel(
              location: e.data()['location'],
              name: e.data()['name'],
              phoneNumber: e.data()['phone_number'],
              profilePicture: e.data()['profile_picture'],
              user_id: e.data()['user_id'],
              // userRole: doc.data()['user_role'],
              userToken: e.data()['user_token'],
            ))
        .toList());
  }

  //==========================================================
  List<ChatModel> get chatsWithDetails {
    return _chats.map((chat) {
      final user = _userDetails.firstWhere(
          (user) => user.user_id == chat.anotherUserId,
          orElse: () => UserDetailsModel(user_id: '', name: ''));
      return ChatModel(
          anotherUserId: chat.anotherUserId,
          chatId: chat.chatId,
          currentUserId: chat.currentUserId,
          lastMessage: chat.lastMessage,
          orderId: chat.orderId,
          timestamp: chat.timestamp,
          user: user);
    }).toList();
  }
  //==========================================================

  

  void goToChat(chatId, currentUserId, anotherUserId, orderId) {
    chatModel.value = ChatModel(
      chatId: chatId,
      currentUserId: currentUserId,
      anotherUserId: anotherUserId,
      orderId: orderId,
    );
    Get.to(() => ChatPage(),
        arguments: chatModel.value, transition: Transition.rightToLeftWithFade);
  }
}
