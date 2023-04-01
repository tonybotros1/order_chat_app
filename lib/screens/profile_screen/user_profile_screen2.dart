import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:get/get.dart';

import '../../controller/profile_controllers/user_profile_controller.dart';

// var user_details;
// var user_id;

class UserProfileScreen extends GetView<UserProfileController> {
  UserProfileScreen({super.key});

  final UserProfileController userProfileController =
      Get.put(UserProfileController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: const Text('Profile'),
          backgroundColor: Color(0xffd35400),
        ),
        body: GetX<UserProfileController>(
            init: UserProfileController(),
            builder: (controller) {
              if (controller.userDetails.isEmpty) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              } else {
                return ListView.builder(
                    itemCount: controller.userDetails.length,
                    itemBuilder: (context, i) {
                      final detail = controller.userDetails[i];
                      return Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const SizedBox(
                            height: 40,
                          ),
                          Stack(
                            alignment: AlignmentDirectional.bottomEnd,
                            children: [
                              InkWell(
                                highlightColor: Colors.transparent,
                                borderRadius: BorderRadius.circular(60),
                                onTap: () {},
                                child: CircleAvatar(
                                  radius: 80,
                                  backgroundColor: const Color(0xffb2bec3),
                                  backgroundImage: detail.profilePicture != ''
                                      ? NetworkImage('${detail.profilePicture}')
                                      : null,
                                ),
                              ),
                              Container(
                                height: 50,
                                width: 50,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(50),
                                    color: const Color(0xffd35400)),
                                child: IconButton(
                                    onPressed: () {
                                      controller.pickImageFromGallery();
                                    },
                                    icon: const Icon(
                                      Icons.image,
                                      color: Colors.white,
                                    )),
                              )
                            ],
                          ),
                          const SizedBox(
                            height: 40,
                          ),
                          Column(
                            children: [
                              Details(
                                title: 'Name',
                                details: detail.name == ''
                                    ? 'Add your name'
                                    : '${detail.name}',
                                icon: Icons.person,
                                iconButton: IconButton(
                                    onPressed: () {
                                      showModalBottomSheet(
                                          isScrollControlled: true,
                                          shape: const RoundedRectangleBorder(
                                              borderRadius: BorderRadius.only(
                                            topLeft: Radius.circular(20),
                                            topRight: Radius.circular(20),
                                          )),
                                          context: context,
                                          builder: (_) {
                                            return Padding(
                                              padding: EdgeInsets.only(
                                                bottom: MediaQuery.of(context)
                                                    .viewInsets
                                                    .bottom,
                                              ),
                                              child: UpdateDetails(
                                                  title: 'Enter Your Name',
                                                  controller: controller.name,
                                                  fieldName: 'name',
                                                  controllerText:
                                                      controller.name.text),
                                            );
                                          });
                                    },
                                    icon: const Icon(
                                      Icons.edit,
                                      color: Color(0xffd35400),
                                    )),
                              ),
                              const Padding(
                                padding: EdgeInsets.fromLTRB(60, 10, 60, 10),
                                child: Divider(),
                              ),
                              Details(
                                  title: 'Location',
                                  details: detail.location == ''
                                      ? 'Add your location'
                                      : '${detail.location}',
                                  icon: Icons.location_on,
                                  iconButton: IconButton(
                                      onPressed: () {
                                        showModalBottomSheet(
                                            isScrollControlled: true,
                                            shape: const RoundedRectangleBorder(
                                                borderRadius: BorderRadius.only(
                                              topLeft: Radius.circular(20),
                                              topRight: Radius.circular(20),
                                            )),
                                            context: context,
                                            builder: (_) {
                                              return Padding(
                                                padding: EdgeInsets.only(
                                                  bottom: MediaQuery.of(context)
                                                      .viewInsets
                                                      .bottom,
                                                ),
                                                child: UpdateDetails(
                                                    title:
                                                        'Enter Your Location',
                                                    controller:
                                                        controller.location,
                                                    fieldName: 'location',
                                                    controllerText: controller
                                                        .location.text),
                                              );
                                            });
                                      },
                                      icon: const Icon(
                                        Icons.edit,
                                        color: Color(0xffd35400),
                                      ))),
                              const Padding(
                                padding: EdgeInsets.fromLTRB(60, 10, 60, 10),
                                child: Divider(),
                              ),
                              Details(
                                title: 'Phone',
                                details: '${detail.phoneNumber}',
                                icon: Icons.phone,
                              ),
                            ],
                          )
                        ],
                      );
                    });
              }
            }));
  }
}

Widget Details({
  required icon,
  required String title,
  required String details,
  Widget? iconButton,
}) {
  return Container(
    child: Row(
      // mainAxisAlignment: MainAxisAlignment.end,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
            flex: 2,
            child: Icon(
              icon,
              color: Colors.grey,
            )),
        Expanded(
          flex: 7,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(color: Colors.grey, fontSize: 16),
              ),
              const SizedBox(
                height: 3,
              ),
              Text(
                details,
                style: const TextStyle(
                  color: Colors.black,
                  fontSize: 15,
                ),
              )
            ],
          ),
        ),
        Expanded(flex: 2, child: iconButton == null ? SizedBox() : iconButton)
      ],
    ),
  );
}

class UpdateDetails extends StatelessWidget {
  final String title;
  final TextEditingController controller;
  final String fieldName;
  String controllerText;

  UpdateDetails({
    Key? key,
    required this.title,
    required this.controller,
    required this.fieldName,
    required this.controllerText,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var style = const TextStyle(color: Color(0xff778ca3));

    controller.addListener(() {
      controllerText = controller.text;
    });

    return GetBuilder<UserProfileController>(builder: (profileController) {
      return SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: Colors.white,
            ),
            height: 200,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Text(
                    title,
                    style: style,
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(20, 0, 80, 0),
                    child: TextFormField(
                      controller: controller,
                      decoration: const InputDecoration(
                        focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Color(0xff34495e))),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
                          onPressed: () {
                            Get.back();
                          },
                          child: Text('Cancel', style: style)),
                      TextButton(
                          onPressed: () {
                            profileController.updateDetails(
                                fieldName, controllerText);
                            Get.back();
                          },
                          child: Text('Save', style: style)),
                      const SizedBox(
                        width: 30,
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    });
  }
}
