import 'package:freemeals/config/data_json.dart';
import 'package:freemeals/models/cart_model.dart';
import 'package:freemeals/models/order_model.dart';
import 'package:freemeals/models/user_model.dart';
import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:freemeals/models/user_orderDetails.dart';

class OrderService {
  final _auth = FirebaseAuth.instance;
  final _user = FirebaseFirestore.instance.collection('users');
  final _orderRef = FirebaseFirestore.instance.collection('orders');
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // get all cart items for cart screen
  Stream<OrderData> getCartItems(String userId) {
    Stream<QuerySnapshot<Map<String, dynamic>>> stream = _user
        .doc(userId)
        .collection("orders")
        .where('status', isEqualTo: 0)
        .snapshots();

    return stream.map(_snapshotCarts);
  }

  Stream<OrderDoc> getOngoingOrder(String orderDocId) {
    // print(orderDocId);
    Stream<DocumentSnapshot<Map<String, dynamic>>> stream =
        _orderRef.doc(orderDocId).snapshots();
    return stream.map(_snapshotOrders);
  }

  OrderDoc _snapshotOrders(DocumentSnapshot<Map<String, dynamic>> snapshot) {
    return OrderDoc.fromDoctoOrderInfo(snapshot);
  }

  OrderRequests _snapshotCarts(QuerySnapshot<Map<String, dynamic>> snapshot) {
    final List<OrderDoc> orderDoc = snapshot.docs.map((doc) {
      return OrderDoc.fromDoctoOrderInfo(doc);
    }).toList();

    // print(orderDoc);
    return OrderRequests(orderDoc);
  }

  Future<void> acceptRejectUserToOrder(
      String userId, String orderId, int status) async {
    try {
      DocumentSnapshot<Map<String, dynamic>> orderDoc =
          await _orderRef.doc(orderId).get();

      if (orderDoc.exists) {
        OrderDoc orderData = OrderDoc.fromDoctoOrderInfo(orderDoc);

        List<UserOrderDetail> userList = orderData.userList;

        UserOrderDetail userToUpdate =
            userList.firstWhere((element) => element.userId == userId);

        await _orderRef.doc(orderId).update({
          "userList": FieldValue.arrayRemove([
            {
              "userId": userToUpdate.userId,
              "displayName": userToUpdate.displayName,
              "items": userToUpdate.items,
              "itemsTotal": userToUpdate.itemsTotal,
              "status": userToUpdate.status,
              "lastUpdated": userToUpdate.lastUpdated
            }
          ]),
        });

        await _orderRef.doc(orderId).update({
          "userList": FieldValue.arrayUnion([
            {
              "userId": userToUpdate.userId,
              "displayName": userToUpdate.displayName,
              "items": userToUpdate.items,
              "itemsTotal": userToUpdate.itemsTotal,
              "status": status,
              "lastUpdated": DateTime.now()
            }
          ]),
        });
      }
    } catch (err) {
      print(err);
    }
  }

  Future<bool> orderItemRequest(
      String orderDocId, Cart cart, String userId) async {
    try {
      var batch = _db.batch();
      DocumentSnapshot<Map<String, dynamic>> orderDoc =
          await _orderRef.doc(orderDocId).get();
      if (orderDoc.exists) {
        OrderDoc orderdetails = OrderDoc.fromDoctoOrderInfo(orderDoc);
        List<UserOrderDetail> userList = orderdetails.userList;

        var itemsList = cart.items.values
            .map((e) => {
                  "id": e.id,
                  "price": e.price,
                  "quantity": e.quantity,
                  "title": e.title,
                  "status": 0
                })
            .toList();

        print(itemsList.first);

        UserOrderDetail userToUpdate =
            userList.firstWhere((element) => element.userId == userId);

        if (userToUpdate != null) {
          batch.update(
              FirebaseFirestore.instance.collection('orders').doc(orderDocId), {
            "userList": FieldValue.arrayRemove([
              {
                "userId": userToUpdate.userId,
                "displayName": userToUpdate.displayName,
                "items": userToUpdate.items,
                "itemsTotal": userToUpdate.itemsTotal.toDouble(),
                "status": userToUpdate.status,
                "lastUpdated": userToUpdate.lastUpdated
              }
            ]),
          });

          batch.update(
            FirebaseFirestore.instance.collection('orders').doc(orderDocId),
            {
              "userList": FieldValue.arrayUnion([
                {
                  "userId": userToUpdate.userId,
                  "displayName": userToUpdate.displayName,
                  "items": [...itemsList, ...userToUpdate.items],
                  "itemsTotal": userToUpdate.itemsTotal.toDouble() +
                      cart.totalAmount.toDouble(),
                  "status": userToUpdate.status,
                  "lastUpdated": DateTime.now()
                }
              ]),
            },
          );

          await batch.commit();
          return Future.value(true);
        } else {
          // print("User null");
          return Future.value(false);
        }
      }
    } catch (err) {
      print(
          'error cart provider - get cart from localdb and add to provider = ' +
              err.toString());
      throw (err);
    }
  }

