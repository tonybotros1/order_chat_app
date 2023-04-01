import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import '../../controller/auth_controllers/register_screen_controller.dart';
import 'verification_code_screen.dart';

class RegisterScreen extends StatelessWidget {
  const RegisterScreen({super.key});
  static String phoneNumber = '';
  static String verify = '';

  @override
  Widget build(BuildContext context) {
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
                padding: EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Register',
                      style: TextStyle(color: Colors.white, fontSize: 40),
                    ),
                    Text(
                      'Sign Up For Free',
                      style: TextStyle(color: Colors.white, fontSize: 20),
                    )
                  ],
                )),
            Expanded(
                child: CustomScrollView(slivers: [
              SliverFillRemaining(
                hasScrollBody: false,
                child: Container(
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(60),
                          topRight: Radius.circular(60))),
                  child: Padding(
                    padding: EdgeInsets.all(30),
                    child: Column(
                      children: [
                        const SizedBox(
                          height: 140,
                        ),
                        IntlPhoneField(
                          cursorColor: Colors.black,
                          dropdownIcon: const Icon(
                            Icons.expand_more,
                            color: Colors.grey,
                          ),
                          decoration: const InputDecoration(
                            labelText: 'Phone Number',
                            labelStyle: TextStyle(color: Colors.black),
                            border: OutlineInputBorder(
                              borderSide: BorderSide(),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.grey),
                            ),
                          ),
                          initialCountryCode: 'AE',
                          onChanged: (phone) {
                            RegisterScreen.phoneNumber = phone.completeNumber;
                          },
                        ),
                        const SizedBox(
                          height: 80,
                        ),
                        GetBuilder<RegisterController>(
                            init: RegisterController(),
                            builder: (controller) {
                              return ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                      backgroundColor: Color(0xffd35400),
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(10))),
                                  onPressed: () {
                                    if (RegisterScreen.phoneNumber == '') {
                                      Get.snackbar('Phone number needed',
                                          'Please enter your phone number first',
                                          snackPosition: SnackPosition.BOTTOM);
                                    } else {
                                      Get.snackbar(
                                          'Sending Code', 'please wait',snackPosition: SnackPosition.BOTTOM);
                                      controller.verifyPhoneNumber();
                                    }
                                  },
                                  child: Container(
                                    padding: const EdgeInsets.all(20),
                                    child: const Text("Send Verification Code"),
                                  ));
                            }),
                        const SizedBox(
                          height: 20,
                        ),
                      ],
                    ),
                  ),
                ),
              )
            ]))
          ],
        ),
      ),
    ));
  }
}
