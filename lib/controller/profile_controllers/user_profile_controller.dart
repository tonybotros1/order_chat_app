import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
// import 'package:image_cropper/image_cropper.dart';
import 'package:orders_chat_app/models/user_details_model.dart';
import 'package:image_picker/image_picker.dart';

import '../../screens/profile_screen/user_profile_screen2.dart';

class UserProfileController extends GetxController {
  final name = TextEditingController();
  final location = TextEditingController();

  RxList<UserDetailsModel> userDetails = RxList<UserDetailsModel>([]);

  // RxString profilePicture = RxString('');
  RxString currentUserId = RxString('');
  RxString currentUserDocId = RxString('');
  final imagePicker = ImagePicker();

  @override
  void onInit() {
    getCurrentUserId();
    userDetails.bindStream(getUserDetails().asBroadcastStream());

    super.onInit();
  }

//================================================================
  void pickImageFromGallery() async {
    try {
      final pickedImage = await ImagePicker().pickImage(
        source: ImageSource.gallery,
      );
      if (pickedImage != null) {
         File? file = File(pickedImage.path);
        // file =await cropImage(imageFile:file );
        final Reference ref = FirebaseStorage.instance
            .ref()
            .child('user_images')
            .child('${DateTime.now().millisecondsSinceEpoch}.jpg');
        final uploadTask = ref.putFile(file);
        await uploadTask.whenComplete(() async {
          final downloadUrl = await ref.getDownloadURL();
          updateDetails('profile_picture', downloadUrl);
        });
      } else {
        print('No image picked.');
      }
    } catch (e) {
      print('Error: $e');
    }
  }
//================================================================

  // Future<File?> cropImage({required File imageFile}) async {
  //   CroppedFile? croppedImage =
  //       await ImageCropper().cropImage(sourcePath: imageFile.path);
  //   if (croppedImage == null) return null;
  //   return File(croppedImage.path);
  // }

//================================================================
  void updateDetails(fieldName, controllerText) {
    print(fieldName);
    print(controllerText);
    CollectionReference update =
        FirebaseFirestore.instance.collection('user_roles');
    update.doc(currentUserDocId.value).update({fieldName: controllerText});
  }
//=============================================================

  void getCurrentUserId() {
    FirebaseAuth auth = FirebaseAuth.instance;
    final user = auth.currentUser;
    if (user != null && user.uid.isNotEmpty) {
      currentUserId.value = user.uid;
    }
  }

//================================================================
  Stream<List<UserDetailsModel>> getUserDetails() {
    final user_details = FirebaseFirestore.instance
        .collection('user_roles')
        .where('user_id', isEqualTo: currentUserId.value)
        .snapshots();
    user_details.listen((querySnapshot) {
      querySnapshot.docs.forEach((doc) {
        currentUserDocId.value = doc.id;
      });
    });

    return user_details.map((event) => event.docs
        .map((e) => UserDetailsModel(
              location: e.data()['location'],
              name: e.data()['name'],
              phoneNumber: e.data()['phone_number'],
              profilePicture: e.data()['profile_picture'],
              user_id: e.data()['user_id'],
            ))
        .toList());
  }
//=========================================================
}
