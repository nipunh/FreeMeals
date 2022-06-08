import 'dart:async';
import 'dart:io';
import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:freemeals/enums/screen_name.dart';
import 'package:freemeals/providers/user_provider.dart';
import 'package:freemeals/services/user_preferences.dart';
import 'package:freemeals/services/user_service.dart';

import 'notification_service.dart';

class AuthService {
  final _auth = FirebaseAuth.instance;
  final _user = FirebaseFirestore.instance.collection('users');

  //Sign out
  Future<void> signOut() async {
    try {
      await _auth.signOut();
    } catch (err) {
      print('error Auth service - sign out = ' + err.toString());
      throw (err);
    }
  }

  Future<ScreenName> signIn(
      AuthCredential credential, String phonenumber) async {
    try {
      User user = FirebaseAuth.instance.currentUser;

      if (user == null || user.phoneNumber != phonenumber) {
        UserCredential result = await _auth.signInWithCredential(credential);
        user = result.user;
      }

      if (user != null) {
        await NotificationService().loginSubscribe(user.uid);
        if (Platform.isAndroid) {
          // await NotificationService().createOrderChannel();
        }
        DocumentSnapshot<Map<String, dynamic>> userDoc =
            await _user.doc(user.uid).get();
        if (!userDoc.exists) {
          await _user.doc(user.uid).set({
            'phone': user.phoneNumber,
            'platosCredits': 0.0.toDouble(),
            'companyCredits': 0.0.toDouble(),
            'approvedCompanyId': '',
            'subsidy': false,
            'companyId': '',
            'cafeteriaId': '',
            'displayName': '',
            'emailAddress': '',
            'subsidyType': -1.toInt(),
            'monthlyCompanyCredits': 0.0.toDouble(),
            'empId': null
          });

          return ScreenName.Discovery;
        }
        String name = userDoc.data()['displayName'];
        String email = userDoc.data()['emailAddress'];

        await UserPreferences.setUserId(user.uid);
        await UserPreferences.setUserEmail(email);
        await UserPreferences.setUserName(name);
        await UserPreferences.setUserProfileImg(userDoc.data()['profileImageUrl']);
        await UserPreferences.setUserType(userDoc.data()['userType'].toString());

        // await SelectedUser().setUser(userDoc.data()['id'], userDoc.data()['displayName'], userDoc.data()['userType']);

        if (name == null || name.isEmpty || email == null || email.isEmpty)
          return ScreenName.Discovery;

        return ScreenName.Discovery;
      } else
        return null;
    } catch (err) {
      print('error Auth service - sign in = ' + err.toString());
      throw (err);
    }
  }

  Future<ScreenName> signInWithOTP(
      String smsCode, String verId, String phoneNumber) async {
    try {
      log('data: $phoneNumber');
      AuthCredential authCreds =
          PhoneAuthProvider.credential(verificationId: verId, smsCode: smsCode);

      return await signIn(authCreds, phoneNumber);
    } catch (err) {
      print('error Auth service - sign in with OTP = ' + err.toString());
      throw (err);
    }
  }

  Future<void> updateNumber(PhoneAuthCredential credential) async {
    try {
      User currentUser = FirebaseAuth.instance.currentUser;
      if (currentUser != null) {
        await currentUser.updatePhoneNumber(credential);
        User newUser = FirebaseAuth.instance.currentUser;
        await _user.doc(currentUser.uid).update({
          'phone': newUser.phoneNumber,
        });
      }
    } catch (err) {
      print('error Auth service - update number = ' + err.toString());
      throw (err);
    }
  }

  Future<void> updateWithOTP(smsCode, verId) async {
    try {
      final PhoneAuthCredential credential =
          PhoneAuthProvider.credential(verificationId: verId, smsCode: smsCode);
      await updateNumber(credential);
    } catch (err) {
      print('error user service - update phone = ' + err.toString());
      throw (err);
    }
  }

  Future<void> updateName(User user, String nameText) async {
    try {
      await user.updateDisplayName(nameText);
      await _user.doc(user.uid).update({
        'displayName': nameText,
      });
    } catch (err) {
      print('error Auth service - update name = ' + err.toString());
      throw (err);
    }
  }

  Future<void> addNameAndEmail(
      User user, String nameText, String emailText) async {
    try {
      AuthCredential credential = EmailAuthProvider.credential(
          email: emailText, password: 'Platos@123');
      if (user.email != null && user.email.isNotEmpty) {
        AuthCredential oldCredential = EmailAuthProvider.credential(
            email: user.email, password: 'Platos@123');
        await user.unlink(oldCredential.providerId);
      }
      await user.linkWithCredential(credential);
      await user.updateDisplayName(nameText);
      await _user
          .doc(user.uid)
          .update({'displayName': nameText, 'emailAddress': emailText});
    } catch (err) {
      print('Error Auth service - add mail and name = ' + err.toString());
      throw (err);
    }
  }

  Future<void> updateEmail(User user, String emailText) async {
    try {
      AuthCredential oldCredential = EmailAuthProvider.credential(
          email: user.email, password: 'Platos@123');
      AuthCredential newCredential = EmailAuthProvider.credential(
          email: emailText, password: 'Platos@123');
      UserCredential result = await _auth.signInWithCredential(oldCredential);
      if (result != null) {
        String providerID = oldCredential.providerId;
        await user.unlink(providerID);
        await user.linkWithCredential(newCredential);
        await _user.doc(user.uid).update({'emailAddress': emailText});
      }
    } catch (err) {
      print('Error Auth service - update mail  = ' + err.toString());
      throw (err);
    }
  }
}
