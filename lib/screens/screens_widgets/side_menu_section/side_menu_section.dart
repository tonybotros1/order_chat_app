import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobile_number/mobile_number.dart';
import 'package:orders_chat_app/screens/auth_screens/register_screen.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../auth_screens/register_screen.dart';
import '../../profile_screen/user_profile_screen.dart';
import '../../profile_screen/user_profile_screen2.dart';

class SideMenuSection extends StatelessWidget {
  const SideMenuSection({super.key});

  @override
  Widget build(BuildContext context) {
    Future<void> signOut() async {
      await FirebaseAuth.instance.signOut().whenComplete(() async {
        SharedPreferences loginPref = await SharedPreferences.getInstance();
        loginPref.setBool('LogedIn', false);
        loginPref.setString('Role', '');
        Get.offAll(() => const RegisterScreen());
      });
    }

    phoneNumber() async {
      if (await MobileNumber.hasPhonePermission) {
        // final String? mobileNumber1 = await MobileNumber.mobileNumber;
        final List<SimCard>? mobileNumber = await MobileNumber.getSimCards;

        // print(mobileNumber1);

        print(mobileNumber!.map((e) {
          print(e.number);
        }).toList());
        return mobileNumber;
      } else {
        await MobileNumber.requestPhonePermission;
      }
    }

    return Container(
      decoration: BoxDecoration(
          color: Color(0xffd1d8e0),
          borderRadius: BorderRadius.only(
              topRight: Radius.circular(30), bottomRight: Radius.circular(30))),
      width: 200,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            decoration: BoxDecoration(
                color: Colors.grey.shade800,
                borderRadius: BorderRadius.only(
                  topRight: Radius.circular(30),
                  // bottomRight: Radius.circular(30),
                )),
            height: 150,
          ),
          Container(
            child: Column(
              // mainAxisAlignment: MainAxisAlignment.start,
              // crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextButton.icon(
                    onPressed: () {
                      Get.to(() =>  UserProfileScreen());
                    },
                    icon: Icon(
                      Icons.person,
                      color: Colors.grey.shade700,
                    ),
                    label: Text('Profile',
                        style: TextStyle(
                            color: Colors.grey.shade700,
                            fontWeight: FontWeight.bold))),
                SizedBox(
                  height: 20,
                ),
                TextButton.icon(
                    onPressed: () {
                      signOut();
                    },
                    icon: Icon(
                      Icons.logout,
                      color: Colors.grey.shade700,
                    ),
                    label: Text(
                      'Logout',
                      style: TextStyle(
                          color: Colors.grey.shade700,
                          fontWeight: FontWeight.bold),
                    ))
              ],
            ),
          )
        ],
      ),
    );
  }
}
