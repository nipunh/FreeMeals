import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:freemeals/constants/userType_constants.dart';

class UserData {}

class UserDoc implements UserData {
  String id;
  String phone;
  String emailAddress;
  String displayName;
  int userType;
  String profileImageUrl;
  Map<String, dynamic> cafeLoyaltyStamps;
  String caption;
  int status;
  double rating;

  UserDoc(
      {@required this.id,
      @required this.phone,
      @required this.emailAddress,
      @required this.displayName,
      @required this.userType,
      @required this.profileImageUrl,
      @required this.cafeLoyaltyStamps,
      this.caption,
      this.status,
      this.rating});

  static UserDoc fromDoctoUserInfo(
      DocumentSnapshot<Map<String, dynamic>> snapshot) {
    final data = snapshot.data();

    return UserDoc(
        id: snapshot.id,
        phone: data['phone'] ?? '',
        emailAddress: data['emailAddress'] ?? '',
        displayName: data['displayName'] ?? '',
        userType: data['userType'] != null ? data['userType'] : 1,
        profileImageUrl: data['profileImageUrl'] ?? '',
        cafeLoyaltyStamps: (data['cafeLoyaltyStamps'] == null)
            ? {}
            : data["cafeLoyaltyStamps"].map((entry) => ({
                  [entry]: data["cafeLoyaltyStamps"][entry]
                })),
        caption:
            (data['caption'] == null) ? "At your service" : data["caption"],
        status: data['status'] ?? 0,
        rating: data['rating'] ?? 0);
  }
}

class Error1 implements UserData {
  String errorMsg;
  Error1(this.errorMsg);
}

class Loading1 implements UserData {
  const Loading1();
}