  // Future<void> acceptRejectUserToOrder(
  //     String userId, String orderId, int status) async {
  //   try {
  //     DocumentSnapshot<Map<String, dynamic>> orderDoc =
  //         await _orderRef.doc(orderId).get();

  //     if (orderDoc.exists) {
  //       OrderDoc orderData = OrderDoc.fromDoctoOrderInfo(orderDoc);

  //       List<UserOrderDetail> userList = orderData.userList;

  //       UserOrderDetail userToUpdate =
  //           userList.firstWhere((element) => element.userId == userId);

  //       await _orderRef.doc(orderId).update({
  //         "userList": FieldValue.arrayRemove([
  //           {
  //             "userId": userToUpdate.userId,
  //             "displayName": userToUpdate.displayName,
  //             "items": userToUpdate.items,
  //             "itemsTotal": userToUpdate.itemsTotal,
  //             "status": userToUpdate.status,
  //             "lastUpdated": userToUpdate.lastUpdated
  //           }
  //         ]),
  //       });

  //       await _orderRef.doc(orderId).update({
  //         "userList": FieldValue.arrayUnion([
  //           {
  //             "userId": userToUpdate.userId,
  //             "displayName": userToUpdate.displayName,
  //             "items": userToUpdate.items,
  //             "itemsTotal": userToUpdate.itemsTotal,
  //             "status": status,
  //             "lastUpdated": DateTime.now()
  //           }
  //         ]),
  //       });
  //     }
  //   } catch (err) {
  //     print(err);
  //   }
  // }

  Future<void> orderItemStatusUpdate(
      String orderDocId, String userId, String productId, String status) async {
    try {
      var batch = _db.batch();
      DocumentSnapshot<Map<String, dynamic>> orderDoc =
          await _orderRef.doc(orderDocId).get();
      if (orderDoc.exists) {
        OrderDoc orderdetails = OrderDoc.fromDoctoOrderInfo(orderDoc);
        List<UserOrderDetail> userList = orderdetails.userList;

        UserOrderDetail userToUpdate =
            userList.firstWhere((element) => element.userId == userId);

        if (userToUpdate != null) {
          batch.update(
              FirebaseFirestore.instance.collection('orders').doc(orderDocId), {
            "userList": FieldValue.arrayRemove([
              {
                "userId": userToUpdate.userId,
                "displayName": userToUpdate.displayName,
                "items": userToUpdate.items,
                "itemsTotal": userToUpdate.itemsTotal.toDouble(),
                "status": userToUpdate.status,
                "lastUpdated": userToUpdate.lastUpdated
              }
            ]),
          });

          int productIndex = userToUpdate.items
              .indexWhere((element) => element["id"] == productId);

          if (status == "next") {
            if (userToUpdate.items[productIndex]["status"] >= 0 ||
                userToUpdate.items[productIndex]["status"] < 3) {
              userToUpdate.items[productIndex]["status"] += 1;
            }
          }

          if (status == "prev") {
            if (status == "next") {
              if (userToUpdate.items[productIndex]["status"] == 0) {
                userToUpdate.items[productIndex]["status"] -= 1;
              }
            }
          }

          print(userToUpdate.items[productIndex]["status"]);

          batch.update(
            FirebaseFirestore.instance.collection('orders').doc(orderDocId),
            {
              "userList": FieldValue.arrayUnion([
                {
                  "userId": userToUpdate.userId,
                  "displayName": userToUpdate.displayName,
                  "items": userToUpdate.items,
                  "itemsTotal": userToUpdate.itemsTotal.toDouble(),
                  "status": userToUpdate.status,
                  "lastUpdated": DateTime.now()
                }
              ]),
            },
          );

          await batch.commit();
        } else {
          print("User null");
        }
      }
    } catch (err) {
      print(
          'error cart provider - get cart from localdb and add to provider = ' +
              err.toString());
      throw (err);
    }
  }
}
