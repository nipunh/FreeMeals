import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:freemeals/config/environment_config.dart';
import 'package:freemeals/services/fetch_key_service.dart';
import 'package:http/http.dart' as http;
import 'package:firebase_messaging/firebase_messaging.dart';
// import 'package:platos_client_app/models/cart_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NotificationService {
  final DocumentReference _notificationkey =
      FirebaseFirestore.instance.collection('key').doc('notificationKeys');

  final FirebaseMessaging firebaseMessaging = FirebaseMessaging.instance;

  Future<String> getNotificationToken() async {
    try {
      String _serverToken = (EnvironmentConfig.APP_MODE == 'prod')
          ? await FetchKey()
              .fetchKeyforNotification(_notificationkey, "TOKEN_PROD")
          : (EnvironmentConfig.APP_MODE == 'test')
              ? await FetchKey()
                  .fetchKeyforNotification(_notificationkey, "TOKEN_TEST")
              : await FetchKey()
                  .fetchKeyforNotification(_notificationkey, "TOKEN_DEV");

      return _serverToken;
    } catch (err) {
      print('error Razorpay service - get razorpay keys = ' + err.toString());
      throw Exception(err);
    }
  }

  Future<void> createOrderChannel() async {
    const MethodChannel _channel =
        MethodChannel('platosconsumerapp.com/channel_create');

    Map<String, String> channelMap = {
      "id": "order",
      "name": "Order",
      "description": "Order related notification",
    };

    try {
      await _channel.invokeMethod('createNotificationChannel', channelMap);
    } catch (err) {
      print(
          'Error - notification service - create channel = ' + err.toString());

      throw (err);
    }
  }

  Future<void> loginSubscribe(String userId) async {
    try {
      await firebaseMessaging.subscribeToTopic(userId);
      await firebaseMessaging.subscribeToTopic('users');
    } catch (err) {
      print(
          'Error - notification service - login subscribe = ' + err.toString());
      throw (err);
    }
  }

  Future<void> selectCafeUnSubcribe(
      String cafeId, String companyId, String city) async {
    try {
      await firebaseMessaging.unsubscribeFromTopic('${cafeId}_users');
      await firebaseMessaging.unsubscribeFromTopic('${companyId}_users');
      await firebaseMessaging.unsubscribeFromTopic(city);

    } catch (err) {
      print('Error - notification service - select cafe unsubscribe = ' +
          err.toString());
      throw (err);
    }
  }

  Future<void> selectCafeSubcribe(
      String cafeId, String companyId, String city) async {
    try {
      await firebaseMessaging.subscribeToTopic('${cafeId}_users');
      await firebaseMessaging.subscribeToTopic('${companyId}_users');
      await firebaseMessaging.subscribeToTopic(city);
    } catch (err) {
      print('Error - notification service - select cafe subscribe = ' +
          err.toString());
      throw (err);
    }
  }

  Future<void> logoutUnsubscibe(
      String userId, String cafeId, String companyId, String city) async {
    try {
      await firebaseMessaging.unsubscribeFromTopic(userId);
      await firebaseMessaging.unsubscribeFromTopic('users');
      await firebaseMessaging.unsubscribeFromTopic('${cafeId}_users');
      await firebaseMessaging.unsubscribeFromTopic('${companyId}_users');
      await firebaseMessaging.unsubscribeFromTopic(city);
    } catch (err) {
      print('Error - notification service - login unsubcribe = ' +
          err.toString());

      throw (err);
    }
  }

  // Future<void> sendNotification({
  //   @required List<VendorIdName> vendors,
  // }) async {
  //   try {
  //     String serverToken = await getNotificationToken();
  //     if (serverToken != null) {
  //       String title = 'New Order';

  //       String body = 'An order was placed. Don\'t forget to accept!';

  //       String vendorTopics = '';
  //       vendors.forEach((VendorIdName vendor) {
  //         vendorTopics =
  //             vendorTopics + '\'${vendor.vendorId}\'' + ' in Topics || ';
  //       });
  //       vendorTopics = vendorTopics.substring(0, vendorTopics.length - 4);
  //       await http.post(
  //         Uri.parse('https://fcm.googleapis.com/fcm/send'),
  //         headers: <String, String>{
  //           'Content-Type': 'application/json',
  //           'Authorization': 'key=$serverToken',
  //         },
  //         body: jsonEncode(
  //           <String, dynamic>{
  //             'notification': <String, dynamic>{
  //               'title': title,
  //               'body': body,
  //               'icon': 'notification_icon',
  //             },
  //             'priority': 'high',
  //             'android_channel_id': 'order',
  //             'data': <String, dynamic>{
  //               'click_action': 'FLUTTER_NOTIFICATION_CLICK',
  //               'screen': 'order_status',
  //               'android_channel_id': 'order',
  //             },
  //             'condition': vendorTopics,
  //             'direct_boot_ok': true
  //           },
  //         ),
  //       );
  //     } else {
  //       print(
  //           'Error - notification service - send notification = serverToken == null');
  //     }
  //   } catch (err) {
  //     print('Error - notification service - send notification = ' +
  //         err.toString());
  //     throw (err);
  //   }
  // }

  static Future<void> setNotificationBool(bool value) async {
    var pref = await SharedPreferences.getInstance();
    await pref.setBool('notification', value);
  }

  static Future<bool> getNotificationBool() async {
    return (await SharedPreferences.getInstance()).getBool('notification') ??
        true;
  }
}
