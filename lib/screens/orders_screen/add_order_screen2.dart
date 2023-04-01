import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controller/order_controllers/add_order_controller.dart';

class AddOrderScreen extends StatelessWidget {
  AddOrderScreen({super.key});

  final AddOrderController addOrderController = Get.put(AddOrderController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: Colors.grey[300],
      appBar: AppBar(
        backgroundColor: Color(0xffd35400),
        title: const Center(child: Text('Add new Order')),
        actions: [
          IconButton(
              onPressed: () {
                Get.snackbar('Saving', 'Please wait...',snackPosition: SnackPosition.BOTTOM);
                addOrderController.addOrder();
              },
              icon: const Icon(Icons.done)),
          const SizedBox(
            width: 10,
          )
        ],
      ),
      body: CustomScrollView(slivers: [
        SliverFillRemaining(
          hasScrollBody: false,
          child: Container(
            padding: EdgeInsets.all(30),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 20,
                ),

                BuildCarBrandDropDownButton(),

                // BuildCarsDropDownButton(),
                SizedBox(
                  height: 10,
                ),
                BuildTextFormField(
                    lableText: 'Car Year',
                    controller: addOrderController.carYear,
                    obscureText: false),
                SizedBox(
                  height: 10,
                ),
                BuildTextFormField(
                    lableText: 'Chassis Number',
                    controller: addOrderController.carChassisNumber,
                    obscureText: false),

                // SizedBox(
                //   height: 15,
                // ),

                // Text('Details',
                //     style: TextStyle(
                //         color: Color(0xff34495e),
                //         fontWeight: FontWeight.bold,
                //         fontSize: 15)),
                SizedBox(
                  height: 15,
                ),
                GetX<AddOrderController>(
                    init: AddOrderController(),
                    builder: (controller) {
                      return add_order_details(
                        controller: controller.itemDetails,
                        width: addOrderController.width,
                        icon: IconButton(
                          onPressed: () {
                            addOrderController.uploadImage();
                          },
                          icon: Icon(
                            Icons.add_a_photo,
                            color: Color(0xff34495e),
                          ),
                        ),
                        gridPickedImages: controller.images.isEmpty
                            ? Center(
                                child: Text(
                                'Add Your Pictures Here',
                                style: TextStyle(color: Colors.grey),
                              ))
                            : GridView.builder(
                                itemCount: controller.images.length,
                                gridDelegate:
                                    SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 3,
                                ),
                                itemBuilder: (context, i) {
                                  return Container(
                                    margin: EdgeInsets.all(3),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(20),
                                      child: FittedBox(
                                        fit: BoxFit.cover,
                                        clipBehavior: Clip.hardEdge,
                                        child: InkWell(
                                          onLongPress: () {
                                            controller.images.removeAt(i);
                                          },
                                          child: Ink(
                                            child: Image.file(
                                              File(controller.images[i].path),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              ),
                      );
                    }),
                SizedBox(
                  height: 30,
                ),
              ],
            ),
          ),
        )
      ]),
    );
  }
}

class BuildCarBrandDropDownButton extends GetView<AddOrderController> {
  BuildCarBrandDropDownButton({super.key});

  final AddOrderController addOrderController = Get.put(AddOrderController());

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        GetX<AddOrderController>(
            init: AddOrderController(),
            builder: (controller) {
              if (controller.isLoading.isTrue) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              } else {
                return Column(
                  children: [
                    DropdownButtonFormField(
                        decoration: InputDecoration(
                            enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(15),
                                borderSide: BorderSide(
                                  color: Color(0xff4b6584),
                                ))),
                        value: controller.carsBrandsList[0]['brand_name'],
                        items: controller.carsBrandsList.map((data) {
                          return DropdownMenuItem(
                              onTap: () async {
                                controller.carTypesList.removeRange(
                                    1, controller.carTypesList.length);
                                controller.dropdownvalueFirstType.value =
                                    'Model';

                                controller.getBrandTypes(data['brand_name']);
                              },
                              value: data['brand_name'],
                              child: Padding(
                                padding: const EdgeInsets.all(4.0),
                                child: FittedBox(
                                  child: Text(
                                    '${data['brand_name']}',
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Color(0xff34495e)),
                                  ),
                                ),
                              ));
                        }).toList(),
                        onChanged: (val) {
                          controller.carBrand.text = val as String;

                          // dropdownvalueFirstBrand = val!;
                        }),
                    SizedBox(
                      height: 10,
                    ),
                    DropdownButtonFormField(
                      decoration: InputDecoration(
                          enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15),
                              borderSide: BorderSide(
                                color: Color(0xff4b6584),
                              ))),
                      onTap: () {
                        // setState(() {});
                      },
                      value: controller.dropdownvalueFirstType.value,
                      items: controller.carTypesList.map((data) {
                        return DropdownMenuItem(
                            value: data,
                            child: Padding(
                              padding: const EdgeInsets.all(4.0),
                              child: FittedBox(
                                child: Text(
                                  '${data}',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Color(0xff34495e)),
                                ),
                              ),
                            ));
                      }).toList(),
                      onChanged: (val) {
                        controller.dropdownvalueFirstType.value = val!;
                        controller.carType.text = val;
                      },
                    )
                  ],
                );
              }
            }),
      ],
    );
  }
}

TextFormField BuildTextFormField({
  required TextEditingController controller,
  required String lableText,
  // required Icon icon,
  required bool obscureText,
  IconButton? icon,
}) {
  return TextFormField(
    controller: controller,
    cursorColor: Colors.black,
    obscureText: obscureText,
    cursorWidth: 1,
    decoration: InputDecoration(
      suffixIcon: icon,
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Color(0xff4b6584), width: 2),
        borderRadius: BorderRadius.circular(15),
      ),
      enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Color(0xff4b6584), width: 1),
        borderRadius: BorderRadius.circular(15),
      ),
      labelText: lableText,
      labelStyle: const TextStyle(
          color: Color(0xff34495e), fontWeight: FontWeight.bold, fontSize: 14),
    ),
  );
}

Widget add_order_details({
  required double width,
  required icon,
  required gridPickedImages,
  required TextEditingController controller,
}) {
  return Container(
    width: width,
    height: 450,
    decoration: BoxDecoration(
        border: Border.all(
          color: Color(0xff34495e),
        ),
        borderRadius: BorderRadius.circular(15)),
    child: Column(
      children: [
        Expanded(
          flex: 6,
          child: Container(
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(15)),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Form(
                  child: TextFormField(
                controller: controller,
                decoration: const InputDecoration(
                  border: InputBorder.none,
                  hintText: 'Enter order details',
                ),
                cursorWidth: 1,
                cursorColor: Color(0xff34495e),
                keyboardType: TextInputType.multiline,
                maxLines: 10,
              )),
            ),
          ),
        ),
        Expanded(
          flex: 5,
          child: ClipRRect(
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(14),
              topRight: Radius.circular(14),
            ),
            child: Container(
              decoration: const BoxDecoration(
                border: Border(
                  top: BorderSide(
                    color: Color(0xff34495e),
                  ),
                ),
              ),
              child: Column(
                children: [
                  const SizedBox(
                    height: 2,
                  ),
                  Expanded(
                    child: Container(
                      width: width,
                      child: gridPickedImages,
                    ),
                  ),
                  Container(
                    child: icon,
                  ),
                ],
              ),
            ),
          ),
        )
      ],
    ),
  );
}
