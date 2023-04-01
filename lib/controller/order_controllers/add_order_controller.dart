import 'dart:convert';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

import '../../models/order_model.dart';
import '../../screens/main_screens/customer_screen.dart';

class AddOrderController extends GetxController {
  // final RxList<DocumentSnapshot> carsBrands = RxList<DocumentSnapshot>([]);

  final RxList<Map<dynamic, dynamic>> carsBrandsList =
      RxList<Map<dynamic, dynamic>>();

  List<String> carTypesList = <String>[].obs;
  final TextEditingController carYear = TextEditingController();
  final TextEditingController carChassisNumber = TextEditingController();
  final TextEditingController itemDetails = TextEditingController();
  final TextEditingController orderDate = TextEditingController();
  final TextEditingController carBrand = TextEditingController();
  final TextEditingController carType = TextEditingController();
  final List images = [].obs;
  List<String> imagesURL = <String>[].obs;
  List<XFile>? pickedImages;
  final imagePicker = ImagePicker();
  late final UploadTask uploadTask;
  File? file;

  var width = Get.width;

  RxString dropdownvalueFirstType = RxString('Model');

  RxBool isLoading = RxBool(true);
  RxBool isLoading2 = RxBool(true);

  final documentData = {'brand_name': 'Make'};

  @override
  void onInit() {
    orderDate.text = DateFormat('yyyy-MM-dd').format(DateTime.now());
    carTypesList.add('Model');
    // carTypesList.removeRange(1, carTypesList.length);
    getCarsBrand();
    print(imagesURL.length);
    super.onInit();
  }

  @override
  void onClose() {
    carYear.dispose();
    carChassisNumber.dispose();
    itemDetails.dispose();
    orderDate.dispose();
    super.onClose();
  }

  getCarsBrand() {
    try {
      carsBrandsList.add(documentData);
      FirebaseFirestore.instance
          .collection('carBrand')
          .snapshots()
          .listen((event) {
        event.docs.map((data) {
          carsBrandsList.addAll([data.data()]);
        }).toList();
      });
    } catch (e) {
      print("Error: $e");
    } finally {
      isLoading.value = false;
    }
  }

  void getBrandTypes(brandName) async {
    try {
      await FirebaseFirestore.instance
          .collection('carType')
          .where('car_brand', isEqualTo: brandName)
          .get()
          .then((value) {
        for (var element in value.docs) {
          carTypesList.add((element.data())['type_name']);
        }
      });
    } catch (e) {
      print('Error: $e');
    } finally {
      isLoading2.value = false;
    }
  }

  void addOrder() async {
    FirebaseAuth auth = FirebaseAuth.instance;
    User? user = auth.currentUser;
    final String uid = user!.uid;

    if (carYear.text.isEmpty ||
        itemDetails.text.isEmpty ||
        carBrand.text.isEmpty ||
        carType.text.isEmpty) {
      Get.snackbar('Some fields are empty', 'Please fill all fields',
          snackPosition: SnackPosition.BOTTOM);
    } else {
      CollectionReference order =
          FirebaseFirestore.instance.collection('orders');

      final Reference ref = FirebaseStorage.instance
          .ref()
          .child('order_images')
          .child('${DateTime.now().millisecondsSinceEpoch}.jpg');
      uploadTask = ref.putFile(file!);
      await uploadTask.whenComplete(() async {
        final String downloadUrl = await ref.getDownloadURL();
        imagesURL.add(downloadUrl);
      });

      order.add({
        "user_id": uid,
        "order_date": orderDate.text,
        "car_brand": carBrand.text,
        "car_type": carType.text,
        "car_year": carYear.text,
        "car_chassis_number": carChassisNumber.text,
        "item_details": itemDetails.text,
        "item_images": imagesURL,
        "isOpen": true,
        "timestamp": Timestamp.now(),
        "closedBy": [""]
      }).then((value) {
        // execute this function if the future completed successfully
        Get.off(() => CustomerScreen());
      }).catchError((error) {
        // execute this function if the future completed with an error
        print("Error saving order data: $error");
      });
    }
  }

  void uploadImage() async {
    try {
      pickedImages = await imagePicker.pickMultiImage();
      if (pickedImages!.isNotEmpty) {
        for (var element in pickedImages!) {
          file = File(element.path);
          images.add(file);
        }
      } else {
        print('Empty');
      }
    } catch (e) {
      print("Errorrrrrrrrrrrrrrrrrrr: $e");
    }
  }
}
