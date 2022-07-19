import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:freemeals/models/user_orderDetails.dart';

class OrderData {}

class OrderDoc implements OrderData {
  String id;
  String userId;
  String displayName;
  int tableNumber;
  int numberOfCustomers;
  DateTime waiterRequestTime;
  DateTime waiterAcceptedTime;
  List<UserOrderDetail> userList;
  int orderStatus;
  int orderId;
  String cafeId;
  String waiterId;

  OrderDoc(
      {@required this.id,
      this.userId,
      this.displayName,
      this.tableNumber,
      this.numberOfCustomers,
      this.waiterRequestTime,
      this.waiterAcceptedTime,
      this.userList,
      @required this.orderStatus,
      @required this.orderId,
      @required this.cafeId,
      this.waiterId});

  static OrderDoc fromDoctoOrderInfo(
      DocumentSnapshot<Map<String, dynamic>> snapshot) {
    final data = snapshot.data();
    return OrderDoc(
      id: snapshot.id,
      userId: data['userId'] ?? '',
      displayName: data['displayName'] ?? '',
      tableNumber: data['tableNumber'] ?? '',
      numberOfCustomers: data['numberOfCustomers'] ?? "",
      waiterRequestTime: data['waiterRequestTime'] != null
          ? data['waiterRequestTime'].toDate().toLocal()
          : null,
      waiterAcceptedTime: data['waiterAcceptedTime'] != null
          ? data['waiterAcceptedTime'].toDate().toLocal()
          : null,
      userList:
          (data['userList'] == null || data['userList'].toList().length == 0)
              ? List<dynamic>.empty()
              : List<UserOrderDetail>.from(
                  data['userList'].map((item) {
                    return UserOrderDetail(
                        displayName: item['displayName'],
                        items: item['items'],
                        lastUpdated: item['lastUpdated'].toDate(),
                        itemsTotal: item['itemsTotal'],
                        status: item["status"] ?? 0,
                        userId: item["userId"]);
                  }).toList(),
                ),
      orderStatus: data['orderStatus'] ?? 0,
      orderId: data['orderId'] ?? 0,
      cafeId: data['cafeId'] ?? "",
      waiterId: data['waiterId'] ?? "",
    );
  }
}

class OrderRequests implements OrderData {
  List<OrderDoc> orderLists;

  OrderRequests(this.orderLists);
}

class Error1 implements OrderData {
  String errorMsg;
  Error1(this.errorMsg);
}

class Loading1 implements OrderData {
  const Loading1();
}
