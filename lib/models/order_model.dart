import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class OrderData {}

class OrderDoc implements OrderData {
  String id;
  String userId;
  String displayName;
  int tableNumber;
  int numberOfCustomers;
  DateTime waiterRequestTime;
  DateTime waiterAcceptedTime;
  Map<String, dynamic> userList;
  int orderStatus;

  OrderDoc({
    @required this.id,
    this.userId,
    this.displayName,
    this.tableNumber,
    this.numberOfCustomers,
    this.waiterRequestTime,
    this.waiterAcceptedTime,
    this.userList,
    @required this.orderStatus
  });

  static OrderDoc fromDoctoOrderInfo(
    DocumentSnapshot<Map<String, dynamic>> snapshot) {
    final data = snapshot.data();

    return OrderDoc(
      id: snapshot.id,
      userId: data['userId'] ?? '',
      displayName: data['displayName'] ?? '',
      tableNumber: data['tableNumber'] ?? '',
      numberOfCustomers: data['numberOfCustomers'] ?? "",
      waiterRequestTime : data['waiterRequestTime'] != null ? data['waiterRequestTime'].toDate().toLocal() : null,
      waiterAcceptedTime: data['waiterAcceptedTime'] != null ? data['waiterAcceptedTime'].toDate().toLocal() : null,
      // userList : data['userList']  ?? [],
      orderStatus : data['orderStatus'] ?? 0,
    );
  }
}

class Error1 implements OrderData {
  String errorMsg;
  Error1(this.errorMsg);
}

class Loading1 implements OrderData {
  const Loading1();
}
