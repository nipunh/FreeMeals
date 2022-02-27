import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:freemeals/models/reels_model.dart';
import 'package:freemeals/services/notification_service.dart';

class ReelServices {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  final CollectionReference _reels =
      FirebaseFirestore.instance.collection('reels');

  Future<List<Reel>> getReelsByCafeteriaID(String cafeteriaId) async {
    try {
      print(cafeteriaId);

      QuerySnapshot<Object> reelDoc = await _reels
          .where("cafeteriaId", isEqualTo: cafeteriaId)
          .limit(10)
          .get();

      if (reelDoc != null && reelDoc.docs.length > 0) {
        return reelDoc.docs.map((doc) {
          return Reel.fromDocToStory(doc.data());
        }).toList();
      } else
        return null;
    } catch (err) {
      print('error cafe service- get reels by selected cafe Id = ' +
          err.toString());
      throw (err);
    }
  }
}
