import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:freemeals/enums/stories_mediaType.dart';

class Story {
   String id;
   String userId;
   MediaType media;
   Duration duration;
   String cafeId;
   int views;
   DateTime uploadedAt;
   String location;
   String url;

   Story({
    @required this.id,
    @required this.url,
    @required this.media,
    @required this.duration,
    @required this.userId,
    @required this.cafeId,
    @required this.views,
    @required this.uploadedAt,
    @required this.location,
  });

  static Story fromDocToStory(
      DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data();

    return Story(
        id: doc.id,
        url: data['url'],
        media: data['media'],
        duration: (data['cafeCode'] == null) ? 5.toInt() : data['cafeCode'].toInt(),
        userId: data['userId'],
        cafeId: data['cafeId'],
        views: data['views'],
        uploadedAt: data['uploadedAt'],
        location: data['location'],
    );
  }
}

abstract class StoryData {}

class Stories implements StoryData {
  final List<Story> stories;

  Stories(this.stories);
}

class Error implements StoryData {
  final String errorMsg;

  Error(this.errorMsg);
}

class Loading implements StoryData {
  const Loading();
}
