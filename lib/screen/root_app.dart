import 'package:flutter/material.dart';
import 'package:freemeals/screen/discover_page.dart';
import 'package:freemeals/screen/stories_page.dart';

class RootApp extends StatefulWidget {
  @override
  _RootAppState createState() => _RootAppState();
}

class _RootAppState extends State<RootApp> {
  int pageIndex = 0;

    List<Widget> pages = [
    // MapPage(),
    // ChatPage(),
    // CameraPage(),
    // ChatPage(),
    // StoriesPage(),
      DiscoverPage(),
      StoriesPage(),
      StoriesPage(),
      StoriesPage(),
      StoriesPage(),
      
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: getBody(),
      bottomNavigationBar: getFooter(),
    );
  }

  Widget getBody() {
    // return pages.elementAt(pageIndex);
    return IndexedStack(
      index: pageIndex,
      children: pages,
    );
  }

  Widget getFooter() {
    List iconItems = [
      Icons.pin_drop_outlined, 
      Icons.chat_bubble_outline_rounded,
      Icons.photo_camera_outlined,
      Icons.local_restaurant_outlined,
      Icons.amp_stories_outlined,
    ];
    List textItems = ["Map", "Chat", "Camera", "Stories", "Discover"];
    return Container(
      width: double.infinity,
      height: 60,
      decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.5),
          border: Border(
              top:
                  BorderSide(width: 2, color: Colors.black.withOpacity(0.06)))
          ),
      child: Padding(
        padding:
            const EdgeInsets.only(left: 20, right: 20, bottom: 5, top: 10),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: List.generate(textItems.length, (index) {
            return InkWell(
                onTap: () {
                  selectedTab(index);
                },
                child: Column(
                  children: [
                    Icon(iconItems[index],
                        color: pageIndex == index
                            ? Colors.black
                            : Colors.black.withOpacity(0.5)),
                    SizedBox(
                      height: 5,
                    ),
                    Text(
                      textItems[index],
                      style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w500,
                          color: pageIndex == index
                              ? Colors.black
                              : Colors.black.withOpacity(0.5)),
                    )
                  ],
                ));
          }),
        ),
      ),
    );
  }
    selectedTab(index) {
    setState(() {
      pageIndex = index;
    });
  }
}
