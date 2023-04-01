import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:get/get.dart';
import 'package:orders_chat_app/models/order_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../controller/order_controllers/order_information_controller.dart';
import '../../models/chat_model.dart';
import '../chat_screen/chat_screen.dart';
import '../chat_screen/my_chats_screen.dart';
import '../screens_widgets/side_menu_section/order_informations_widget/order_details_card_widget.dart';

class VendorOrderScreenInformations
    extends GetView<OrderInformationController> {
  const VendorOrderScreenInformations({super.key});

  @override
  Widget build(BuildContext context) {
    final OrderInformationController orderInformationController =
        Get.put(OrderInformationController());

    return Scaffold(
        backgroundColor: Colors.grey[200],
        appBar: AppBar(
          actions: [
            TextButton.icon(
                onPressed: () {
                  orderInformationController.goToChat();
                },
                icon: const Icon(
                  Icons.chat_rounded,
                  color: Colors.white,
                  size: 25,
                ),
                label: const Text(
                  'Chat Now',
                  style: TextStyle(color: Colors.white, fontSize: 20),
                )),
            const SizedBox(
              width: 5,
            )
          ],
          backgroundColor: const Color(0xffd35400),
          title: const Text(
            'Informations',
            style: TextStyle(color: Colors.white),
          ),
        ),
        body: GetX<OrderInformationController>(
            init: OrderInformationController(),
            builder: (controller) {
              return SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          CircleAvatar(
                              backgroundImage: controller
                                          .argument.value.profilePicture !=
                                      ''
                                  ? NetworkImage(
                                      '${controller.argument.value.profilePicture}')
                                  : null,
                              minRadius: 25,
                              backgroundColor: Colors.grey),
                          const SizedBox(
                            width: 5,
                          ),
                          Expanded(
                            flex: 7,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                controller.argument.value.userName != ''
                                    ? Text(
                                        '${controller.argument.value.userName}')
                                    : Text(
                                        '${controller.argument.value.phoneNumber}'),
                                const SizedBox(
                                  height: 4,
                                ),
                                Text('${controller.argument.value.orderDate}')
                              ],
                            ),
                          ),
                          Obx(() => TextButton(
                              onPressed: () {
                                Get.dialog(AlertDialog(
                                  title: const Text('Alert'),
                                  content: Text(controller.isOpenForVendor.value
                                      ? 'This will close the order permanently'
                                      : 'This will open the order again'),
                                  actions: [
                                    TextButton(
                                      child: const Text('Cancel'),
                                      onPressed: () {
                                        Get.back();
                                      },
                                    ),
                                    TextButton(
                                      child: Text(
                                          controller.isOpenForVendor.value
                                              ? 'Close'
                                              : 'Open'),
                                      onPressed: () {
                                        controller.isOpenForVendor.value
                                            ? controller.closeVendorOrder()
                                            : controller.openVendorOrder();
                                        Get.back();
                                      },
                                    ),
                                  ],
                                ));
                              },
                              child: StyledText(
                                  title: controller.isOpenForVendor.value
                                      ? 'Close'
                                      : 'Closed',
                                  color: const Color(0xffb2bec3))))
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          FittedBox(
                            child: Row(
                              children: [
                                StyledText(
                                    title:
                                        '${controller.argument.value.carBrand}',
                                    color: Colors.yellow),
                                StyledText(
                                    title:
                                        '${controller.argument.value.carType}',
                                    color: Colors.green.shade300),
                                StyledText(
                                    title:
                                        '${controller.argument.value.carChassisNumber}',
                                    color: Color(0xffe17055)),
                                StyledText(
                                    title:
                                        '${controller.argument.value.carYear}',
                                    color: Colors.blue.shade300),
                              ],
                            ),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(8, 0, 8, 0),
                            child: Text(
                                '${controller.argument.value.itemDetails}'),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          SizedBox(
                            width: Get.width,
                            child: ListView.builder(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                itemCount: controller
                                    .argument.value.itemImages!.length,
                                itemBuilder: (context, i) {
                                  return Column(
                                    children: [
                                      Padding(
                                        
                                        padding: const EdgeInsets.all(3.0),
                                        child: Image.network(
                                          '${controller.argument.value.itemImages![i]}',
                                          fit: BoxFit.cover,
                                          scale: 0.1,
                                          errorBuilder: (BuildContext context,
                                              Object exception,
                                              StackTrace? stackTrace) {
                                            return Center(
                                                child: Icon(Icons.broken_image,
                                                    color:
                                                        Colors.grey.shade700));
                                          },
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 10,
                                      )
                                    ],
                                  );
                                }),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            }));
  }
}

Widget StyledText({
  required String title,
  required Color color,
}) {
  return Row(
    children: [
      Container(
        decoration:
            BoxDecoration(color: color, borderRadius: BorderRadius.circular(5)),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(12, 8, 12, 8),
          child: Text(
            title,
            style:
                TextStyle(color: Colors.grey[800], fontWeight: FontWeight.bold),
          ),
        ),
      ),
      const SizedBox(
        width: 10,
      )
    ],
  );
}
