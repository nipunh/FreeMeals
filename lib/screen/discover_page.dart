import 'package:flutter/material.dart';
import 'package:freemeals/config/data_json.dart';
import 'package:freemeals/models/reels_model.dart';
import 'package:freemeals/models/waiter_Selection.dart';
import 'package:freemeals/screen/BookTable/book_table.dart';
import 'package:freemeals/screen/Cafeteria/waiter_selection_screen.dart';
import 'package:freemeals/widgets/discover_page/icon_widget.dart';
import 'package:video_player/video_player.dart';

class DiscoverPage extends StatefulWidget {
  static const routeName = '/discovery-page';

  @override
  _DiscoverPageState createState() => _DiscoverPageState();
}

class _DiscoverPageState extends State<DiscoverPage>
    with SingleTickerProviderStateMixin {
  TabController _tabController;
  List<Reel> reelList;

  @override
  void initState() {
    super.initState();
    _tabController = new TabController(length: items.length, vsync: this);
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
                    albumImg: items[index]['profileImg'],
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
  State<VideoPlayerItem> createState() => _VideoPlayerreelListtate();
}

class _VideoPlayerreelListtate extends State<VideoPlayerItem>
    with SingleTickerProviderStateMixin {
  VideoPlayerController _videoPlayerController;
  bool isShowPlaying = false;

  @override
  void initState() {
    super.initState();

    _videoPlayerController = VideoPlayerController.network(widget.videoUrl)
      ..initialize().then((value) => setState(() {
            _videoPlayerController.play();
          }));
  }

  @override
  void dispose() {
    _videoPlayerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: InkWell(
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
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              LeftPanel(
                                size: widget.size,
                                albumImg: widget.albumImg,
                                comments: widget.comments,
                                likes: widget.likes,
                                profileImg: widget.profileImg,
                                shares: widget.shares,
                              ),
                              CenterPannel(
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
        margin: EdgeInsets.only(right: 15),
        height: size.height * 0.6,
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
                    // getProfile(profileImg),
                    getIcons(Icons.favorite, 35.0, likes),
                    getIcons(Icons.comment, 35.0, comments),
                    getIcons(Icons.share, 35.0, shares),
                    // getAlbum(albumImg)
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

class LeftPanel extends StatefulWidget {
  final String profileImg;
  final String likes;
  final String comments;
  final String shares;
  final String albumImg;

  LeftPanel({
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
  State<LeftPanel> createState() => _LeftPanelState();
}

class _LeftPanelState extends State<LeftPanel> {
  _loyaltyStamps() {
    List<Wrap> stars = [];
    for (int i = 0; i < 7; i++) {
      stars.add(Wrap(
        children: [
          Icon(Icons.check_circle_rounded,
              color: i < 4 ? Colors.purpleAccent[200] : Colors.white)
        ],
      ));
    }
    return stars;
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
        child: Container(
        margin: EdgeInsets.only(top: widget.size.height * 0.20),
        height: widget.size.height * 0.3,
        decoration: BoxDecoration(
            color: Colors.white24,
            borderRadius: BorderRadius.all(Radius.circular(15.0))),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: _loyaltyStamps(),
      ),
    ));
  }
}

class CenterPannel extends StatelessWidget {
  final String name;
  final String caption;
  final String songName;

  const CenterPannel({
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
      height: size.height,
      width: size.width*0.8,
      // decoration: BoxDecoration(color: Colors.black),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            "Deli PLanet",
            style: TextStyle(color: Colors.white, fontSize: 25),
          ),
          SizedBox(height: 10),
          Text(
            caption,
            style: TextStyle(color: Colors.white, fontSize: 18),
          ),
          SizedBox(height: 10),
          Row(
            children: <Widget>[
              Icon(Icons.music_note, color: Colors.white, size: 25),
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
    final size = MediaQuery.of(context).size;
    return Container(
        height: size.height * 0.06,
        width: size.width * 0.60,
        decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.5),
            borderRadius: BorderRadius.circular(30.0)),
        child: Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
          CircleAvatar(
            child: ClipOval(
              child: Image(
                  height: size.height * 0.06,
                  width: size.height * 0.06,
                  image: NetworkImage(
                      "https://firebasestorage.googleapis.com/v0/b/freemeals-3d905.appspot.com/o/dummyCafeImages%2Fpexels-karolina-grabowska-6919992.jpg?alt=media&token=7d72b535-1231-4afd-9236-4cb25dc3d705"),
                  fit: BoxFit.cover),
            ),
          ),
          Text("Deli Planet",
              style: TextStyle(
                  color: Colors.white.withOpacity(0.75),
                  fontSize: 16,
                  fontWeight: FontWeight.bold)),
          SizedBox(
            width: 5,
          ),
          ElevatedButton(
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all<Color>(Colors.white),
              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                  RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30.0),
                      side: BorderSide(color: Colors.white70))),
            ),
            onPressed: () {
              Navigator.push(context, new MaterialPageRoute(builder: (context) => new BookTable()));
            },
            child: Text('Book Table'),
          )
        ]));
  }
}
