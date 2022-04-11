import 'package:flutter/material.dart';
import 'package:freemeals/models/user_model.dart';
import 'package:freemeals/models/waiter_Selection.dart';
import 'package:freemeals/screen/AnimationScreen.dart';
import 'package:freemeals/screen/Cafeteria/cateteria_selecttion_screen.dart';
import 'package:freemeals/screen/ManagerScreens/MAnagerHomeScreen.dart';
import 'package:freemeals/screen/WaiterScreens/WaiterHomeScreen.dart';
import 'package:freemeals/screen/discover_page.dart';
import 'package:freemeals/screen/stories_page.dart';
import 'package:freemeals/screen/story_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:freemeals/services/user_preferences.dart';

import 'Cafeteria/waiter_selection_screen.dart';

class RootApp extends StatefulWidget {
  final UserDoc user;

  RootApp({Key key, @required this.user}) : super(key: key);

  @override
  _RootAppState createState() => _RootAppState();
}

class _RootAppState extends State<RootApp> {
  int pageIndex = 0;
  int userType = 2;

  @override
  void didChangeDependencies() async {
    bool _isInit = true;

    if (_isInit) {
      // if (UserPreferences.getUserEmailAddress() == null)
      //   await UserPreferences.setUserEmail(widget.user.emailAddress);
      // if (UserPreferences.getUserId() == null)
      //   await UserPreferences.setUserId(widget.user.id);
      // if (UserPreferences.getUserName() == null)
      //   await UserPreferences.setUserName(widget.user.displayName);
      // if (UserPreferences.getUserType() == null)
      //   await UserPreferences.setUserType(widget.user.userType.toString());
      // userType = UserPreferences.getUserType() ?? 1;
    }
    super.didChangeDependencies();
  }

  List<Widget> userPages = [DiscoverPage(), CafeteriaSelectionScreen()];

  List<Widget> adminPages = [
    ManagerHomeScreen(),
  ];

  List<Widget> waiterPages = [
    WaiterHomeScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      body: IndexedStack(
          index: pageIndex,
          children: userType == 2
              ? adminPages
              : userType == 0
                  ? waiterPages
                  : userPages),
      // widget.user.userType == 0 ? waiterPages : userPages),
      bottomNavigationBar: userType == 1 ? getFooter() : null,
    );
  }

  Widget getBody() {
    // return pages.elementAt(pageIndex);
    return IndexedStack(
      index: pageIndex,
      children: userPages,
    );
  }

  Widget getFooter() {
    List bottomBarElements = [
      ElevatedButton(
        style: ButtonStyle(
          backgroundColor:
              MaterialStateProperty.all<Color>(Colors.white.withOpacity(0.30)),
          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
              RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          )),
        ),
        // onPressed: () {
        //   Navigator.push(
        //       context,
        //       new MaterialPageRoute(
        //           builder: (context) => new CafeteriaSelectionScreen()));
        // },
        child: Text('Stories',
            style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold)),
      ),
      ElevatedButton(
          style: ButtonStyle(
            backgroundColor:
                MaterialStateProperty.all<Color>(Colors.purple[400]),
            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0),
            )),
          ),
          onPressed: () {
            Navigator.push(
                context,
                new MaterialPageRoute(
                    builder: (context) => new WaiterSelectionScreen(
                        waiterSelection: new WaiterSelection("Priyank"))));
          },
          child: Text("Start Order",
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold))),
      ElevatedButton(
        style: ButtonStyle(
          backgroundColor:
              MaterialStateProperty.all<Color>(Colors.white.withOpacity(0.8)),
          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
              RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                  side: BorderSide(color: Colors.white70))),
        ),
        onPressed: () {},
        child: Wrap(
          children: [
            Text(
              'W',
              style: TextStyle(
                  color: Colors.black,
                  fontSize: 18,
                  fontWeight: FontWeight.w900),
            ),
            Text('.',
                style: TextStyle(
                    color: Colors.purple[400],
                    fontSize: 20,
                    fontWeight: FontWeight.w900))
          ],
        ),
      )
    ];

    return Container(
      width: double.infinity,
      height: 60,
      color: Color(0x00ffffff),
      child: Padding(
        padding: const EdgeInsets.only(left: 20, right: 20, bottom: 5, top: 10),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: List.generate(bottomBarElements.length, (index) {
            return InkWell(
                onTap: () {
                  // pageIndex == 0 && index == 0
                  //     ? selectedTab(2)
                  //     : selectedTab(index);
                },
                child: bottomBarElements[index]);
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
