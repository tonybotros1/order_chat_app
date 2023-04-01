import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:get/get.dart';

import '../../controller/main_screens_controllers/customer_controller.dart';
import '../orders_screen/add_order_screen2.dart';
import '../orders_screen/customer_order_informations_screen.dart';
import '../screens_widgets/side_menu_section/side_menu_section.dart';
import 'package:expandable_text/expandable_text.dart';

class CustomerScreen extends GetView<CustomerController> {
  CustomerScreen({super.key});

  final CustomerController customerController = Get.put(CustomerController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: Colors.white,
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Get.to(() => AddOrderScreen(),
              transition: Transition.leftToRightWithFade);
        },
        child: Icon(Icons.add),
        backgroundColor: Color(0xffd35400),
      ),
      appBar: AppBar(
        backgroundColor: Color(0xffd35400),
        title: const Text('List of orders'),
        leading: Builder(
            builder: (context) => IconButton(
                  icon: const Icon(Icons.menu),
                  onPressed: () {
                    Scaffold.of(context).openDrawer();
                  },
                )),
      ),
      drawer: const SideMenuSection(),
      body: GetX<CustomerController>(
          init: CustomerController(),
          builder: (controller) {
            if (controller.isLoading.isTrue) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else {
              return RefreshIndicator(
                onRefresh: () => controller.fetchData(),
                child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: controller.orders.length,
                    itemBuilder: (context, i) {
                      var order = controller.orders[i];
                      final hasMoreImages = order['item_images'].length > 3;
                      final displayedImages = hasMoreImages;
                      print(displayedImages);
                      return SingleChildScrollView(
                          child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Container(
                            decoration: BoxDecoration(
                                color: Colors.grey.shade200,
                                borderRadius: BorderRadius.circular(10)),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      CircleAvatar(
                                          backgroundImage: controller
                                                      .profilePicture !=
                                                  ''
                                              ? NetworkImage(
                                                  '${controller.profilePicture}')
                                              : null,
                                          minRadius: 25,
                                          backgroundColor: Colors.grey),
                                      const SizedBox(
                                        width: 5,
                                      ),
                                      Expanded(
                                        flex: 10,
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            controller.userName != ''
                                                ? Text('${controller.userName}')
                                                : Text(
                                                    '${controller.phoneNumber}'),
                                            const SizedBox(
                                              height: 4,
                                            ),
                                            Text('${order['order_date']}')
                                          ],
                                        ),
                                      ),
                                      const SizedBox(
                                        width: 2,
                                      ),
                                      order['isOpen'] == true
                                          ? Expanded(
                                              flex: 12,
                                              child: Text(
                                                'New',
                                                style: TextStyle(
                                                    color: Colors.green,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                            )
                                          : Expanded(
                                              flex: 15,
                                              child: Text(
                                                'Closed',
                                                style: TextStyle(
                                                    color: Colors.red,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                            ),
                                      Expanded(
                                        flex: 4,
                                        child: IconButton(
                                            onPressed: () {
                                              controller
                                                  .goToOrderinformationsScreen(
                                                      order);
                                            },
                                            icon: const Icon(
                                              Icons.info,
                                              color: Colors.grey,
                                            )),
                                      )
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      FittedBox(
                                        child: Row(
                                          children: [
                                            StyledText(
                                                title: '${order['car_brand']}',
                                                color: Colors.yellow),
                                            StyledText(
                                                title: '${order['car_type']}',
                                                color: Colors.green.shade300),
                                            StyledText(
                                                title: '${order['car_year']}',
                                                color: Color(0xffe17055)),
                                            StyledText(
                                                title:
                                                    '${order['car_chassis_number']}',
                                                color: Colors.blue.shade300),
                                          ],
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      Padding(
                                          padding: const EdgeInsets.fromLTRB(
                                              8, 0, 8, 0),
                                          child:
                                              //  Text('${order['item_details']}'),
                                              ExpandableText(
                                            '${order['item_details']}',
                                            maxLines: 3,
                                            expandText: 'Read more',
                                            collapseText: 'Show less',
                                            linkColor: Colors.blue,
                                          )),
                                    ],
                                  ),
                                ),
                                if (order['item_images'].isNotEmpty)
                                  SizedBox(
                                    // height: 400,
                                    // width: Get.width,
                                    child: InkWell(
                                        onTap: () => controller
                                            .goToOrderinformationsScreen(order),
                                        child: order['item_images']!.length == 1
                                            ? StaggeredGrid.count(
                                                crossAxisCount: 2,
                                                mainAxisSpacing: 2,
                                                crossAxisSpacing: 2,
                                                children: [
                                                  StaggeredGridTile.count(
                                                      crossAxisCellCount: 2,
                                                      mainAxisCellCount: 2,
                                                      child: Image.network(
                                                        order['item_images']![
                                                            0],
                                                        scale: 0.1,
                                                        fit: BoxFit.cover,
                                                      ))
                                                ],
                                              )
                                            : order['item_images']!.length == 2
                                                ? StaggeredGrid.count(
                                                    crossAxisCount: 2,
                                                    mainAxisSpacing: 2,
                                                    crossAxisSpacing: 2,
                                                    children: [
                                                      StaggeredGridTile.count(
                                                          crossAxisCellCount: 1,
                                                          mainAxisCellCount: 2,
                                                          child: Image.network(
                                                            order['item_images']![
                                                                0],
                                                            fit: BoxFit.cover,
                                                          )),
                                                      StaggeredGridTile.count(
                                                          crossAxisCellCount: 1,
                                                          mainAxisCellCount: 2,
                                                          child: Image.network(
                                                            order['item_images']![
                                                                1],
                                                            fit: BoxFit.cover,
                                                          )),
                                                    ],
                                                  )
                                                : StaggeredGrid.count(
                                                    crossAxisCount: 2,
                                                    mainAxisSpacing: 2,
                                                    crossAxisSpacing: 2,
                                                    children: [
                                                      StaggeredGridTile.count(
                                                          crossAxisCellCount: 2,
                                                          mainAxisCellCount: 1,
                                                          child: Image.network(
                                                            order['item_images']![
                                                                0],
                                                            fit: BoxFit.cover,
                                                          )),
                                                      StaggeredGridTile.count(
                                                          crossAxisCellCount: 1,
                                                          mainAxisCellCount: 1,
                                                          child: Image.network(
                                                            order['item_images']
                                                                [1],
                                                            fit: BoxFit.cover,
                                                          )),
                                                      StaggeredGridTile.count(
                                                          crossAxisCellCount: 1,
                                                          mainAxisCellCount: 1,
                                                          child: Stack(
                                                              fit: StackFit
                                                                  .expand,
                                                              children: [
                                                                Image.network(
                                                                  order['item_images']
                                                                      [2],
                                                                  fit: BoxFit
                                                                      .cover,
                                                                ),
                                                                if (hasMoreImages)
                                                                  Container(
                                                                    decoration: BoxDecoration(
                                                                        gradient: LinearGradient(
                                                                            begin:
                                                                                Alignment.topCenter,
                                                                            end: Alignment.bottomCenter,
                                                                            colors: [
                                                                          Colors
                                                                              .grey
                                                                              .withOpacity(0.8),
                                                                          Colors
                                                                              .grey
                                                                              .withOpacity(0.8)
                                                                        ])),
                                                                    child:
                                                                        Center(
                                                                      child:
                                                                          Text(
                                                                        "+${order['item_images']!.length - 3}",
                                                                        style: const TextStyle(
                                                                            color:
                                                                                Colors.white,
                                                                            fontSize: 25),
                                                                      ),
                                                                    ),
                                                                  )
                                                              ])),
                                                    ],
                                                  )),
                                  )
                                else
                                  const SizedBox(),
                                const SizedBox(height: 30),
                              ],
                            ),
                          ),
                          const SizedBox(
                            height: 20,
                          )
                        ],
                      ));
                    }),
              );
            }
          }),
    );
  }
}
