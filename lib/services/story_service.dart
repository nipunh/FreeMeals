import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:freemeals/models/cafe_model.dart';
import 'package:freemeals/services/notification_service.dart';
import 'package:provider/provider.dart';

class StoryService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  
  final CollectionReference _story = FirebaseFirestore.instance.collection('stories');
  

  Future<Cafeteria> getStories() async {
    try {
      DocumentSnapshot<Map<String, dynamic>> storyDoc =
          await _story.doc().get();

      if (storyDoc != null && storyDoc.exists) {
        return Cafeteria.fromDocToCafeteria(storyDoc);
      } else
        return null;
    } catch (err) {
      print('error cafe service- get cafe by selected cafe Id = ' +
          err.toString());
      throw (err);
    }
  }
}