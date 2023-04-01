import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../screens/auth_screens/register_screen.dart';
import '../../screens/auth_screens/verification_code_screen.dart';

class RegisterController extends GetxController {
  void verifyPhoneNumber() async {
    try {
      await FirebaseAuth.instance.verifyPhoneNumber(
        phoneNumber: RegisterScreen.phoneNumber,
        verificationCompleted: (PhoneAuthCredential credential) {},
        verificationFailed: (FirebaseAuthException e) {
          Get.snackbar('Error', 'Check your internet and try again',snackPosition: SnackPosition.BOTTOM);
        },
        codeSent: (String verificationId, int? resendToken) {
          RegisterScreen.verify = verificationId;
          Get.to(() => const MyVerify());
        },
        codeAutoRetrievalTimeout: (String verificationId) {},
      );
    } catch (e) {
      print(e);
    }
    update();
  }
}

class RegisterController2 extends GetxController {
  RxString role = RxString('');
  RxString userToken = RxString('');
  final RxList<DocumentSnapshot> rolesStream = RxList<DocumentSnapshot>([]);

  RxBool isLoading = RxBool(true);

  @override
  void onInit() {
    getRoles();
    getUserToken();
    super.onInit();
  }

  void getRoles() {
    try {
      FirebaseFirestore.instance
          .collection('roles')
          .snapshots()
          .listen((event) {
        final roles = event.docs;
        rolesStream.assignAll(roles);
      });
    } catch (e) {
      print("Error: $e");
    } finally {
      isLoading.value = false;
    }
  }

  void getUserToken() {
    FirebaseMessaging.instance.getToken().then((token) {
      userToken.value = '$token';
    });
  }

  saveLogin(bool logedIn, String role) async {
    SharedPreferences loginPref = await SharedPreferences.getInstance();
    loginPref.setBool('LogedIn', logedIn);
    loginPref.setString('Role', role);
    print(role);
  }

  void registerUser() async {
    FirebaseAuth auth = FirebaseAuth.instance;
    User? currentUser = auth.currentUser;
    final String uid = currentUser!.uid;

    CollectionReference userRoles =
        FirebaseFirestore.instance.collection('user_roles');
    print(uid);
    print(role);

    userRoles.add({
      "user_id": uid,
      "user_role": role.value,
      "phone_number": RegisterScreen.phoneNumber,
      "name": "",
      "location": "",
      "profile_picture": "",
      "user_token": userToken.value
    }).then((value) {
      saveLogin(true, role.value);
      Get.offNamed(role.value);
    }).catchError((error) {
      // An error occurred while saving the data
      print("Error saving user data: $error");
    });
  }
}
