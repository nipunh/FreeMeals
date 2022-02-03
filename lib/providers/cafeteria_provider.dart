import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:freemeals/models/cafe_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:flutter/foundation.dart';

class SelectedCafeteria extends ChangeNotifier {
  String _cafeId;
  String _cafeName;
  String _city;

  SelectedCafeteria() {
    _cafeId;
    _cafeName;
    _city;
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

  Future<void> setCafeteria(String cafeteriaId, String cafeteriaName,
      String cafeCity) async {
    try {
      _cafeId = cafeteriaId;
      _cafeName = cafeteriaName;
      _city = cafeCity;
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
      if (cafeId != null &&
          cafeName != null &&
          city != null) setCafeteria(cafeId, cafeName, city);
    } catch (err) {
      print('loadPreference Cafe error = $err');
      throw Exception(err);
    }
  }
}

class CafeteriaProvider extends ChangeNotifier {
  final CollectionReference _cafeteria =
      FirebaseFirestore.instance.collection('cafeterias');

  final CollectionReference _companies =
      FirebaseFirestore.instance.collection('companies');

  List<Cafeteria> _cafes = [];

  List<Cafeteria> get cafes => [..._cafes];

  Cafeteria _selectedCafeteria;

  Cafeteria get selectedCafeteria => _selectedCafeteria;

  Future<void> getSelectedCafe(String selectedCafeteriaId) async {
    try {
      _selectedCafeteria = null;
      _cafes = [];
      if (selectedCafeteriaId == null || selectedCafeteriaId.isEmpty) {
      } else {
        DocumentSnapshot<Map<String, dynamic>> cafeDoc =
            await _cafeteria.doc(selectedCafeteriaId).get();
        Cafeteria selectedCafe = Cafeteria.fromDocToCafeteria(cafeDoc);
        _selectedCafeteria = selectedCafe;
      }
      notifyListeners();
    } catch (err) {
      print(
          'error cafeteria provider - get selected cafes and add to provider = ' +
              err.toString());
      throw (err);
    }
  }

  Future<void> getCafes(String city, String companyId) async {
    try {
      QuerySnapshot<Map<String, dynamic>> cafeDocs = await _cafeteria
          .where('disabled', isEqualTo: false)
          .where('city', isEqualTo: city)
          .get();

      List<Cafeteria> cafeterias = cafeDocs.docs.map((doc) {
        return Cafeteria.fromDocToCafeteria(doc);
      }).toList();

      _cafes = [];
      _cafes = cafeterias;
      notifyListeners();
    } catch (err) {
      print('error cafeteria provider - get cafes and add to provider = ' +
          err.toString());
      throw (err);
    }
  }

  void setCafesToEmpty() {
    _cafes = [];
    notifyListeners();
  }
}
