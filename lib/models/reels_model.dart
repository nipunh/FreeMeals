import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:freemeals/enums/stories_mediaType.dart';

class Reel {
  String id;
  String videoUrl;
  String caption;
  int likes;
  String profileImg;
  int shares;
  String userId;
  String userName;

   Reel({
    @required this.id,
    @required this.videoUrl,
    @required this.caption,
    @required this.likes,
    @required this.profileImg,
    @required this.shares,
    @required this.userId,
    @required this.userName,
  });

  static Reel fromDocToStory(Map<String, dynamic> doc) {
    final data = doc;

    return Reel(
        id: 'xyz',
        videoUrl: data['videoUrl'],
        caption: data['caption'],
        likes: (data['likes'] == null) ? 0.toInt() : data['likes'].toInt(),
        profileImg: data['profileImg'],
        shares: (data['shares'] == null) ? 0.toInt() : data['shares'].toInt(),
        userId: data['userId'],
        userName: data['userName'],
    );
  }
}

abstract class ReelData {}

class ReelsData implements ReelData {
  final List<Reel> Reels;

  ReelsData(this.Reels);
}

class Error implements ReelData {
  final String errorMsg;

  Error(this.errorMsg);
}

class Loading implements ReelData {
  const Loading();
}
