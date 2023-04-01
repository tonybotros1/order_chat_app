import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:get/get.dart';
import 'dart:convert';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:flutter_chat_ui/flutter_chat_ui.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:mime/mime.dart';
import 'package:open_filex/open_filex.dart';
import 'package:path_provider/path_provider.dart';
import 'package:uuid/uuid.dart';

import '../../models/chat_model.dart';
import '../../models/user_details_model.dart';

class ChatController extends GetxController {
  Rx<ChatModel> argument = Rx<ChatModel>(ChatModel());
  // String? currentUserId = '';
  late types.User user;
  late String currentUserId;
  RxList<UserDetailsModel> anotherUserDetailsList = RxList<UserDetailsModel>();

  @override
  void onInit() {
    super.onInit();
    argument.value = Get.arguments;
    currentUserId = argument.value.currentUserId!;
    user = types.User(id: currentUserId);
    anotherUserDetailsList
        .bindStream(getAnotherUserDetails().asBroadcastStream());

    loadMessages();
  }

  var messages = RxList<types.Message>([]);
  // var user = types.User(id: currentUserId);
  

  Stream<List<UserDetailsModel>> getAnotherUserDetails() {
    var details = FirebaseFirestore.instance
        .collection('user_roles')
        .where('user_id', isEqualTo: argument.value.anotherUserId)
        .snapshots();

    return details.map((event) => event.docs
        .map((e) => UserDetailsModel(
              name: e.data()['name'],
              phoneNumber: e.data()['phone_number'],
              profilePicture: e.data()['profile_picture'],
            ))
        .toList());
  }

  void loadMessages() async {
    FirebaseFirestore.instance
        .collection('chats')
        .doc(argument.value.chatId)
        .collection('messages')
        .orderBy('createdAt', descending: true)
        .snapshots()
        .listen((snapshot) {
      final messages1 = snapshot.docs.map((doc) {
        final data = doc.data();
        return types.Message.fromJson(data);
      }).toList();
      messages.value = messages1;
    });
  }

  void addMessage(types.Message message) {
    messages.insert(0, message);
  }

