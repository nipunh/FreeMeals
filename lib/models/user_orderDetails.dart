import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:freemeals/models/cart_model.dart';

class UserOrderDetail {
  String displayName;
  List<dynamic> items;
  DateTime lastUpdated;
  double itemsTotal;
  String userId;
  int status;

  UserOrderDetail(
      {@required this.displayName,
      @required this.items,
      @required this.lastUpdated,
      @required this.itemsTotal,
      @required this.userId,
      @required this.status});
}

class UserOrderDetails {
  List<UserOrderDetail> totalMealOptions;

  UserOrderDetails({@required this.totalMealOptions});

  static UserOrderDetails fromDocToVendor(
      DocumentSnapshot<Map<String, dynamic>> doc) {
    Map<String, dynamic> data = doc.data();
    List<UserOrderDetail> listMealDeatils = [];
    if (data['userList'] != null && data['userList'].isNotEmpty)
      data['userList'].forEach((element) {
        listMealDeatils.add(UserOrderDetail(
            displayName: element['displayName'],
            items: element['items'],
            lastUpdated: element['lastUpdated'],
            itemsTotal: element['itemsTotal'],
            userId: element['userId'],
            status: element['status']));
      });

    return UserOrderDetails(totalMealOptions: listMealDeatils);
  }
}

class MealItem {
  List<UserOrderDetail> subMenu;
  String itemId;
  String itemName;
  int rating;

  MealItem(
      {@required this.itemId,
      @required this.itemName,
      @required this.rating,
      @required this.subMenu});
}
