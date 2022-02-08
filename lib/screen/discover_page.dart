import 'package:flutter/material.dart';
import 'package:freemeals/config/data_json.dart';

class DiscoverPage extends StatefulWidget {
  @override
  _DiscoverPageState createState() => _DiscoverPageState();
}

class _DiscoverPageState extends State<DiscoverPage> {
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Container(
      width: size.width,
      height: size.height,
      child: Stack(
        children: <Widget>[
          Container(
            width: size.width,
            height: size.height,
            decoration: BoxDecoration(
              color: Colors.black,
            ),
          ),
          Container(
            width: size.width,
            height: size.height,
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
                          LeftPannel(size: size),
                          Expanded(
                              child: Container(
                            height: size.height,
                            // decoration:
                            //     BoxDecoration(color: Colors.blueGrey[50]),
                              child: Column(
                                children: <Widget>[
                                  Container(
                                    height: size.height * 0.3,

                                  ),
                                  Expanded(
                                    child: Container(
                                      decoration: BoxDecoration(
                                          color: Colors.blueGrey[200] 
                                        ),
                                        child: Column(
                                          children: <Widget>[
                                            getProfile()
                                          ],
                                        ),
                                    ),
                                  )
                              ],),
                            )
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
    );
  }

  Widget getProfile(){
    return 
    Container(
        width: 55,
        height: 55,
        child: Stack(
          children: <Widget>[
            Container(
              height: 50,
              width: 50,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.white),
                shape: BoxShape.circle,
                image : DecorationImage(
                  image: NetworkImage(items[0]['profileImg']), fit : BoxFit.cover )
                )
              ),
              Positioned(
                left: 18,
                bottom: -5,
                child: Container(
                width: 20,
                height: 20,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.blueGrey[200]
                ),
                child: Center(
                  child: Icon(Icons.add, color: Colors.white, size: 15,),
                ),                
              ))
          ],
        ),
      );
  }
}



class LeftPannel extends StatelessWidget {
  const LeftPannel({
    Key key,
    @required this.size,
  }) : super(key: key);

  final Size size;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size.width * 0.8,
      height: size.height,
      decoration:
          BoxDecoration(color: Colors.black),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            items[0]['name'],
            style: TextStyle(color: Colors.white),
          ),
          SizedBox(height: 10),
          Text(
            items[0]['caption'],
            style: TextStyle(color: Colors.white),
          ),
          SizedBox(height: 10),
          Row(
            children: <Widget>[
              Icon(Icons.music_note,
                  color: Colors.white, size: 15),
              Text(
                items[0]['songName'],
                style: TextStyle(
                    color: Colors.white, fontSize: 12),
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