  void handleAttachmentPressed() {
    Get.bottomSheet(
      SafeArea(
        child: SizedBox(
          height: 144,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              TextButton(
                onPressed: () {
                  Get.back();
                  handleImageSelection();
                },
                child: const Align(
                  alignment: AlignmentDirectional.center,
                  child: Text('Photo'),
                ),
              ),
              TextButton(
                onPressed: () {
                  Get.back();
                  handleFileSelection();
                },
                child: const Align(
                  alignment: AlignmentDirectional.center,
                  child: Text('File'),
                ),
              ),
              TextButton(
                onPressed: () => Get.back(),
                child: const Align(
                  alignment: AlignmentDirectional.center,
                  child: Text('Cancel'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void handleFileSelection() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.any,
    );

    if (result != null && result.files.single.path != null) {
      final message = types.FileMessage(
        author: user,
        createdAt: DateTime.now().millisecondsSinceEpoch,
        id: const Uuid().v4(),
        mimeType: lookupMimeType(result.files.single.path!),
        name: result.files.single.name,
        size: result.files.single.size,
        uri: result.files.single.path!,
      );
      addMessage(message);

      PlatformFile? platformFile;
      platformFile = result.files.first;
      final File file = File(platformFile.path!);
      final Reference ref = FirebaseStorage.instance
          .ref()
          .child('chats_files')
          .child('${message.id}/${DateTime.now().millisecondsSinceEpoch}.jpg');
      final UploadTask uploadTask = ref.putFile(file);
      await uploadTask.whenComplete(() async {
        final String downloadUrl = await ref.getDownloadURL();
        FirebaseFirestore.instance
            .collection('chats')
            .doc('${argument.value.chatId}')
            .collection('messages')
            .add({
          "author": {"id": currentUserId},
          "createdAt": DateTime.now().millisecondsSinceEpoch,
          "id": message.id,
          "type": 'file',
          "name": result.files.single.name,
          "size": result.files.single.size,
          "uri": downloadUrl, // need to change
          'mimeType': lookupMimeType(result.files.single.path!)
        }).then((value) {
          FirebaseFirestore.instance
              .collection('chats')
              .doc(argument.value.chatId)
              .update({
            "last_message": 'file 🗀',
          });
          sendNotification('file 🗀');
        }).onError((error, stackTrace) {
          print('error $error');
        });
      });
    }
  }

  void handleImageSelection() async {
    final result = await ImagePicker().pickImage(
      imageQuality: 70,
      maxWidth: 1440,
      source: ImageSource.gallery,
    );

    if (result != null) {
      final bytes = await result.readAsBytes();
      final image = await decodeImageFromList(bytes);

      final message = types.ImageMessage(
        author: user,
        createdAt: DateTime.now().millisecondsSinceEpoch,
        height: image.height.toDouble(),
        id: const Uuid().v4(),
        name: result.name,
        size: bytes.length,
        uri: result.path,
        width: image.width.toDouble(),
      );

      addMessage(message);

      final File file = File(result.path);
      final Reference ref = FirebaseStorage.instance
          .ref()
          .child('chats_images')
          .child('${message.id}/${DateTime.now().millisecondsSinceEpoch}.jpg');
      final UploadTask uploadTask = ref.putFile(file);
      await uploadTask.whenComplete(() async {
        final String downloadUrl = await ref.getDownloadURL();
        FirebaseFirestore.instance
            .collection('chats')
            .doc('${argument.value.chatId}')
            .collection('messages')
            .add({
          "author": {"id": currentUserId},
          "createdAt": DateTime.now().millisecondsSinceEpoch,
          "id": message.id,
          "type": 'image',
          "name": result.name,
          "size": bytes.length,
          "uri": downloadUrl,
          "width": image.width.toDouble(),
        }).then((value) {
          FirebaseFirestore.instance
              .collection('chats')
              .doc(argument.value.chatId)
              .update({
            "last_message": 'image 📷',
          });
          sendNotification('image 📷');
        }).onError((error, stackTrace) {
          print('error $error');
        });
      });
    }
  }

  void handleMessageTap(BuildContext _, types.Message message) async {
    if (message is types.FileMessage) {
      var localPath = message.uri;

      if (message.uri.startsWith('http')) {
        try {
          final index =
              messages.indexWhere((element) => element.id == message.id);
          final updatedMessage =
              (messages[index] as types.FileMessage).copyWith(
            isLoading: true,
          );

          messages[index] = updatedMessage;
          // update();

          final client = http.Client();
          final request = await client.get(Uri.parse(message.uri));
          final bytes = request.bodyBytes;
          final documentsDir = (await getApplicationDocumentsDirectory()).path;
          localPath = '$documentsDir/${message.name}';

          if (!File(localPath).existsSync()) {
            final file = File(localPath);
            await file.writeAsBytes(bytes);
          }
        } finally {
          final index =
              messages.indexWhere((element) => element.id == message.id);
          final updatedMessage =
              (messages[index] as types.FileMessage).copyWith(
            isLoading: null,
          );

          messages[index] = updatedMessage;
          // update();
        }
      }

      await OpenFilex.open(localPath);
    }
  }

  void handlePreviewDataFetched(
    types.TextMessage message,
    types.PreviewData previewData,
  ) {
    final index = messages.indexWhere((element) => element.id == message.id);
    final updatedMessage = (messages[index] as types.TextMessage).copyWith(
      previewData: previewData,
    );

    messages[index] = updatedMessage;
  }

  void handleSendPressed(types.PartialText message) {
    final textMessage = types.TextMessage(
      author: user,
      createdAt: DateTime.now().millisecondsSinceEpoch,
      id: const Uuid().v4(),
      text: message.text,
    );
    addMessage(textMessage);
    FirebaseFirestore.instance
        .collection('chats')
        .doc('${argument.value.chatId}')
        .collection('messages')
        .add({
      "author": {"id": currentUserId},
      "createdAt": DateTime.now().millisecondsSinceEpoch,
      "id": textMessage.id,
      "type": 'text',
      "text": textMessage.text,
    }).then((value) async {
      FirebaseFirestore.instance
          .collection('chats')
          .doc(argument.value.chatId)
          .update({
        "last_message": textMessage.text,
        "time_stamp": DateTime.now().millisecondsSinceEpoch,
      }).then((value) async {
        await sendNotification(textMessage.text);
      });
    }).onError((error, stackTrace) {
      print('error $error');
    });
  }

  sendNotification(body) async {
    var anotherUser = await FirebaseFirestore.instance
        .collection('user_roles')
        .where('user_id', isEqualTo: argument.value.anotherUserId)
        .get();
    var anotherUserName;
    var anotherUserToken;

    print(anotherUser.docs.map((event) {
      anotherUserName = event.data()['name'];
      anotherUserToken = event.data()['user_token'];
    }));

    var serverToken =
        'AAAAz1UQPFY:APA91bFu-vQpCE_z-krctSHVJ2sLolZ75foM_F1_vThlcnwt_mKGD1vs2s8RnOBjBo7Og3kA9U8I5a83PDEt1ES3-F_Q4KoY_f1ccWUzgpY-waFP6DkRobW3FDAvqXD4fsXWs8UQPC4k';
    await http.post(
      Uri.parse('https://fcm.googleapis.com/fcm/send'),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': 'key=$serverToken',
      },
      body: jsonEncode(
        <String, dynamic>{
          'notification': <String, dynamic>{
            'body': body.toString(),
            'title': anotherUserName
          },
          'priority': 'high',
          'data': <String, dynamic>{
            'click_action': 'FLUTTER_NOTIFICATION_CLICK',
            'id': '1',
            'status': 'done',
            'order_id': '${argument.value.orderId}',
            'current_user_id': '${argument.value.currentUserId}',
            'another_user_id': '${argument.value.anotherUserId}',
            'chat_id': '${argument.value.chatId}',
          },
          'to': anotherUserToken
        },
      ),
    );
  }
}
