import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:freemeals/models/bookeingRequest_model.dart';
import 'package:freemeals/models/order_model.dart';
import 'package:freemeals/models/user_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:flutter/foundation.dart';

class SelectedWaiter extends ChangeNotifier {
  String _cafeId;
  String _cafeName;
  String _city;
  String _userId;
  String _userName;

  SelectedWaiter() {
    _cafeId;
    _cafeName;
    _city;
    _userId;
    _userName;
    try {
      loadPreferences();
    } catch (err) {
      throw Exception(err);
    }
  }
  String get cafeId {
    if (_cafeId != null)
      return _cafeId;
    else {
      loadPreferences();
      return _cafeId;
    }
  }

  String get cafeName {
    if (_cafeName != null)
      return _cafeName;
    else {
      loadPreferences();
      return _cafeName;
    }
  }

  String get city {
    if (_city != null)
      return _city;
    else {
      loadPreferences();
      return _city;
    }
  }

  String get userId {
    if (_userId != null)
      return _userId;
    else {
      loadPreferences();
      return _userId;
    }
  }

  String get userName {
    if (_userName != null)
      return _userName;
    else {
      loadPreferences();
      return _userName;
    }
  }

  Future<void> setWaiter(String cafeteriaId, String cafeteriaName,
      String cafeCity, String userId, String userName) async {
    try {
      _cafeId = cafeteriaId;
      _cafeName = cafeteriaName;
      _city = cafeCity;
      _userId = userId;
      _userName = userName;
      notifyListeners();
      return await savePreferences();
    } catch (err) {
      throw Exception(err);
    }
  }

  Future<void> savePreferences() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString('id', _cafeId);
      prefs.setString('name', _cafeName);
      prefs.setString('city', _city);
      prefs.setString('userId', _userId);
      prefs.setString('userName', _userName);
      return;
    } catch (err) {
      print('savePreference Cafe error = $err');
      throw Exception(err);
    }
  }

  Future<void> loadPreferences() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String cafeId = prefs.getString('id');
      String cafeName = prefs.getString('name');
      String city = prefs.getString('city');
      String userId = prefs.getString('userId');
      String userName = prefs.getString('userName');
      if (cafeId != null && cafeName != null && city != null)
        setWaiter(cafeId, cafeName, city, userId, userName);
    } catch (err) {
      print('loadPreference Cafe error = $err');
      throw Exception(err);
    }
  }
}

class BookingRequestProvider extends ChangeNotifier {
  final CollectionReference _waiterCol =
      FirebaseFirestore.instance.collection('cafeterias');

  final CollectionReference _tableBookingCol =
      FirebaseFirestore.instance.collection('tableBookings');

  List<BookingDoc> _bookings = [];

  List<BookingDoc> get bookings => [..._bookings];

  List<BookingDoc> _customerBookings = [];

  List<BookingDoc> get customerBookings => [..._customerBookings];

  UserDoc _selectedWaiter;

  UserDoc get selectedWaiter => _selectedWaiter;

  Future<void> getSelectedWaiter(String selectedWaiterId) async {
    try {
      _selectedWaiter = null;
      if (selectedWaiterId == null || selectedWaiterId.isEmpty) {
      } else {
        DocumentSnapshot<Map<String, dynamic>> userDoc =
            await _waiterCol.doc(selectedWaiterId).get();

        UserDoc selectedWaiter = UserDoc.fromDoctoUserInfo(userDoc);
        _selectedWaiter = selectedWaiter;
      }
      notifyListeners();
    } catch (err) {
      print(
          'error cafeteria provider - get selected cafes and add to provider = ' +
              err.toString());
      throw (err);
    }
  }

  Future<void> getBookingRequests(String cafeId) async {
    try {
      QuerySnapshot<Map<String, dynamic>> requestDocs = await _tableBookingCol
          .where("cafeteriaId", isEqualTo: cafeId)
          .get();

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
      QuerySnapshot<Map<String, dynamic>> requestDocs = await _tableBookingCol
          .where("customerId", isEqualTo: userId)
          .get();

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
