import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:msh_checkbox/msh_checkbox.dart';
import 'package:orders_chat_app/screens/auth_screens/register_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../../controller/auth_controllers/register_screen_controller.dart';
import 'register_screen.dart';

class RegisterScreen2 extends StatelessWidget {
  RegisterScreen2({super.key});
  RegisterController2 registerController2 = Get.put(RegisterController2());

  @override
  Widget build(BuildContext context) {
    return GetX<RegisterController2>(
        init: RegisterController2(),
        builder: (controller) {
          if (controller.isLoading.isTrue) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          return SafeArea(
            child: Scaffold(
              body: Container(
                width: double.infinity,
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    colors: [
                      // Color(0xff2d3436),
                      Color(0xffd35400),
                      Color(0xffe67e22),
                    ],
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(
                      height: 30,
                    ),
                    Padding(
                        padding: const EdgeInsets.all(20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Register',
                              style:
                                  TextStyle(color: Colors.white, fontSize: 40),
                            ),
                            const Text(
                              'Sign Up For Free',
                              style:
                                  TextStyle(color: Colors.white, fontSize: 20),
                            )
                          ],
                        )),
                    Expanded(
                        child: CustomScrollView(slivers: [
                      SliverFillRemaining(
                        hasScrollBody: false,
                        child: Container(
                          decoration: const BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(60),
                                  topRight: Radius.circular(60))),
                          child: Padding(
                            padding: const EdgeInsets.all(40),
                            child: Column(
                              children: [
                                const Text(
                                  'Select your Role:',
                                  style: TextStyle(
                                      color: Color(0xff4b6584), fontSize: 30),
                                ),
                                Container(
                                  height: 40,
                                ),
                                SizedBox(
                                  height: 200,
                                  child: ListView.builder(
                                      shrinkWrap: true,
                                      itemCount: controller.rolesStream.length,
                                      itemBuilder: (context, i) {
                                        final role = controller.rolesStream[i];
                                        return Obx(() {
                                          return Theme(
                                            data: ThemeData(
                                              unselectedWidgetColor:
                                                  Colors.grey,
                                            ),
                                            child: RadioListTile(
                                                contentPadding:
                                                    EdgeInsets.all(5),
                                                activeColor:
                                                    const Color(0xff4b6584),
                                                title: Text(
                                                    '${role['role_name']}'),
                                                value: role['role_name'],
                                                groupValue:
                                                    controller.role.value,
                                                onChanged: (value) {
                                                  controller.role.value = value;
                                                  print(controller.role.value);
                                                }),
                                          );
                                        });
                                      }),
                                ),
                                const SizedBox(
                                  height: 60,
                                ),
                                Container(
                                    padding: const EdgeInsets.all(5),
                                    decoration: BoxDecoration(
                                        color: const Color(0xffd35400),
                                        borderRadius:
                                            BorderRadius.circular(25)),
                                    child: GetBuilder<RegisterController2>(
                                        init: RegisterController2(),
                                        builder: (controller) {
                                          return TextButton(
                                            onPressed: () {
                                              if (controller.role == '') {
                                                Get.snackbar('Message',
                                                    'Select Role please',
                                                    snackPosition:
                                                        SnackPosition.BOTTOM);
                                              } else {
                                                Get.snackbar('Welcome', 'please wait',snackPosition: SnackPosition.BOTTOM);
                                                controller.registerUser();
                                              }
                                            },
                                            child: const Text(
                                              'Continue',
                                              style: TextStyle(
                                                  color: Colors.white),
                                            ),
                                          );
                                        })),
                              ],
                            ),
                          ),
                        ),
                      )
                    ]))
                  ],
                ),
              ),
            ),
          );
        });
  }
}


// Row(
//                                           mainAxisAlignment:
//                                               MainAxisAlignment.start,
//                                           children: [
//                                             MSHCheckbox(
//                                               size: 30,
//                                               value: controller.checkcheck[i],
//                                               colorConfig: MSHColorConfig
//                                                   .fromCheckedUncheckedDisabled(
//                                                 checkedColor: Colors.green,
//                                               ),
//                                               style: MSHCheckboxStyle.stroke,
//                                               onChanged: (val) {
//                                                 controller.chechTheBox(
//                                                     i, role['role_name']);
//                                               },
//                                             ),
//                                             const SizedBox(
//                                               width: 20,
//                                             ),
//                                             Text(
//                                               '${role['role_name']}',
//                                               style: const TextStyle(
//                                                   color: Color(0xff4b6584)),
//                                             ),
//                                             const SizedBox(
//                                               height: 50,
//                                             )
//                                           ],
//                                         );