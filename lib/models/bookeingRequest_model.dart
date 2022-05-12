import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class BookingData {}

class BookingDoc implements BookingData {
  String id;
  String customerId;
  String customerName;
  int noOfGuests;
  DateTime bookingDate;
  DateTime bookingTime;
  String cafeId;
  String email;
  String bookedAt;
  int requestStatus;
  String cafeName;

  BookingDoc({
    @required this.id,
    this.customerId,
    this.customerName,
    this.noOfGuests,
    this.bookingDate,
    this.bookingTime,
    this.cafeId,
    this.email,
    @required bookedAt,
    this.requestStatus,
    this.cafeName
  });

  static BookingDoc fromDoctoBookingInfo(
    DocumentSnapshot<Map<String, dynamic>> snapshot) {
    final data = snapshot.data();

    return BookingDoc(
      id: snapshot.id,
      customerId: data['customerId'] ?? '',
      customerName: data['customerName'] ?? '',
      noOfGuests: data['noOfGuests'] ?? 0,
      bookingTime : data['bookingTime'] != null ? data['bookingTime'].toDate().toLocal() : null,
      bookingDate: data['bookingDate'] != null ? data['bookingDate'].toDate().toLocal() : null,
      cafeId: data['cafeId'] ?? '',
      email: data['email'] ?? '',
      bookedAt: data['bookedAt'] != null ? data['bookedAt'].toDate().toLocal() : null,
      requestStatus : data['requestStatus'] ?? 0,
      cafeName: data['cafeName'] ?? '',
    );
  }
}

class BookingRequests implements BookingData {
  List<BookingDoc> orderLists;

  BookingRequests(this.orderLists);
}

class Error1 implements BookingData {
  String errorMsg;
  Error1(this.errorMsg);
}

class Loading1 implements BookingData {
  const Loading1();
}
