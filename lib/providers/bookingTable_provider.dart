import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:freemeals/models/bookeingRequest_model.dart';

import 'package:flutter/foundation.dart';

class BookingRequestProvider extends ChangeNotifier {
  final CollectionReference _waiterCol =
      FirebaseFirestore.instance.collection('cafeterias');

  final CollectionReference _tableBookingCol =
      FirebaseFirestore.instance.collection('tableBookings');

  List<BookingDoc> _bookings = [];

  List<BookingDoc> get bookings => [..._bookings];

  List<BookingDoc> _customerBookings = [];

  List<BookingDoc> get customerBookings => [..._customerBookings];

  Future<void> getBookingRequests(String cafeId) async {
    try {
      QuerySnapshot<Map<String, dynamic>> requestDocs =
          await _tableBookingCol.where("cafeteriaId", isEqualTo: cafeId).get();

      List<BookingDoc> requests = requestDocs.docs.map((doc) {
        return BookingDoc.fromDoctoBookingInfo(doc);
      }).toList();

      _bookings = requests;
      notifyListeners();
    } catch (err) {
      print('error waiter provider - get Waiters = ' + err.toString());
      throw (err);
    }
  }

  Future<void> getUserBookings(String userId) async {
    try {
      QuerySnapshot<Map<String, dynamic>> requestDocs =
          await _tableBookingCol.where("customerId", isEqualTo: userId).get();

      List<BookingDoc> requests = requestDocs.docs.map((doc) {
        return BookingDoc.fromDoctoBookingInfo(doc);
      }).toList();

      _customerBookings = requests;
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
    _bookings = [];
    notifyListeners();
  }
}
