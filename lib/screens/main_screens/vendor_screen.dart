import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expandable_text/expandable_text.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:get/get.dart';
import 'package:orders_chat_app/controller/main_screens_controllers/vendor_controller.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import '../orders_screen/vendor_order_informations_screen2.dart';
import '../screens_widgets/side_menu_section/side_menu_section.dart';

class VendorScreen extends GetView<VendorController> {
  VendorScreen({super.key});

  final VendorController vendorController = Get.put(VendorController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
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
        body: Obx(() {
          final ordersWithUsers = vendorController.ordersWithUsers;
          if (ordersWithUsers.isEmpty) {
            return const Center(child: CircularProgressIndicator());
          } else {
            return RefreshIndicator(
              onRefresh: () => controller.fetchDate(),
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: ordersWithUsers.length,
                itemBuilder: (context, i) {
                  final order = ordersWithUsers[i];
                  final hasMoreImages = order.itemImages!.length > 3;
                  final displayedImages = hasMoreImages
                      ? order.itemImages!.sublist(0, 3)
                      : order.itemImages;
                  return Column(
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
                                      backgroundImage: order
                                                  .user!.profilePicture !=
                                              ''
                                          ? NetworkImage(
                                              '${order.user!.profilePicture}')
                                          : null,
                                      minRadius: 25,
                                      backgroundColor: Colors.grey),
                                  const SizedBox(
                                    width: 5,
                                  ),
                                  Expanded(
                                    flex: 7,
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        order.user!.name != ''
                                            ? Text('${order.user!.name}')
                                            : Text(
                                                '${order.user!.phoneNumber}'),
                                        const SizedBox(
                                          height: 4,
                                        ),
                                        Text('${order.orderDate}')
                                      ],
                                    ),
                                  ),
                                  Expanded(
                                    flex: 2,
                                    child: IconButton(
                                        onPressed: () {
                                          controller.openOrderDetails(
                                            order.orderId,
                                            order.carBrand,
                                            order.carChassisNumber,
                                            order.carType,
                                            order.carYear,
                                            order.itemDetails,
                                            order.itemImages,
                                            order.orderDate,
                                            order.userId,
                                            order.user?.name,
                                            order.user?.profilePicture,
                                            order.user?.phoneNumber,
                                          );
                                        },
                                        icon: Icon(
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
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  FittedBox(
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        StyledText(
                                            title: '${order.carBrand}',
                                            color: Colors.yellow),
                                        StyledText(
                                            title: '${order.carType}',
                                            color: Colors.green.shade300),
                                        StyledText(
                                            title: '${order.carYear}',
                                            color: Color(0xffe17055)),
                                        StyledText(
                                            title: '${order.carChassisNumber}',
                                            color: Colors.blue.shade300),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  Padding(
                                      padding:
                                          const EdgeInsets.fromLTRB(8, 0, 8, 0),
                                      child: ExpandableText(
                                        '${order.itemDetails}',
                                        maxLines: 3,
                                        expandText: 'Read more',
                                        collapseText: 'Show less',
                                        linkColor: Colors.blue,
                                      )),
                                ],
                              ),
                            ),
                            order.itemImages!.isNotEmpty
                                ? SizedBox(
                                    // height: 400,
                                    width: Get.width,
                                    child: InkWell(
                                        onTap: () {
                                          controller.openOrderDetails(
                                            order.orderId,
                                            order.carBrand,
                                            order.carChassisNumber,
                                            order.carType,
                                            order.carYear,
                                            order.itemDetails,
                                            order.itemImages,
                                            order.orderDate,
                                            order.userId,
                                            order.user?.name,
                                            order.user?.profilePicture,
                                            order.user?.phoneNumber,
                                          );
                                        },
                                        child: order.itemImages!.length == 1
                                            ? StaggeredGrid.count(
                                                crossAxisCount: 2,
                                                mainAxisSpacing: 2,
                                                crossAxisSpacing: 2,
                                                children: [
                                                  StaggeredGridTile.count(
                                                      crossAxisCellCount: 2,
                                                      mainAxisCellCount: 2,
                                                      child: Image.network(
                                                        order.itemImages![0],
                                                        scale: 0.1,
                                                        fit: BoxFit.cover,
                                                      ))
                                                ],
                                              )
                                            : order.itemImages!.length == 2
                                                ? StaggeredGrid.count(
                                                    crossAxisCount: 2,
                                                    mainAxisSpacing: 2,
                                                    crossAxisSpacing: 2,
                                                    children: [
                                                      StaggeredGridTile.count(
                                                          crossAxisCellCount: 1,
                                                          mainAxisCellCount: 2,
                                                          child: Image.network(
                                                            order
                                                                .itemImages![0],
                                                            fit: BoxFit.cover,
                                                          )),
                                                      StaggeredGridTile.count(
                                                          crossAxisCellCount: 1,
                                                          mainAxisCellCount: 2,
                                                          child: Image.network(
                                                            order
                                                                .itemImages![1],
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
                                                             order
                                                                .itemImages![0],
                                                            fit: BoxFit.cover,
                                                          )),
                                                      StaggeredGridTile.count(
                                                          crossAxisCellCount: 1,
                                                          mainAxisCellCount: 1,
                                                          child: Image.network(
                                                             order
                                                                .itemImages![1],
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
                                                                   order
                                                                .itemImages![
                                                                      2],
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
                                                                        "+${order.itemImages!.length - 3}",
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
                                : const SizedBox(),
                            const SizedBox(height: 30),
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      )
                    ],
                  );
                },
              ),
            );
          }
        }));
  }
}
