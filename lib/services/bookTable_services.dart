import 'dart:async';
import 'dart:io';
import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:freemeals/enums/screen_name.dart';
import 'package:freemeals/models/bookeingRequest_model.dart';
import 'package:freemeals/models/slot_times_model.dart';

import 'notification_service.dart';

class BookTableService {
  final _auth = FirebaseAuth.instance;
  final _cafe = FirebaseFirestore.instance.collection('cafeterias');
  final _tableBooking = FirebaseFirestore.instance.collection('tableBookings');

  Future<List<SlotTime>> getSlotTime(String cafeId) async {
    var slots = new List<SlotTime>.empty(growable: true);

    var cafeRef = _cafe.doc(cafeId).collection('staticValues').doc('slotTimes');

    var snapshot = await cafeRef.get();

    var data = snapshot.data();
  }

  String registerTable(String cafeId, DateTime selectedDate, int party,
      DateTime selectedTime, User user) {
    try {
      var bookingDoc = _tableBooking.doc();

      bookingDoc.set({
        'cafeteriaId': cafeId,
        'bookingDate': selectedDate,
        'bookingTime': selectedTime,
        'noOfGuests': party,
        'customerId': user.uid,
        "email": user.email,
        "phoneNumber": user.phoneNumber,
        "bookedAt": DateTime.now(),
        "customerName": user.displayName,
        "requestStatus": 0,
        "cafeName" : "Deli Planet",
      });

      return bookingDoc.id;
    } catch (err) {
      print(err);
    }
  }

  Future<BookingDoc> getBookingDetails(String bookingId) async {
    try {
      BookingDoc bookingDetails = null;
      DocumentSnapshot<Map<String, dynamic>> bookingDoc = await _tableBooking
          .doc(bookingId)
          .get();

      if (bookingDoc.exists) {
        bookingDetails = BookingDoc.fromDoctoBookingInfo(bookingDoc);
      }

      return bookingDetails;
    } catch (err) {
      print(err);
    }
  }

  Future<List<BookingDoc>> getAllUserBookings(String userId) async {
    try {
      List<BookingDoc> bookingList;

      BookingDoc bookingDetails = null;
      QuerySnapshot<Map<String, dynamic>> bookingDoc = await _tableBooking
          .where("uersId", isEqualTo: userId)
          .get();

      if (bookingDoc.size > 0) {
        bookingList = bookingDoc.docs.map((e) => BookingDoc.fromDoctoBookingInfo(e));
      }

      return bookingList;
    } catch (err) {
      print(err);
    }
  }
}
