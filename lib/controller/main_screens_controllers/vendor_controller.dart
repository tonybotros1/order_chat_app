import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:orders_chat_app/models/user_details_model.dart';

import '../../models/order_model.dart';
import '../../screens/orders_screen/vendor_order_informations_screen2.dart';

class VendorController extends GetxController {
//=====================================================================
  final OrderRepository _orderRepository = OrderRepository();
  final RxList<OrderModel> _orders = RxList<OrderModel>([]);
  final RxList<UserDetailsModel> _users = RxList<UserDetailsModel>([]);
//=====================================================================

  final RxBool isLoading = RxBool(true);

  @override
  void onInit() {
    // _fetchOrders();
    _orders.bindStream(_orderRepository.getOrders().asBroadcastStream());
    _users.bindStream(_orderRepository.getUsers().asBroadcastStream());

    ever(_users, (_) => update());
    super.onInit();
  }

// ==========================================================
 

//============================================================
  Future fetchDate() async {
    await Future.delayed(
      const Duration(seconds: 1),
    );
    _orders.bindStream(_orderRepository.getOrders().asBroadcastStream());
    _users.bindStream(_orderRepository.getUsers().asBroadcastStream());
    ordersWithUsers;
  }

//============================================================
  List<OrderModel> get ordersWithUsers {
    return _orders.map((order) {
      final user = _users.firstWhere((user) => user.user_id == order.userId,
          orElse: () => UserDetailsModel(user_id: '', name: ''));
      return OrderModel(
        carBrand: order.carBrand,
        carChassisNumber: order.carChassisNumber,
        carType: order.carType,
        carYear: order.carYear,
        itemDetails: order.itemDetails,
        itemImages: order.itemImages,
        orderDate: order.orderDate,
        orderId: order.orderId,
        userId: order.userId,
        // add user to order object
        user: user,
      );
    }).toList();
  }

//============================================================

  void openOrderDetails(
      orderId,
      carBrand,
      carChassisNumber,
      carType,
      carYear,
      itemDetails,
      itemImages,
      orderDate,
      userId,
      userName,
      profilePicture,
      phoneNumber) {
    const slideTransition = Transition.leftToRightWithFade;

    Get.to(() => const VendorOrderScreenInformations(),
        arguments: OrderModel(
            orderId: orderId,
            carBrand: carBrand,
            carChassisNumber: carChassisNumber,
            carType: carType,
            carYear: carYear,
            itemDetails: itemDetails,
            itemImages: itemImages,
            orderDate: orderDate,
            userId: userId,
            userName: userName,
            profilePicture: profilePicture,
            phoneNumber: phoneNumber),
        transition: slideTransition);
  }
}
//============================================================

class OrderRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Future<List<OrderModel>> getOrders() async {
  //   FirebaseAuth auth = FirebaseAuth.instance;
  //   final user = auth.currentUser;
  //   final uid = user!.uid;

  //   final ordersSnapshot = await _firestore
  //       .collection('orders')
  //       .where('isOpen', isEqualTo: true)
  //       .get();

  //   return ordersSnapshot.docs
  //       .map((doc) => OrderModel(
  //           orderId: doc.id,
  //           carBrand: doc.data()['car_brand'],
  //           carChassisNumber: doc.data()['car_chassis_number'],
  //           carType: doc.data()['car_type'],
  //           carYear: doc.data()['car_year'],
  //           itemDetails: doc.data()['item_details'],
  //           itemImages: doc.data()['item_images'],
  //           orderDate: doc.data()['order_date'],
  //           userId: doc.data()['user_id']))
  //       .toList();
  // }

  Stream<List<OrderModel>> getOrders() {
    FirebaseAuth auth = FirebaseAuth.instance;
    final user = auth.currentUser;
    final uid = user!.uid;

    final ordersSnapshot = _firestore
        .collection('orders')
        .where('isOpen', isEqualTo: true)
        .where('closedBy', isNotEqualTo: uid)
        .snapshots();

    return ordersSnapshot.map((event) => event.docs
        .map((doc) => OrderModel(
            orderId: doc.id,
            carBrand: doc.data()['car_brand'],
            carChassisNumber: doc.data()['car_chassis_number'],
            carType: doc.data()['car_type'],
            carYear: doc.data()['car_year'],
            itemDetails: doc.data()['item_details'],
            itemImages: doc.data()['item_images'],
            orderDate: doc.data()['order_date'],
            userId: doc.data()['user_id']))
        .toList());
  }
  //============================================================

  //============================================================

  // Future<List<UserDetailsModel>> getUsers() async {
  //   final usersSnapshot = await _firestore.collection('user_roles').get();
  //   return usersSnapshot.docs
  //       .map((doc) => UserDetailsModel(
  //             location: doc.data()['location'],
  //             name: doc.data()['name'],
  //             phoneNumber: doc.data()['phone_number'],
  //             profilePicture: doc.data()['profile_picture'],
  //             user_id: doc.data()['user_id'],
  //             // userRole: doc.data()['user_role'],
  //             userToken: doc.data()['user_token'],
  //           ))
  //       .toList();
  // }
  Stream<List<UserDetailsModel>> getUsers() {
    final usersSnapshot = _firestore.collection('user_roles').snapshots();
    return usersSnapshot.map((event) => event.docs
        .map((doc) => UserDetailsModel(
              location: doc.data()['location'],
              name: doc.data()['name'],
              phoneNumber: doc.data()['phone_number'],
              profilePicture: doc.data()['profile_picture'],
              user_id: doc.data()['user_id'],
              // userRole: doc.data()['user_role'],
              userToken: doc.data()['user_token'],
            ))
        .toList());
  }
}
