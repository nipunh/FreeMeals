import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:freemeals/models/order_model.dart';
import 'package:freemeals/models/user_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';

class WaiterProvider extends ChangeNotifier {
  final CollectionReference _waiterCol =
      FirebaseFirestore.instance.collection('users');

  final CollectionReference _cafeteriaRef =
      FirebaseFirestore.instance.collection('cafeterias');

  List<UserDoc> _waiters = [];

  List<dynamic> _banners = [];

  List<OrderRequests> _orders = [];

  List<UserDoc> get waiters => [..._waiters];

  List<OrderRequests> get orders => [..._orders];

  List<String> get banners => [..._banners];

  
  Future<void> getWaiters(String cafeId) async {
    try {
      QuerySnapshot<Map<String, dynamic>> waiterDocs = await _waiterCol
          .where("userType", isEqualTo: 0)
          .where("cafeId", isEqualTo: cafeId)
          .where("status", whereIn: [0, 1])
          .get();

      List<UserDoc> waiters = waiterDocs.docs.map((doc) {
        return UserDoc.fromDoctoUserInfo(doc);
      }).toList();
      // print(waiters);
      _waiters = waiters;
      notifyListeners();
    } catch (err) {
      print('error waiter provider - get Waiters = ' + err.toString());
      throw (err);
    }
  }

  Future<void> getOfferBanners(String cafeId) async {
    try {
      DocumentSnapshot<dynamic> cafeDoc = await _cafeteriaRef.doc(cafeId).get();
      if (cafeDoc.exists) {
        List<dynamic> data = cafeDoc.data()["offerBanners"];
        _banners = data;
      } else {
        _banners = [];
      }
      notifyListeners();
    } catch (err) {
      print('error waiter provider - get Waiters = ' + err.toString());
      throw (err);
    }
  }

  //   Future<void> getSelectedWaiter(String selectedWaiterId) async {
  //   try {
  //     _selectedWaiter = null;
  //     if (selectedWaiterId == null || selectedWaiterId.isEmpty) {
  //     } else {
  //       DocumentSnapshot<Map<String, dynamic>> userDoc =
  //           await _waiterCol.doc(selectedWaiterId).get();

  //       UserDoc selectedWaiter = UserDoc.fromDoctoUserInfo(userDoc);
  //       _selectedWaiter = selectedWaiter;
  //     }
  //     notifyListeners();
  //   } catch (err) {
  //     print(
  //         'error cafeteria provider - get selected cafes and add to provider = ' +
  //             err.toString());
  //     throw (err);
  //   }
  // }

  // Future<void> getWaitersOrders(String waiterId) async {
  //   try {
  //     QuerySnapshot<Map<String, dynamic>> waiterDocs = await _waiterCol
  //         .doc(waiterId)
  //         .collection("orders")
  //         .where("orderStatus", isEqualTo: 0)
  //         .get();

  //       print(waiterDocs.docs.first.data());
  //     List<OrderDoc> orders = waiterDocs.docs.map((doc) {
  //       return OrderDoc.fromDoctoOrderInfo(doc);
  //     }).toList();

  //     _orders = orders;

  //     notifyListeners();
  //   } catch (err) {
  //     print('error waiter provider - get orders = ' +
  //         err.toString());
  //     throw (err);
  //   }
  // }

  void setCafesToEmpty() {
    _waiters = [];
    notifyListeners();
  }
}
