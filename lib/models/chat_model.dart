import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:orders_chat_app/models/user_details_model.dart';

class ChatModel {
  late final String? currentUserId;
  late final String? anotherUserId;
  late final String? orderId;
  late final String? chatId;
  late final String? lastMessage;
  late final UserDetailsModel? user;
  late final int? timestamp;

  ChatModel(
      {this.anotherUserId,
      this.currentUserId,
      this.orderId,
      this.chatId,
      this.lastMessage,
      this.user,
      this.timestamp});

  ChatModel.fromJson(Map<String, dynamic> json, this.currentUserId,
      this.anotherUserId, this.orderId, this.chatId) {
    currentUserId = json['current_user_id'];
    anotherUserId = json['another_user_id'];
    orderId = json['order_id'];
    chatId = json['chat_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['current_user_id'] = this.currentUserId;
    data['another_user_id'] = this.anotherUserId;
    data['order_id'] = this.orderId;
    data['chat_id'] = this.chatId;
    return data;
  }
}
