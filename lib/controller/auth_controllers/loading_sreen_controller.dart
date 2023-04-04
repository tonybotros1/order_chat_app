import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../models/chat_model.dart';
import '../../screens/auth_screens/register_screen.dart';
import '../../screens/chat_screen/chat_screen.dart';

class LoadingScreenController extends GetxController {
  @override
  void onInit() {
    super.onInit();
    _checkLogin();
    notifyNavigate();
    notifyNavigateTer();
  }

  _checkLogin() async {
    SharedPreferences loginPref = await SharedPreferences.getInstance();
    var isLogged = loginPref.getBool('LogedIn');
    var role = loginPref.getString('Role');
    if (isLogged != null && isLogged == true) {
      if (role!.isNotEmpty || role != '') {
        Get.offNamed(role);
      } else {
        Get.to(() => const RegisterScreen());
      }
    } else {
      Get.offAll(() => const RegisterScreen());
    }
    update();
  }

  void notifyNavigate() {
    // open app only when in background app
    FirebaseMessaging.onMessageOpenedApp.listen((event) {
      Get.to(() => ChatPage(),
          arguments: ChatModel(
            chatId: event.data['order_id'],
            currentUserId: event.data['current_user_id'],
            anotherUserId: event.data['another_user_id'],
            orderId: event.data['chat_id'],
          ));
    });
    update();
  }

  void notifyNavigateTer() async {
    // open app only when in terminated app
    var message = await FirebaseMessaging.instance.getInitialMessage();
    if (message != null) {
      Get.to(() => ChatPage(),
          arguments: ChatModel(
            chatId: message.data['order_id'],
            currentUserId: message.data['current_user_id'],
            anotherUserId: message.data['another_user_id'],
            orderId: message.data['chat_id'],
          ));
    }
    update();
  }
}
