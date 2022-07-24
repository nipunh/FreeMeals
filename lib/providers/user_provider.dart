import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:freemeals/models/user_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:flutter/foundation.dart';

class SelectedUser extends ChangeNotifier {
  String _userId;
  String _userName;
  int _userType;
  String _profileImg;

  SelectedUser() {
    _userId = '';
    _userName = '';
    _userType = 1;
    _profileImg = "";
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

  String get profileImg {
    if (_profileImg != null)
      return _profileImg;
    else {
      loadPreferences();
      return _profileImg;
    }
  }

  Future<void> loadPreferences() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String userId = prefs.getString('cafeId');
      String userName = prefs.getString('cafeName');
      int userType = prefs.getInt('userType');
      String profileImg = prefs.getString('profileImg');
      if (userId != null &&
          userName != null &&
          userType != null &&
          profileImg != null) setUser(userId, userName, userType, profileImg);
    } catch (err) {
      print('loadPreference Cafe error = $err');
      throw Exception(err);
    }
  }

  Future<void> setUser(
      String userId, String userName, int userType, String profileImg) async {
    try {
      _userId = userId;
      _userName = userName;
      _userType = userType;
      _profileImg = profileImg;
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
      prefs.setString("profileImg", _profileImg);
      return;
    } catch (err) {
      print('savePreference Cafe error = $err');
      throw Exception(err);
    }
  }
}

class SelectedWaiter extends ChangeNotifier {
  String _waiterId;
  String _waiterName;
  String _waiterProfileImg;
  double _rating;

  SelectedWaiter() {
    _waiterId = '';
    _waiterName = '';
    _waiterProfileImg = "";
    _rating = null;
    try {
      loadPreferences();
    } catch (err) {
      throw Exception(err);
    }
  }

  String get waiterId {
    if (_waiterId != null)
      return _waiterId;
    else {
      loadPreferences();
      return _waiterId;
    }
  }

  String get waiterName {
    if (_waiterName != null)
      return _waiterName;
    else {
      loadPreferences();
      return _waiterName;
    }
  }

  String get waiterProfileImg {
    if (_waiterProfileImg != null)
      return _waiterProfileImg;
    else {
      loadPreferences();
      return _waiterProfileImg;
    }
  }

  double get rating {
    if (_rating != null)
      return _rating;
    else {
      loadPreferences();
      return _rating;
    }
  }

  Future<void> loadPreferences() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String waiterId = prefs.getString('waiterId');
      String waiterName = prefs.getString('waiterName');
      String waiterProfileImg = prefs.getString('waiterProfileImg');
      double rating = prefs.getDouble('rating');
      if (waiterId != null &&
          waiterName != null &&
          waiterProfileImg != null &&
          rating != null)
        setWaiter(waiterId, waiterName, waiterProfileImg, rating);
    } catch (err) {
      print('loadPreference Cafe error = $err');
      throw Exception(err);
    }
  }

  Future<void> setWaiter(String waiterId, String waiterName,
      String waiterProfileImg, double rating) async {
    try {
      _waiterId = waiterId;
      _waiterName = waiterName;
      _waiterProfileImg = waiterProfileImg;
      _rating = rating;
      notifyListeners();
      return await savePreferences();
    } catch (err) {
      throw Exception(err);
    }
  }

  Future<void> savePreferences() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString('waiterId', _waiterId);
      prefs.setString('waiterName', _waiterName);
      prefs.setString("waiterProfileImg", _waiterProfileImg);
      prefs.setDouble("rating", _rating);
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

  UserDoc _selectedWaiter;

  UserDoc get selectedUser => _selectedUser;

  UserDoc get selectedWaiter => _selectedWaiter;

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

  Future<void> getWaiter(String userId) async {
    try {
      DocumentSnapshot<Map<String, dynamic>> userDoc =
          await _userRef.doc(userId).get();

      if (userDoc.exists) {
        UserDoc selectedUser = UserDoc.fromDoctoUserInfo(userDoc);
        _selectedWaiter = selectedUser;
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
