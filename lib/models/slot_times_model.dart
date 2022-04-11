import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

class SlotTime {
  String slot;
  int seats;

  SlotTime({
    @required this.slot,
    @required this.seats,
  });

  SlotTime.fromJson(Map<String, dynamic> json){
    slot = json["slot"];
    seats = json["setals"];
  }

  Map<String, dynamic> toJson(){
    final Map<String, dynamic> data = new Map<String, dynamic>();

    data['slot'] = this.slot;
    data['seats'] = this.seats;

    return data;
  }
}

class SlotTimes {
  List<SlotTime> slots;
  SlotTimes({
    @required this.slots,
  });
}

