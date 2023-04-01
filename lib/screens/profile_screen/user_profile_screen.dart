// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/src/widgets/container.dart';
// import 'package:flutter/src/widgets/framework.dart';
// import 'package:get/get.dart';

// var user_details;
// var user_id;

// class UserProfileScreen extends StatefulWidget {
//   const UserProfileScreen({super.key});

//   @override
//   State<UserProfileScreen> createState() => _UserProfileScreenState();
// }

// class _UserProfileScreenState extends State<UserProfileScreen> {
//   // String phone_number = '';

//   final name = TextEditingController();
//   final location = TextEditingController();

//    String profilePicture ='';

//   getUserDetails() {
//     FirebaseAuth auth = FirebaseAuth.instance;
//     User? user = auth.currentUser;
//     if (user != null && user.uid.isNotEmpty) {
//       String uid = user.uid;

//       user_details = FirebaseFirestore.instance
//           .collection('user_roles')
//           .where('user_id', isEqualTo: uid)
//           .snapshots();

//       user_details.listen((querySnapshot) {
//         querySnapshot.docs.forEach((doc) {
//           user_id = doc.id;
//           profilePicture = doc['profile_picture'];
//         });
//       });
//     }
//   }

//   @override
//   void initState() {
//     getUserDetails();

//     super.initState();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.white,
//       appBar: AppBar(
//         title: const Text('Profile'),
//         backgroundColor: Color(0xffd35400),
//       ),
//       body: StreamBuilder<QuerySnapshot>(
//         stream: user_details,
//         builder: (context, snapshot) {
//           if (snapshot.hasData) {
//             return ListView.builder(
//                 itemCount: snapshot.data!.size,
//                 itemBuilder: ((context, i) {
//                   return Column(
//                     mainAxisSize: MainAxisSize.min,
//                     children: [
//                       const SizedBox(
//                         height: 40,
//                       ),
//                       Stack(
//                         alignment: AlignmentDirectional.bottomEnd,
//                         children: [
//                           InkWell(
//                             highlightColor: Colors.transparent,
//                             borderRadius: BorderRadius.circular(60),
//                             onTap: () {},
//                             child: const CircleAvatar(
//                               radius: 80,
//                               backgroundColor: Color(0xffb2bec3),
//                               backgroundImage: null,
//                             ),
//                           ),
//                           Container(
//                             height: 50,
//                             width: 50,
//                             decoration: BoxDecoration(
//                                 borderRadius: BorderRadius.circular(50),
//                                 color: Color(0xffd35400)),
//                             child: IconButton(
//                                 onPressed: () {},
//                                 icon: Icon(
//                                   Icons.camera,
//                                   color: Colors.white,
//                                 )),
//                           )
//                         ],
//                       ),
//                       const SizedBox(
//                         height: 40,
//                       ),
//                       Column(
//                         children: [
//                           Details(
//                             title: 'Name',
//                             details: snapshot.data!.docs[i]['name'] == ''
//                                 ? 'Add your name'
//                                 : snapshot.data!.docs[i]['name'],
//                             icon: Icons.person,
//                             iconButton: IconButton(
//                                 onPressed: () {
//                                   showModalBottomSheet(
//                                       isScrollControlled: true,
//                                       shape: RoundedRectangleBorder(
//                                           borderRadius: BorderRadius.only(
//                                         topLeft: Radius.circular(20),
//                                         topRight: Radius.circular(20),
//                                       )),
//                                       context: context,
//                                       builder: (_) {
//                                         return Padding(
//                                           padding: EdgeInsets.only(
//                                             bottom: MediaQuery.of(context)
//                                                 .viewInsets
//                                                 .bottom,
//                                           ),
//                                           child: UpdateDetails(
//                                               title: 'Enter Your Name',
//                                               controller: name,
//                                               fieldName: 'name',
//                                               controllerText: name.text),
//                                         );
//                                       });
//                                 },
//                                 icon: const Icon(
//                                   Icons.edit,
//                                   color: Color(0xffd35400),
//                                 )),
//                           ),
//                           const Padding(
//                             padding: EdgeInsets.fromLTRB(60, 10, 60, 10),
//                             child: Divider(),
//                           ),
//                           Details(
//                               title: 'Location',
//                               details: snapshot.data!.docs[i]['location'] == ''
//                                   ? 'Add your location'
//                                   : snapshot.data!.docs[i]['location'],
//                               icon: Icons.location_on,
//                               iconButton: IconButton(
//                                   onPressed: () {
//                                     showModalBottomSheet(
//                                         isScrollControlled: true,
//                                         shape: RoundedRectangleBorder(
//                                             borderRadius: BorderRadius.only(
//                                           topLeft: Radius.circular(20),
//                                           topRight: Radius.circular(20),
//                                         )),
//                                         context: context,
//                                         builder: (_) {
//                                           return Padding(
//                                             padding: EdgeInsets.only(
//                                               bottom: MediaQuery.of(context)
//                                                   .viewInsets
//                                                   .bottom,
//                                             ),
//                                             child: UpdateDetails(
//                                                 title: 'Enter Your Location',
//                                                 controller: location,
//                                                 fieldName: 'location',
//                                                 controllerText: location.text),
//                                           );
//                                         });
//                                   },
//                                   icon: Icon(
//                                     Icons.edit,
//                                     color: Color(0xffd35400),
//                                   ))),
//                           Padding(
//                             padding: const EdgeInsets.fromLTRB(60, 10, 60, 10),
//                             child: Divider(),
//                           ),
//                           Details(
//                             title: 'Phone',
//                             details: snapshot.data!.docs[i]['phone_number'],
//                             icon: Icons.phone,
//                           ),
//                         ],
//                       )
//                     ],
//                   );
//                 }));
//           } else if (snapshot.hasData) {
//             return Center(
//               child: Text('${snapshot.error}'),
//             );
//           } else {
//             return Center(child: CircularProgressIndicator());
//           }
//         },
//       ),
//     );
//   }
// }

