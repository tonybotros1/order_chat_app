// import 'dart:convert';

// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:firebase_messaging/firebase_messaging.dart';
// import 'package:flutter/src/widgets/container.dart';
// import 'package:flutter/src/widgets/framework.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:msh_checkbox/msh_checkbox.dart';
// import 'package:orders_chat_app/screens/auth_screens/register_screen.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';

// import 'register_screen.dart';

// var rolesList = [];
// List<bool> checkcheck = [];

// class RegisterScreen2 extends StatefulWidget {
//   const RegisterScreen2({super.key});

//   @override
//   State<RegisterScreen2> createState() => _RegisterScreen2State();
// }

// class _RegisterScreen2State extends State<RegisterScreen2> {
//   saveLogin(bool logedIn, String role) async {
//     SharedPreferences loginPref = await SharedPreferences.getInstance();
//     loginPref.setBool('LogedIn', logedIn);
//     loginPref.setString('Role', role);
//     print(role);
//   }

//   String? userToken;

//   void getUserToken() {
//     FirebaseMessaging.instance.getToken().then((token) {
//       userToken = token;
//     });
//   }

//   RegisterUser() async {
//     FirebaseAuth auth = FirebaseAuth.instance;
//     User? currentUser = auth.currentUser;
//     final String uid = currentUser!.uid;

//     CollectionReference userRoles =
//         FirebaseFirestore.instance.collection('user_roles');
//     userRoles.add({
//       "user_id": uid,
//       "user_role": rolesList,
//       "phone_number": RegisterScreen.phoneNumber,
//       "name": "",
//       "location": "",
//       "profile_picture": "",
//       "user_token": userToken
//     }).then((value) {
//       saveLogin(true, rolesList[0]);
//       Get.offNamed((rolesList[0]));
//     }).catchError((error) {
//       // An error occurred while saving the data
//       print("Error saving user data: $error");
//     });
//   }

//   @override
//   void initState() {
//     getUserToken();
//     super.initState();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return SafeArea(
//       child: Scaffold(
//         body: Container(
//           width: double.infinity,
//           decoration: BoxDecoration(
//             gradient: LinearGradient(
//               begin: Alignment.topCenter,
//               colors: [
//                 // Color(0xff2d3436),
//                 Color(0xffd35400),
//                 Color(0xffe67e22),
//               ],
//             ),
//           ),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               const SizedBox(
//                 height: 30,
//               ),
//               Padding(
//                   padding: EdgeInsets.all(20),
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Text(
//                         'Register',
//                         style: TextStyle(color: Colors.white, fontSize: 40),
//                       ),
//                       Text(
//                         'Sign Up For Free',
//                         style: TextStyle(color: Colors.white, fontSize: 20),
//                       )
//                     ],
//                   )),
//               Expanded(
//                   child: CustomScrollView(slivers: [
//                 SliverFillRemaining(
//                   hasScrollBody: false,
//                   child: Container(
//                     decoration: BoxDecoration(
//                         color: Colors.white,
//                         borderRadius: BorderRadius.only(
//                             topLeft: Radius.circular(60),
//                             topRight: Radius.circular(60))),
//                     child: Padding(
//                       padding: EdgeInsets.all(40),
//                       child: Column(
//                         children: [
//                           Text(
//                             'Select your Role:',
//                             style: TextStyle(
//                                 color: Color(0xff4b6584), fontSize: 30),
//                           ),
//                           SizedBox(
//                             height: 40,
//                           ),
//                           const BuildCheckBox(),
//                           SizedBox(
//                             height: 60,
//                           ),
//                           Container(
//                             padding: EdgeInsets.all(5),
//                             decoration: BoxDecoration(
//                                 color: Color(0xffd35400),
//                                 borderRadius: BorderRadius.circular(25)),
//                             child: TextButton(
//                               onPressed: () {
//                                 // register();
//                                 if (rolesList.isEmpty) {
//                                   Get.snackbar('Message', 'Select Role please',
//                                       snackPosition: SnackPosition.BOTTOM);
//                                 } else {
//                                   RegisterUser();
//                                 }
//                               },
//                               child: Text(
//                                 'Register',
//                                 style: TextStyle(color: Colors.white),
//                               ),
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                   ),
//                 )
//               ]))
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

// class BuildCheckBox extends StatefulWidget {
//   const BuildCheckBox({super.key});

//   @override
//   State<BuildCheckBox> createState() => _BuildCheckBoxState();
// }

// class _BuildCheckBoxState extends State<BuildCheckBox> {
//   late Stream<QuerySnapshot> _rolesStream;

//   @override
//   void initState() {
//     super.initState();
//     _rolesStream = FirebaseFirestore.instance.collection('roles').snapshots();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       height: 200,
//       child: StreamBuilder<QuerySnapshot>(
//           stream: _rolesStream,
//           builder: (context, snapshot) {
//             if (!snapshot.hasData) {
//               return Center(
//                 child: CircularProgressIndicator(),
//               );
//             }
//             return ListView.builder(
//                 itemCount: snapshot.data!.size,
//                 itemBuilder: (context, i) {
//                   checkcheck.add(false); // لعبي قيمة كل رول ب فولس بالبداية

//                   final role = snapshot.data!.docs[i];
//                   final roleId = role.id;
//                   final roleName = role['role_name'];

//                   return Row(
//                     mainAxisAlignment: MainAxisAlignment.start,
//                     children: [
//                       MSHCheckbox(
//                         size: 30,
//                         value: checkcheck[i],
//                         colorConfig:
//                             MSHColorConfig.fromCheckedUncheckedDisabled(
//                           checkedColor: Colors.green,
//                         ),
//                         style: MSHCheckboxStyle.stroke,
//                         onChanged: (val) {
//                           setState(() {
//                             checkcheck[i] = !checkcheck[i];
//                           });
//                           if (checkcheck[i] == true) {
//                             rolesList.clear();

//                             rolesList.add(roleName);
//                           } else {
//                             rolesList.remove(roleName);
//                           }
//                         },
//                       ),
//                       SizedBox(
//                         width: 20,
//                       ),
//                       Text(
//                         '${roleName}',
//                         style: TextStyle(color: Color(0xff4b6584)),
//                       ),
//                       SizedBox(
//                         height: 50,
//                       )
//                     ],
//                   );
//                 });
//           }),
//     );
//   }
// }
