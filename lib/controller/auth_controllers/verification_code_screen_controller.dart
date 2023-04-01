import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:orders_chat_app/screens/auth_screens/register_screen.dart';
import 'package:orders_chat_app/screens/main_screens/customer_screen.dart';
import 'package:pinput/pinput.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../screens/auth_screens/register_screen2.dart';
import '../../screens/auth_screens/register_screen22222222.dart';

class VerificationCodeController extends GetxController {
  final FirebaseAuth auth = FirebaseAuth.instance;
  var userDocId = '';
  var role = '';
  var code = '';

  Future<bool> checkPhoneNumberExists(String phoneNumber) async {
    var querySnapshot = await FirebaseFirestore.instance
        .collection('user_roles')
        .where('phone_number', isEqualTo: phoneNumber)
        .get();
    if (querySnapshot.docs.isNotEmpty) {
      print(querySnapshot.docs.map((e) {
        role = e.data()['user_role'];
        userDocId = e.id;
      }));
    }

    return querySnapshot.docs.isNotEmpty;
  }

  void updateUserToken() {
    FirebaseMessaging.instance.getToken().then((token) {
      FirebaseFirestore.instance
          .collection('user_roles')
          .doc(userDocId)
          .update({
        "user_token": token,
      });
    });
    update();
  }

  void saveLogin(bool logedIn, role) async {
    SharedPreferences loginPref = await SharedPreferences.getInstance();
    loginPref.setBool('LogedIn', logedIn);
    loginPref.setString('Role', role);
    update();
  }

  void verifyCode() async {
    try {
      PhoneAuthCredential credential = PhoneAuthProvider.credential(
          verificationId: RegisterScreen.verify, smsCode: code);

      // Sign the user in (or link) with the credential
      await auth.signInWithCredential(credential);
      if (await checkPhoneNumberExists(RegisterScreen.phoneNumber) == true) {
        saveLogin(true, role);
        updateUserToken();
        Get.offAllNamed(role);
      } else {
        Get.to(() => RegisterScreen2());
      }
    } catch (e) {
      print(e);
    }
    update();
  }
}
