import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:freemeals/models/order_model.dart';
import 'package:freemeals/models/user_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:flutter/foundation.dart';

class SelectedOrder extends ChangeNotifier {
  String _cafeId;
  String _cafeName;
  String _city;
  String _userId;
  String _userName;

  SelectedOrder() {
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

class OrderProvider extends ChangeNotifier {
  final CollectionReference _orderCol =
      FirebaseFirestore.instance.collection('users');

  final CollectionReference _orderRef =
      FirebaseFirestore.instance.collection('orders');

  StreamController<OrderData> _orderController = StreamController<OrderData>();

  OrderDoc currentOrder;

  List<OrderDoc> _orders = [];

  List<OrderDoc> get orders => [..._orders];

  UserDoc _selectedOrder;

  UserDoc get selectedOrder => _selectedOrder;

  Future<void> getWaitersOrders(String waiterId) async {
    try {
      QuerySnapshot<Map<String, dynamic>> waiterDocs = await _orderRef
          .where("waiterId", isEqualTo: waiterId)
          .where("orderStatus", whereIn: [1, 2]).get();

      if (waiterDocs.size > 0) {
        List<OrderDoc> orders = waiterDocs.docs.map((doc) {
          return OrderDoc.fromDoctoOrderInfo(doc);
        }).toList();

        _orders = orders;
      } else {
        _orders = [];
      }
      notifyListeners();
    } catch (err) {
      print('error waiter provider - get orders = ' + err.toString());
      throw (err);
    }
  }

  Future<String> startNewOrder(String waiterId, int orderId, int tableNumber,
      int numberOfCustomers) async {
    try {
      QuerySnapshot<Map<String, dynamic>> orderDoc = await _orderRef
          .where('orderId', isEqualTo: orderId)
          .where("orderStatus", whereIn: [0])
          .limit(1)
          .get();

      if (orderDoc.docs.isNotEmpty) {
        OrderDoc orderData = OrderDoc.fromDoctoOrderInfo(orderDoc.docs.first);
        _orderRef.doc(orderData.id).update({
          "waiterId": waiterId,
          "orderStatus": 1,
          "tableNumber": tableNumber,
          "numberOfCustomers": numberOfCustomers,
          "waiterAcceptedTime": DateTime.now(),
        });

        return orderData.id;
      }
      notifyListeners();
      return "";
    } catch (err) {
      print('error waiter provider - get orders = ' + err.toString());
      throw (err);
    }
  }

  Future<OrderDoc> getOrder(String orderDocId) async {
    DocumentSnapshot<Map<String, dynamic>> orderDoc =
        await _orderRef.doc(orderDocId).get();

    if (orderDoc.exists) {
      OrderDoc orderData = OrderDoc.fromDoctoOrderInfo(orderDoc);
      currentOrder = orderData;
    }
    notifyListeners();
  }

  Stream<OrderData> getOngoingOrder(String orderDocId) {
    Stream<DocumentSnapshot<Map<String, dynamic>>> stream =
        _orderRef.doc(orderDocId).snapshots();
    stream.listen((DocumentSnapshot<Map<String, dynamic>> snapshots) {
      if (snapshots.exists) {
        _orderController.add(_snapshotOrders(snapshots));
      } else {
        print("Order not found");
      }
    });
    notifyListeners();
    return _orderController.stream;
  }

  OrderDoc _snapshotOrders(DocumentSnapshot<Map<String, dynamic>> snapshot) {
    return OrderDoc.fromDoctoOrderInfo(snapshot);
  }

  void setCafesToEmpty() {
    _orders = [];
    notifyListeners();
  }
}
