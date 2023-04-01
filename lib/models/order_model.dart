import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:orders_chat_app/models/user_details_model.dart';

class OrderModel {
  bool? isOpen;
  Timestamp? timestamp;
  String? orderDate;
  String? carYear;
  String? userId;
  String? itemDetails;
  String? carBrand;
  List<dynamic>? itemImages;
  String? carChassisNumber;
  String? carType;
  String? orderId;
  String? userName;
  String? phoneNumber;
  String? profilePicture;
  UserDetailsModel? user;
  List<dynamic>? closedBy;

  OrderModel({
    this.orderDate,
    this.carYear,
    this.userId,
    this.itemDetails,
    this.carBrand,
    this.itemImages,
    this.carChassisNumber,
    this.carType,
    this.orderId,
    this.userName,
    this.phoneNumber,
    this.profilePicture,
    this.isOpen,
    this.timestamp,
    this.user,
    this.closedBy,
  });

  OrderModel.fromJson(Map<String, dynamic> json) {
    orderDate = json['order_date'];
    carYear = json['car_year'];
    userId = json['user_id'];
    itemDetails = json['item_details'];
    carBrand = json['car_brand'];
    if (json['item_images'] != null || json['item_images'] != []) {
      itemImages = json['item_images'].cast<String>();
    } else {
      itemImages = [];
    }
    carChassisNumber = json['car_chassis_number'];
    carType = json['car_type'];
    // if (json['order_image'] != null) {
    //   itemImages = <OrderImage>[];
    //   json['order_image'].forEach((v) {
    //     itemImages!.add(new OrderImage.fromJson(v));
    //   });
    // }
    orderId = json['order_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['order_date'] = this.orderDate;
    data['car_year'] = this.carYear;
    data['user_id'] = this.userId;
    data['item_details'] = this.itemDetails;
    data['car_brand'] = this.carBrand;
    data['item_images'] = this.itemImages;
    data['car_chassis_number'] = this.carChassisNumber;
    data['car_type'] = this.carType;
    data['order_id'] = this.orderId;
    return data;
  }
}


// class OrderImage {
//   int? id;
//   int? orderId;
//   String? orderImage;

//   OrderImage(
//       {this.id, this.orderId, this.orderImage,});

//   OrderImage.fromJson(Map<String, dynamic> json) {
//     id = json['id'];
//     orderId = json['order_id'];
//     orderImage = json['order_image'];
//   }

//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['id'] = this.id;
//     data['order_id'] = this.orderId;
//     data['order_image'] = this.orderImage;
//     return data;
//   }
// }
