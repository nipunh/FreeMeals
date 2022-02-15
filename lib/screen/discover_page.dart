import 'package:flutter/material.dart';
import 'package:freemeals/config/data_json.dart';
import 'package:freemeals/widgets/discover_page/icon_widget.dart';
import 'package:video_player/video_player.dart';

class DiscoverPage extends StatefulWidget {

  final bool data;
  DiscoverPage({this.data});

  @override
  _DiscoverPageState createState() => _DiscoverPageState();
}

class _DiscoverPageState extends State<DiscoverPage>
    with SingleTickerProviderStateMixin {
  TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: items.length, vsync: this);
  }

  @override
  void dispose() {
    super.dispose();
    _tabController.dispose();
  }

  Widget getBody() {
    var size = MediaQuery.of(context).size;
    return RotatedBox(
      quarterTurns: 1,
      child: TabBarView(
        controller: _tabController,
        children: List.generate(
            items.length,
            (index) => RotatedBox(
                  quarterTurns: -1,
                  child: VideoPlayerItem(
                    size: size,
                    name: items[index]['name'],
                    videoUrl: items[index]['videoUrl'],
                    caption: items[index]['caption'],
                    songName: items[index]['songName'],
                    profileImg: items[index]['profileImg'],
                    likes: items[index]['likes'],
                    comments: items[index]['comments'],
                    shares: items[index]['shares'],
                    albumImg: items[index]['albumImg'],
                  ),
                )),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return getBody();
  }
}

class VideoPlayerItem extends StatefulWidget {
  final String name;
  final String videoUrl;
  final String caption;
  final String songName;
  final String profileImg;
  final String likes;
  final String comments;
  final String shares;
  final String albumImg;

  const VideoPlayerItem({
    Key key,
    @required this.size,
    this.name,
    this.caption,
    this.songName,
    this.profileImg,
    this.likes,
    this.comments,
    this.shares,
    this.albumImg,
    this.videoUrl,
  }) : super(key: key);

  final Size size;

  @override
  State<VideoPlayerItem> createState() => _VideoPlayerItemState();
}

class _VideoPlayerItemState extends State<VideoPlayerItem>
    with SingleTickerProviderStateMixin {
  VideoPlayerController _videoPlayerController;
  bool isShowPlaying = false;

  @override
  void initState() {

    super.initState();

    _videoPlayerController = VideoPlayerController.network(widget.videoUrl)
      ..initialize().then((value) => setState((){}));
  }

  @override
  void dispose() {
     _videoPlayerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => setState(() {
        _videoPlayerController.value.isPlaying
            ? _videoPlayerController.pause()
            : _videoPlayerController.play();
      }),
      child: Container(
        width: widget.size.width,
        height: widget.size.height,
        color: Colors.black,
        child: Stack(
          children: <Widget>[
            Container(
              width: widget.size.width,
              height: widget.size.height,
              child: Stack(
                children: <Widget>[
                  VideoPlayer(_videoPlayerController),
                  // _videoPlayerController.value.isPlaying && isShowPlaying
                  //     ?   Container() : Center( 
                  //         child: Icon(Icons.play_arrow,
                  //             size: 80, color: Colors.white.withOpacity(0.5)),
                  //       )
                      
                ],
              ),
            ),
            Container(
              width: widget.size.width,
              height: widget.size.height,
              child: SafeArea(
                child: Padding(
                  padding: const EdgeInsets.only(
                      top: 25, right: 15, left: 15, bottom: 10),
                  child: Column(
                    children: <Widget>[
                      HeaderHomePage(),
                      Flexible(
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            LeftPannel(
                              size: widget.size,
                              name: widget.name,
                              caption: widget.caption,
                              songName: widget.songName,
                            ),

                            RightPanel(
                              size: widget.size,
                              albumImg: widget.albumImg,
                              comments: widget.comments,
                              likes: widget.likes,
                              profileImg: widget.profileImg,
                              shares: widget.shares,
                            )
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class RightPanel extends StatelessWidget {
  final String profileImg;
  final String likes;
  final String comments;
  final String shares;
  final String albumImg;

  const RightPanel({
    Key key,
    @required this.size,
    this.profileImg,
    this.likes,
    this.comments,
    this.shares,
    this.albumImg,
  }) : super(key: key);

  final Size size;

  @override
  Widget build(BuildContext context) {
    return Expanded(
        child: Container(
      height: size.height,
      child: Column(
        children: <Widget>[
          Container(
            height: size.height * 0.3,
          ),
          Expanded(
            child: Container(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  getProfile(profileImg),
                  getIcons(Icons.message_rounded, 35.0, likes),
                  getIcons(Icons.remove_circle_outlined, 35.0, comments),
                  getIcons(Icons.ac_unit, 35.0, shares),
                  getAlbum(albumImg)
                ],
              ),
            ),
          )
        ],
      ),
    ));
  }
}

class LeftPannel extends StatelessWidget {
  final String name;
  final String caption;
  final String songName;

  const LeftPannel({
    Key key,
    @required this.size,
    this.name,
    this.caption,
    this.songName,
  }) : super(key: key);

  final Size size;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size.width * 0.8,
      height: size.height,
      // decoration: BoxDecoration(color: Colors.black),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            name,
            style: TextStyle(color: Colors.white),
          ),
          SizedBox(height: 10),
          Text(
            caption,
            style: TextStyle(color: Colors.white),
          ),
          SizedBox(height: 10),
          Row(
            children: <Widget>[
              Icon(Icons.music_note, color: Colors.white, size: 15),
              Text(
                songName,
                style: TextStyle(color: Colors.white, fontSize: 12),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class HeaderHomePage extends StatelessWidget {
  const HeaderHomePage({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text("Following",
            style: TextStyle(
                color: Colors.white.withOpacity(0.5),
                fontSize: 16,
                fontWeight: FontWeight.w500)),
        SizedBox(
          width: 5,
        ),
        Text("|",
            style: TextStyle(
                color: Colors.white.withOpacity(0.5),
                fontSize: 16,
                fontWeight: FontWeight.bold)),
        SizedBox(
          width: 5,
        ),
        Text("For You",
            style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold)),
      ],
    );
  }
}
