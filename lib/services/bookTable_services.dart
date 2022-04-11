import 'dart:async';
import 'dart:io';
import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:freemeals/enums/screen_name.dart';
import 'package:freemeals/models/slot_times_model.dart';

import 'notification_service.dart';

class BookTableService {
  final _auth = FirebaseAuth.instance;
  final _cafe = FirebaseFirestore.instance.collection('cafeterias');


  Future<List<SlotTime>> getSlotTime(String cafeId) async{
    var slots = new List<SlotTime>.empty(growable: true);

    var cafeRef = _cafe.doc(cafeId).collection('staticValues').doc('slotTimes');

    var snapshot = await cafeRef.get();

    var data = snapshot.data();

  
  }

  bool registerTable(String cafeId, DateTime selectedDate, int party, DateTime selectedTime, User user){
    try{

      _cafe.doc(cafeId).collection("tableBookings").doc().set({
        'bookingDate' : selectedDate,
        'bookingTime' : selectedTime,
        'noOfGuests' : party,
        'customerId' : "",
        "email" : "",
        "phoneNumber" : "",
        "bookedAt" : DateTime.now(),
        "customerName" : "",
      });

    }catch(err){
      print(err);
    }
  }
}