// Widget Details({
//   required icon,
//   required String title,
//   required String details,
//   Widget? iconButton,
// }) {
//   return Container(
//     child: Row(
//       // mainAxisAlignment: MainAxisAlignment.end,
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Expanded(
//             flex: 2,
//             child: Icon(
//               icon,
//               color: Colors.grey,
//             )),
//         Expanded(
//           flex: 7,
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Text(
//                 title,
//                 style: const TextStyle(color: Colors.grey, fontSize: 16),
//               ),
//               const SizedBox(
//                 height: 3,
//               ),
//               Text(
//                 details,
//                 style: const TextStyle(
//                   color: Colors.black,
//                   fontSize: 15,
//                 ),
//               )
//             ],
//           ),
//         ),
//         Expanded(flex: 2, child: iconButton == null ? SizedBox() : iconButton)
//       ],
//     ),
//   );
// }

// class UpdateDetails extends StatelessWidget {
//   final String title;
//   final TextEditingController controller;
//   final String fieldName;
//   String controllerText;

//   UpdateDetails({
//     Key? key,
//     required this.title,
//     required this.controller,
//     required this.fieldName,
//     required this.controllerText,
//   }) : super(key: key);

//   void Update() {
//     CollectionReference update =
//         FirebaseFirestore.instance.collection('user_roles');
//     update.doc('$user_id').update({fieldName: controllerText});
//     Get.back();
//   }

//   @override
//   Widget build(BuildContext context) {
//     var style = const TextStyle(color: Color(0xff778ca3));

//     controller.addListener(() {
//       controllerText = controller.text;
//     });

//     return SingleChildScrollView(
//       child: Padding(
//         padding: EdgeInsets.only(
//           bottom: MediaQuery.of(context).viewInsets.bottom,
//         ),
//         child: Container(
//           decoration: BoxDecoration(
//             borderRadius: BorderRadius.circular(20),
//             color: Colors.white,
//           ),
//           height: 200,
//           child: Column(
//             mainAxisSize: MainAxisSize.min,
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Padding(
//                 padding: const EdgeInsets.all(20.0),
//                 child: Text(
//                   title,
//                   style: style,
//                 ),
//               ),
//               Expanded(
//                 flex: 2,
//                 child: Padding(
//                   padding: const EdgeInsets.fromLTRB(20, 0, 80, 0),
//                   child: TextFormField(
//                     controller: controller,
//                     decoration: const InputDecoration(
//                       focusedBorder: UnderlineInputBorder(
//                           borderSide: BorderSide(color: Color(0xff34495e))),
//                     ),
//                   ),
//                 ),
//               ),
//               Expanded(
//                 flex: 2,
//                 child: Row(
//                   mainAxisAlignment: MainAxisAlignment.end,
//                   children: [
//                     TextButton(
//                         onPressed: () {
//                           Get.back();
//                         },
//                         child: Text('Cancel', style: style)),
//                     TextButton(
//                         onPressed: () {
//                           Update();
//                         },
//                         child: Text('Save', style: style)),
//                     SizedBox(
//                       width: 30,
//                     )
//                   ],
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
