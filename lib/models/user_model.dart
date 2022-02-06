import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:freemeals/models/cafe_model.dart';

abstract class UserData {}

class UserDoc implements UserData {
  String id;
  String phone;
  String emailAddress;
  String displayName;
  String userType;
  Map<String, dynamic> cafeLoyaltyStamps;

  UserDoc({
    @required this.id,
    @required this.phone,
    @required this.emailAddress,
    @required this.displayName,
    @required this.userType,
    @required this.cafeLoyaltyStamps
  });

  static UserDoc fromDoctoUserInfo(
    
    DocumentSnapshot<Map<String, dynamic>> snapshot) {
    
    CafesData cafe;

    final data = snapshot.data();

    return UserDoc(
      id: snapshot.id,
      phone: data['phone'] ?? '',
      emailAddress: data['emailAddress'] ?? '',
      displayName: data['displayName'] ?? '',
      userType: data['userType'] ?? '',
      cafeLoyaltyStamps: (data['cafeLoyaltyStamps'] == null) ? {}
        : data["cafeLoyaltyStamps"].map((entry) => ({[entry] : data["cafeLoyaltyStamps"][entry]  }))
    );
  }
}

class Error1 implements UserData {
  String errorMsg;
  Error1(this.errorMsg);
}

class Loading1 implements UserData {
  const Loading1();
}
