import 'package:flutter/material.dart';
import 'package:freemeals/config/stories_data.dart';
import 'package:freemeals/screen/Cafeteria/cateteria_selecttion_screen.dart';
import 'package:freemeals/screen/story_screen.dart';
import 'package:freemeals/config/stories_data.dart';

class StoriesPage extends StatefulWidget {
  @override
  _StoriesPageState createState() => _StoriesPageState();
}

class _StoriesPageState extends State<StoriesPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: getAppBar(),
      body: CafeteriaSelectionScreen(),
    );
  }

  Widget getBody() {
    return Container(
      child: Column(
        children: [ 
          getStories(),
          ],
      ),
    );
  }

  Widget getStories() {
    
    return Container();
  }

  Widget getAppBar() {
    return AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        title: Padding(
          padding: const EdgeInsets.only(top: 25, bottom: 10),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.black.withOpacity(0.1)),
                      child: Icon(
                        Icons.person,
                        color: Colors.blueGrey[200],
                        size: 28,
                      )),
                  SizedBox(
                    width: 5,
                  ),
                  Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.black.withOpacity(0.1)),
                      child: Icon(
                        Icons.search,
                        color: Colors.blueGrey[200],
                        size: 28,
                      ))
                ],
              ),
              Text(
                "Restaurants",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              Row(
                children: [
                  Container(
                      width: 50,
                      height: 40,
                      decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.black.withOpacity(0.1)),
                      child: Icon(
                        Icons.person_add,
                        color: Colors.blueGrey[200],
                        size: 28,
                      )),
                  SizedBox(
                    width: 5,
                  ),
                  Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.black.withOpacity(0.1)),
                      child: Icon(
                        Icons.more_horiz,
                        color: Colors.blueGrey[200],
                        size: 28,
                      ))
                ],
              )
            ],
          ),
        ));
  }
}
