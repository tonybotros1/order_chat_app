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

import '../../controller/chat_controllers/chat_controller.dart';
import '../../models/chat_model.dart';

class ChatPage extends GetView<ChatController> {
  final ChatController chatController = Get.put(ChatController());
  ChatPage({super.key});

  @override
  Widget build(BuildContext context) => Scaffold(
      appBar: AppBar(
        title: Text(''),
        backgroundColor: const Color(0xff2d3436),
      ),
      body: GetX<ChatController>(
        init: ChatController(),
        builder: (controller) {
          return Chat(
            messages: chatController.messages.toList(),
            onAttachmentPressed: chatController.handleAttachmentPressed,
            onMessageTap: chatController.handleMessageTap,
            onPreviewDataFetched: chatController.handlePreviewDataFetched,
            onSendPressed: chatController.handleSendPressed,
            showUserAvatars: true,
            showUserNames: true,
            user: chatController.user,
          );
        },
      ));
}
