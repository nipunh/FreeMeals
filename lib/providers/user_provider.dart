import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:freemeals/models/user_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:flutter/foundation.dart';

class SelectedUser extends ChangeNotifier {
  String _userId;
  String _userName;
  int _userType;

  SelectedUser() {
    _userId = '';
    _userName = '';
    _userType = 1;
    try {
      loadPreferences();
    } catch (err) {
      throw Exception(err);
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

  int get userType {
    if (_userType != null)
      return _userType;
    else {
      loadPreferences();
      return _userType;
    }
  }

  Future<void> loadPreferences() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String userId = prefs.getString('cafeId');
      String userName = prefs.getString('cafeName');
      int userType = prefs.getInt('userType');
      if (userId != null && userName != null && userType != null)
        setUser(userId, userName, userType);
    } catch (err) {
      print('loadPreference Cafe error = $err');
      throw Exception(err);
    }
  }

  Future<void> setUser(String userId, String userName, int userType) async {
    try {
      _userId = userId;
      _userName = userName;
      _userType = userType;
      notifyListeners();
      return await savePreferences();
    } catch (err) {
      throw Exception(err);
    }
  }

  Future<void> savePreferences() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString('userId', _userId);
      prefs.setString('userName', _userName);
      prefs.setInt("userType", _userType);
      return;
    } catch (err) {
      print('savePreference Cafe error = $err');
      throw Exception(err);
    }
  }
}

class UserProvider extends ChangeNotifier {
  final CollectionReference _userRef =
      FirebaseFirestore.instance.collection('users');

  List<UserDoc> _user = [];

  List<UserDoc> get user => [..._user];

  UserDoc _selectedUser;

  UserDoc get selectedUser => _selectedUser;  

  Future<void> getUser(String userId) async {
    try {
      DocumentSnapshot<Map<String, dynamic>> userDoc =
          await _userRef.doc(userId).get();
      if (userDoc.exists) {
        UserDoc selectedUser = UserDoc.fromDoctoUserInfo(userDoc);
        _selectedUser = selectedUser;
      }

      notifyListeners();
    } catch (err) {
      print(
          'error cafeteria provider - get selected cafes and add to provider = ' +
              err.toString());
      throw (err);
    }
  }

  void setUserEmpty() {
    _user = null;
    notifyListeners();
  }
}
