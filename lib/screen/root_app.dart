import 'package:flutter/material.dart';
import 'package:freemeals/models/cafe_model.dart';
import 'package:freemeals/models/reels_model.dart';
import 'package:freemeals/models/user_model.dart';
import 'package:freemeals/models/waiter_Selection.dart';
import 'package:freemeals/providers/user_provider.dart';
import 'package:freemeals/screen/AnimationScreen.dart';
import 'package:freemeals/screen/Authentication/auth_screen.dart';
import 'package:freemeals/screen/Cafeteria/cateteria_selecttion_screen.dart';
import 'package:freemeals/screen/ManagerScreens/MAnagerHomeScreen.dart';
import 'package:freemeals/screen/WaiterScreens/WaiterHomeScreen.dart';
import 'package:freemeals/screen/discover_page.dart';
import 'package:freemeals/screen/stories_page.dart';
import 'package:freemeals/screen/story_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:freemeals/services/user_preferences.dart';
import 'package:freemeals/services/user_service.dart';
import 'package:freemeals/widgets/app_wide/app_wide/NavigationBar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:freemeals/widgets/app_wide/app_wide/loading_page.dart';
import 'package:provider/provider.dart';
import 'Cafeteria/waiter_selection_screen.dart';

class RootApp extends StatefulWidget {
  @override
  _RootAppState createState() => _RootAppState();
}

class _RootAppState extends State<RootApp> {
  int pageIndex = 0;
  int userType = 1;
  var currUser;

  @override
  void didChangeDependencies() async {
    bool _isInit = true;
    if (_isInit) {}
    super.didChangeDependencies();
  }

  @override
  void initState() {
    super.initState();
    getCurrentUser();
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
    if (currUser != null) {
      return Scaffold(
          extendBody: true,
          body: StreamBuilder(
              stream: FirebaseAuth.instance.authStateChanges(),
              builder: (ctx, userSnapshot) {
                if (userSnapshot.connectionState == ConnectionState.waiting) {
                  return LoadingPage();
                } else {
                  if (userSnapshot.hasData) {
                    return StreamBuilder(
                        stream: UserService().getUser(userSnapshot.data.uid),
                        builder: (BuildContext ctx, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return LoadingPage();
                          } else {
                            if (snapshot.hasData) {
                              UserDoc userData = snapshot.data;

                              Provider.of<SelectedUser>(context, listen: false)
                                  .setUser(userData.id, userData.displayName,
                                      userData.userType);

                              return IndexedStack(
                                  index: pageIndex,
                                  children: userData.userType == 2
                                      ? adminPages
                                      : userData.userType == 0
                                          ? waiterPages
                                          : userPages);
                            }
                            return Container(child: Text("Empty"));
                          }
                        });
                  } else {
                    return AuthScreen();
                  }
                }
              }),
          bottomNavigationBar: NavBar(
            context: context,
          ));
    } else {
      return AuthScreen();
    }
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

  getCurrentUser() async {
    if (FirebaseAuth.instance.currentUser != null) {
      var userId = FirebaseAuth.instance.currentUser.uid;
      currUser = Future.wait(
          [FirebaseFirestore.instance.collection("users").doc(userId).get()]);
      // DocumentSnapshot<Map<String, dynamic>> userData = await FirebaseFirestore
      //     .instance
      //     .collection("users")
      //     .doc(userId)
      //     .get();
      // Provider.of<SelectedUser>(context, listen: false).setUser(userData.id,
      //     userData.data()['displayName'], userData.data()['userType']);
    } else {
      currUser = null;
    }
  }
}
