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
import 'package:freemeals/widgets/app_wide/app_wide/NavigationBar.dart';

import 'Cafeteria/waiter_selection_screen.dart';

class RootApp extends StatefulWidget {
  final UserDoc user;

  RootApp({Key key, @required this.user}) : super(key: key);

  @override
  _RootAppState createState() => _RootAppState();
}

class _RootAppState extends State<RootApp> {
  int pageIndex = 0;
  int userType = 1;

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
      bottomNavigationBar: userType == 1 ? NavBar(context: context,) : null,
    );
  }

  Widget getBody() {
    // return pages.elementAt(pageIndex);
    return IndexedStack(
      index: pageIndex,
      children: userPages,
    );
  }

  selectedTab(index) {
    setState(() {
      pageIndex = index;
    });
  }
}


