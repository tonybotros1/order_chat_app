// import 'dart:convert';

// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/src/widgets/container.dart';
// import 'package:flutter/src/widgets/framework.dart';
// import 'package:get/get.dart';
// import 'package:orders_chat_app/models/order_model.dart';
// import 'package:shared_preferences/shared_preferences.dart';

// import '../../controller/order_controllers/order_information_controller.dart';
// import '../../models/chat_model.dart';
// import '../chat_screen/chat_screen.dart';
// import '../chat_screen/my_chats_screen.dart';
// import '../screens_widgets/side_menu_section/order_informations_widget/order_details_card_widget.dart';

// class OrderScreenInformations extends GetView<OrderInformationController> {
//   const OrderScreenInformations({super.key});

//   @override
//   Widget build(BuildContext context) {
//     final OrderInformationController controller =
//         Get.put(OrderInformationController());

//     return Scaffold(
//       body: NestedScrollView(
//           controller: controller.scrollController,
//           headerSliverBuilder: (context, innerBoxIsScrolled) => [
//                 GetX<OrderInformationController>(
//                     init: OrderInformationController(),
//                     builder: (controller) {
//                       return SliverAppBar(
//                         leading: controller.isAppBarExpanded.value
//                             ? IconButton(
//                                 onPressed: () {
//                                   Get.back();
//                                 },
//                                 icon: Icon(
//                                   Icons.arrow_back,
//                                 ))
//                             : IconButton(
//                                 onPressed: () {
//                                   Get.back();
//                                 },
//                                 icon: Icon(
//                                   Icons.arrow_back,
//                                   color: Colors.black,
//                                 )),
//                         expandedHeight: Get.height * 0.1,
//                         stretch: true,
//                         backgroundColor: Color(0xffd35400),
//                         flexibleSpace: FlexibleSpaceBar(
//                           background: Container(
//                             color: Colors.white,
//                           ),
//                           centerTitle: true,
//                           title: controller.isAppBarExpanded.value
//                               ? const Text(
//                                   'Informations',
//                                   style: TextStyle(color: Colors.white),
//                                 )
//                               : const Text(
//                                   'Informations',
//                                   style: TextStyle(
//                                       color: Colors.black, fontSize: 15),
//                                 ),
//                           stretchModes: const [
//                             StretchMode.zoomBackground,
//                             StretchMode.blurBackground,
//                           ],
//                         ),
//                         floating: false,
//                         pinned: true,
//                       );
//                     })
//               ],
//           body: GetX<OrderInformationController>(
//               // init: OrderInformationController(),
//               builder: (controller) {
//             return CustomScrollView(
//               slivers: [
//                 SliverFillRemaining(
//                   hasScrollBody: false,
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       controller.role == 'Customer'
//                           ? Padding(
//                               padding: const EdgeInsets.fromLTRB(15, 0, 15, 0),
//                               child: Container(
//                                 height: 120,
//                                 color: Colors.white,
//                                 child: Row(
//                                   mainAxisAlignment:
//                                       MainAxisAlignment.spaceBetween,
//                                   children: [
//                                     Text(
//                                       'Chats',
//                                       style: TextStyle(
//                                           color: Colors.grey, fontSize: 20),
//                                     ),
//                                     //
//                                     Container(
//                                       height: 70,
//                                       width: 70,
//                                       decoration: BoxDecoration(
//                                           color: Color(0xffd35400),
//                                           borderRadius: BorderRadius.circular(
//                                             30,
//                                           )),
//                                       child: IconButton(
//                                           onPressed: () {
//                                             controller.myChats();
//                                           },
//                                           icon: Icon(
//                                             Icons.chat,
//                                             color: Colors.white,
//                                             size: 30,
//                                           )),
//                                     )
//                                   ],
//                                 ),
//                               ),
//                             )
//                           : Padding(
//                               padding: const EdgeInsets.fromLTRB(15, 0, 15, 0),
//                               child: Container(
//                                 height: 120,
//                                 color: Colors.white,
//                                 child: Row(
//                                   mainAxisAlignment:
//                                       MainAxisAlignment.spaceAround,
//                                   children: [
//                                     Column(
//                                       children: [
//                                         SizedBox(
//                                           height: 15,
//                                         ),
//                                         Text(
//                                           'Add to Wish List',
//                                           style: TextStyle(
//                                               color: Colors.grey, fontSize: 15),
//                                         ),
//                                         SizedBox(
//                                           height: 15,
//                                         ),
//                                         Container(
//                                           height: 50,
//                                           width: 50,
//                                           decoration: BoxDecoration(
//                                               color: Color(0xffd35400),
//                                               borderRadius:
//                                                   BorderRadius.circular(
//                                                 30,
//                                               )),
//                                           child: IconButton(
//                                               onPressed: () {
//                                                 // controller.myChats();
//                                               },
//                                               icon: Icon(
//                                                 Icons.favorite,
//                                                 color: Colors.white,
//                                                 size: 30,
//                                               )),
//                                         )
//                                       ],
//                                     ),
//                                     Column(
//                                       children: [
//                                         SizedBox(
//                                           height: 15,
//                                         ),
//                                         Text(
//                                           'Reply',
//                                           style: TextStyle(
//                                               color: Colors.grey, fontSize: 15),
//                                         ),
//                                         SizedBox(
//                                           height: 15,
//                                         ),
//                                         Container(
//                                           height: 50,
//                                           width: 50,
//                                           decoration: BoxDecoration(
//                                               color: Color(0xffd35400),
//                                               borderRadius:
//                                                   BorderRadius.circular(
//                                                 30,
//                                               )),
//                                           child: IconButton(
//                                               onPressed: () {
//                                                 controller.goToChat();
//                                               },
//                                               icon: Icon(
//                                                 Icons.chat,
//                                                 color: Colors.white,
//                                                 size: 30,
//                                               )),
//                                         )
//                                       ],
//                                     )
//                                   ],
//                                 ),
//                               ),
//                             ),
//                       if (controller.argument.value.itemImages!.isNotEmpty)
//                         Padding(
//                           padding: const EdgeInsets.symmetric(vertical: 20),
//                           child: Container(
//                             height: 160,
//                             width: Get.width,
//                             decoration: const BoxDecoration(
//                               color: Colors.white,
//                             ),
//                             child: Column(
//                               crossAxisAlignment: CrossAxisAlignment.start,
//                               children: [
//                                 Padding(
//                                   padding:
//                                       const EdgeInsets.fromLTRB(15, 8, 8, 8),
//                                   child: Text(
//                                     'Media',
//                                     style: TextStyle(
//                                         color: Colors.grey, fontSize: 16),
//                                   ),
//                                 ),
//                                 Row(
//                                   children: [
//                                     Container(
//                                       height: 120,
//                                       width: Get.width,
//                                       child: ListView.builder(
//                                           shrinkWrap: true,
//                                           scrollDirection: Axis.horizontal,
//                                           itemCount: controller.argument.value
//                                               .itemImages!.length,
//                                           itemBuilder: (context, i) {
//                                             return Padding(
//                                               padding:
//                                                   const EdgeInsets.symmetric(
//                                                       horizontal: 8),
//                                               child: ClipRRect(
//                                                 borderRadius:
//                                                     BorderRadius.circular(20),
//                                                 child: SizedBox(
//                                                   height: 40,
//                                                   width: 120,
//                                                   child: InkWell(
//                                                     onTap: () {
//                                                       print('object');
//                                                     },
//                                                     child: Ink(
//                                                       child: FittedBox(
//                                                         clipBehavior: Clip
//                                                             .antiAliasWithSaveLayer,
//                                                         fit: BoxFit.cover,
//                                                         child: Image.network(
//                                                             '${controller.argument.value.itemImages![i]}'),
//                                                       ),
//                                                     ),
//                                                   ),
//                                                 ),
//                                               ),
//                                             );
//                                           }),
//                                     )
//                                   ],
//                                 )
//                               ],
//                             ),
//                           ),
//                         )
//                       else
//                         SizedBox(
//                           height: 20,
//                         ),
//                       OrderDetailsCardWidgets(
//                         title: 'Order Date:',
//                         value: '${controller.argument.value.orderDate}',
//                       ),
//                       OrderDetailsCardWidgets(
//                         title: 'Car Make:',
//                         value: '${controller.argument.value.carBrand}',
//                       ),
//                       OrderDetailsCardWidgets(
//                         title: 'Car Model:',
//                         value: '${controller.argument.value.carType}',
//                       ),
//                       OrderDetailsCardWidgets(
//                         title: 'Car Year:',
//                         value: '${controller.argument.value.carYear}',
//                       ),
//                       OrderDetailsCardWidgets(
//                         title: 'Chassis Number:',
//                         value: '${controller.argument.value.carChassisNumber}',
//                       ),
//                       OrderDetailsCardWidgets(
//                         title: 'Item Details:',
//                         value: '${controller.argument.value.itemDetails}',
//                       ),
//                       Row(
//                         mainAxisAlignment: MainAxisAlignment.spaceAround,
//                         children: [
//                           controller.role == 'Vendor'
//                               ? TextButton.icon(
//                                   onPressed: () {
//                                     controller.goToChat();
//                                   },
//                                   icon: const Icon(
//                                     Icons.reply,
//                                     color: Colors.white,
//                                   ),
//                                   label: const Text(
//                                     'Reply',
//                                     style: TextStyle(color: Colors.white),
//                                   ),
//                                 )
//                               : const SizedBox(),
//                         ],
//                       ),
//                     ],
//                   ),
//                 )
//               ],
//             );
//           })),
//     );
//   }
// }
