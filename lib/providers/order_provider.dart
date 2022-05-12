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
  final CollectionReference _orderCol = FirebaseFirestore.instance.collection('users');

  List<OrderDoc> _orders = [];

  List<OrderDoc> get orders => [..._orders];

  UserDoc _selectedOrder;

  UserDoc get selectedOrder => _selectedOrder;


  Future<void> getWaitersOrders(String waiterId) async {
    try {
      QuerySnapshot<Map<String, dynamic>> waiterDocs = await 
      _orderCol
          .doc(waiterId)
          .collection("orders")
          .where("orderStatus", whereIn: [0, 1])
          .get();


      if(waiterDocs.size > 0){
        List<OrderDoc> orders = waiterDocs.docs.map((doc) {
        return OrderDoc.fromDoctoOrderInfo(doc);
      }).toList();

      _orders = orders;
      }else{
        _orders = [];

      }
      notifyListeners();
    } catch (err) {
      print('error waiter provider - get orders = ' +
          err.toString());
      throw (err);
    }
  }

  void setCafesToEmpty() {
    _orders = [];
    notifyListeners();
  }
}
