import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:orders_chat_app/screens/chat_screen/my_chats_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../models/chat_model.dart';
import '../../models/order_model.dart';
import '../../screens/chat_screen/chat_screen.dart';

class OrderInformationController extends GetxController {
  Rx<OrderModel> argument = Rx<OrderModel>(OrderModel());
  late Stream<QuerySnapshot> chats;
  RxString role = RxString('');
  RxString userName = RxString('');
  RxString phoneNumber = RxString('');
  RxBool isOpen = RxBool(true); // for the customer
  RxBool isOpenForVendor = RxBool(true); // for the vendor
  RxString profilePicture = RxString('');
  RxString currentUserId = RxString('');
  final ScrollController scrollController = ScrollController();

  RxBool isAppBarExpanded = false.obs;

  @override
  void onInit() {
    super.onInit();
    // userRole();
    argument.value = Get.arguments as OrderModel;
    getUserDetails();
    getOrderStatusForCustomer();
    getOrerStatusForVendor();
    // isOpen.value = argument.value.isOpen!;
  }

//================================================================

  void getOrerStatusForVendor() {
    FirebaseFirestore.instance
        .collection('orders')
        .doc(argument.value.orderId)
        .snapshots()
        .listen((event) {
      print(currentUserId.value);
      List closedBy = event.data()!['closedBy'];
      if (closedBy.contains(currentUserId.value)) {
        print('================');
        isOpenForVendor.value = false;
      }else{
        isOpenForVendor.value = true;
      }
    });
  }

//================================================================

  void getOrderStatusForCustomer() {
    // this function is for the customer
    // if it's open or close

    FirebaseFirestore.instance
        .collection('orders')
        .doc(argument.value.orderId)
        .snapshots()
        .listen((event) {
      isOpen.value = event.data()!['isOpen']; // for customer
    });
  }

//================================================================

  void openOrder() {
    // this function is for the customer
    FirebaseFirestore.instance
        .collection('orders')
        .doc(argument.value.orderId)
        .update({
      "isOpen": true,
      //"timestamp":Timestamp.now(),
    });
  }

//================================================================

  void closeOrder() {
    // this functions is for the customer
    FirebaseFirestore.instance
        .collection('orders')
        .doc(argument.value.orderId)
        .update({
      "isOpen": false,
      "timestamp": Timestamp.now(),
    });
  }

//================================================================

  void myChats() {
    // this method is for customers
    FirebaseAuth auth = FirebaseAuth.instance;
    var user = auth.currentUser;
    if (user != null) {
      var uid = user.uid;

      chatModel.value = ChatModel(
        anotherUserId:
            uid, // here the another user id means the id of customer => id of current user(customer)
        orderId: argument.value.orderId,
      );
      Get.to(() => MyChats(),
          arguments: chatModel, transition: Transition.rightToLeftWithFade);
    }
  }

//================================================================

  void getUserDetails() {
    FirebaseAuth auth = FirebaseAuth.instance;
    var user = auth.currentUser;

    if (user != null) {
      // var uid = user.uid;
      currentUserId.value = user.uid;
      FirebaseFirestore.instance
          .collection('user_roles')
          .where('user_id', isEqualTo: currentUserId.value)
          .snapshots()
          .listen((event) {
        event.docs.map((e) {
          userName.value = e.data()['name'];
          phoneNumber.value = e.data()['phone_number'];
          profilePicture.value = e.data()['profile_picture'];
        }).toList();
      });
    }
  }

//================================================================

  void userRole() async {
    SharedPreferences loginPref = await SharedPreferences.getInstance();
    role.value = loginPref.getString('Role')!;
  }

//================================================================

  var chatModel = ChatModel().obs;
  var isLoading = false.obs;

  Future<void> goToChat() async {
    // this method is for vendors
    isLoading.value = true;
    FirebaseAuth auth = FirebaseAuth.instance;
    User? user = auth.currentUser;
    if (user != null && user.uid.isNotEmpty) {
      String uid = user.uid;
      var querySnapshot = await FirebaseFirestore.instance
          .collection('chats')
          .where('order_id', isEqualTo: argument.value.orderId)
          .where('created_by', isEqualTo: uid)
          .where('another_user_id', isEqualTo: argument.value.userId)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        // means the chat already exists
        chatModel.value = ChatModel(
          chatId: querySnapshot.docs[0].id,
          currentUserId: uid,
          anotherUserId: argument.value.userId,
          orderId: argument.value.orderId,
        );
      } else {
        // chat doesn't exist
        var newChat = await FirebaseFirestore.instance.collection('chats').add({
          "order_id": argument.value.orderId,
          "created_by": uid,
          "another_user_id": argument.value.userId,
          "last_message": '',
          "time_stamp": DateTime.now().millisecondsSinceEpoch,
        });
        chatModel.value = ChatModel(
          chatId: newChat.id,
          currentUserId: uid,
          anotherUserId: argument.value.userId,
          orderId: argument.value.orderId,
        );
      }
      isLoading.value = false;
      const slideTransition = Transition.rightToLeftWithFade;

      Get.to(() => ChatPage(),
          arguments: chatModel.value, transition: slideTransition);
    }
  }
//================================================================

  void closeVendorOrder() {
    FirebaseFirestore.instance
        .collection('orders')
        .doc(argument.value.orderId)
        .update({
      "closedBy": FieldValue.arrayUnion([currentUserId.value])
    });
  }

//================================================================
  void openVendorOrder() {
    FirebaseFirestore.instance
        .collection('orders')
        .doc(argument.value.orderId)
        .update({
      "closedBy": FieldValue.arrayRemove([currentUserId.value])
    });
  }
//================================================================
}
