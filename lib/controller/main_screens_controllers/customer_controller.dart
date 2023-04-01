import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:get/get.dart';
import 'package:orders_chat_app/models/order_model.dart';

import '../../screens/orders_screen/customer_order_informations_screen.dart';
import '../../screens/orders_screen/order_informations_screen.dart';
import '../../screens/orders_screen/vendor_order_informations_screen2.dart';

class CustomerController extends GetxController {
  RxBool isLoading = RxBool(true);
  RxString userName = RxString('');
  RxString phoneNumber = RxString('');

  RxString profilePicture = RxString('');
  final RxList<DocumentSnapshot> orders = RxList<DocumentSnapshot>([]);

    RxBool isOpen = RxBool(true); // for the customer


  @override
  void onInit() {
    getOrders();
    super.onInit();
  }
// =============================================================
   void getOrderStatusForCustomer(orderId) {
    // this function is for the customer
    // if it's open or close

    FirebaseFirestore.instance
        .collection('orders')
        .doc(orderId)
        .snapshots()
        .listen((event) {
      isOpen.value = event.data()!['isOpen']; // for customer
    });
  }
// ==============================================================
  Future<void> fetchData() async {
    return await Future.delayed(
      const Duration(seconds: 1),
      getOrders
    );
  }

  void getOrders() {
    try {
      FirebaseAuth auth = FirebaseAuth.instance;
      User? user = auth.currentUser;
      if (user != null && user.uid.isNotEmpty) {
        String uid = user.uid;
        FirebaseFirestore.instance
            .collection('orders')
            .where('user_id', isEqualTo: uid)
            .orderBy('isOpen', descending: true)
            .orderBy('timestamp', descending: true)
            .snapshots()
            .listen((event) {
          orders.assignAll(event.docs);
        });

        FirebaseFirestore.instance
            .collection('user_roles')
            .where('user_id', isEqualTo: uid)
            .snapshots()
            .listen((event) {
          event.docs.map((e) {
            userName.value = e.data()['name'];
            phoneNumber.value = e.data()['phone_number'];
            profilePicture.value = e.data()['profile_picture'];
          }).toList();
        });
      }
    } catch (e) {
      print("Error: $e");
    } finally {
      isLoading.value = false;
    }
  }

  void goToOrderinformationsScreen(order) {
    Get.to(() => const CustomerOrderScreenInformations(),
        arguments: OrderModel(
          carBrand: order['car_brand'],
          carChassisNumber: order['car_chassis_number'],
          carType: order['car_type'],
          carYear: order['car_year'],
          itemDetails: order['item_details'],
          itemImages: order['item_images'],
          orderDate: order['order_date'],
          orderId: order.id,
          userId: order['user_id'],
          isOpen: order['isOpen'],
        ),
        transition: Transition.leftToRightWithFade);
  }
}
