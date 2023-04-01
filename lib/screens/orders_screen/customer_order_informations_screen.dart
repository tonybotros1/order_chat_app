import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controller/order_controllers/order_information_controller.dart';

class CustomerOrderScreenInformations
    extends GetView<OrderInformationController> {
  const CustomerOrderScreenInformations({super.key});

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
                  orderInformationController.myChats();
                },
                icon: const Icon(
                  Icons.chat_rounded,
                  color: Colors.white,
                  size: 25,
                ),
                label: const Text(
                  'Replys',
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
                              backgroundImage: controller.profilePicture != ''
                                  ? NetworkImage('${controller.profilePicture}')
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
                                controller.userName != ''
                                    ? Text('${controller.userName}')
                                    : Text('${controller.phoneNumber}'),
                                const SizedBox(
                                  height: 4,
                                ),
                                Text('${controller.argument.value.orderDate}')
                              ],
                            ),
                          ),
                          TextButton(
                              onPressed: () {
                                Get.dialog(AlertDialog(
                                  title: const Text('Alert'),
                                  content: Text(controller.isOpen == true
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
                                      child: Text(controller.isOpen == true
                                          ? 'Close'
                                          : 'Open'),
                                      onPressed: () {
                                        controller.isOpen == true
                                            ? controller.closeOrder()
                                            : controller.openOrder();
                                        Get.back();
                                      },
                                    ),
                                  ],
                                ));
                              },
                              child: StyledText(
                                  title: controller.isOpen == true
                                      ? 'Close'
                                      : 'Closed',
                                  color: const Color(0xffb2bec3)))
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
                                        '${controller.argument.value.carYear}',
                                    color: Colors.blue.shade300),
                                StyledText(
                                    title:
                                        '${controller.argument.value.carChassisNumber}',
                                    color: Color(0xffe17055)),
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
                                      Image.network(
                                        '${controller.argument.value.itemImages![i]}',
                                        fit: BoxFit.cover,
                                        scale: 0.1,
                                        errorBuilder: (BuildContext context,
                                            Object exception,
                                            StackTrace? stackTrace) {
                                          return Center(
                                            child: Icon(
                                              Icons.broken_image,
                                              color: Colors.grey.shade700,
                                            ),
                                          );
                                        },
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
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5),
          color: color,
        ),
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
