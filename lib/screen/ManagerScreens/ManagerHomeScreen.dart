import 'package:flutter/material.dart';
import 'package:freemeals/screen/Authentication/auth_screen.dart';
import 'package:freemeals/screen/ManagerScreens/ManagerDrawer.dart';
import 'package:freemeals/screen/profile_page.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ManagerHomeScreen extends StatefulWidget {
  @override
  _ManagerHomeScreenState createState() => _ManagerHomeScreenState();
}

class _ManagerHomeScreenState extends State<ManagerHomeScreen> {
  @override
  Widget build(BuildContext context) {
    User user = FirebaseAuth.instance.currentUser;
    return Scaffold(
        appBar: AppBar(
          title: Text("Manager Home"),
          actions: [
            Container(
              margin: EdgeInsets.only(right: 10),
              child: GestureDetector(
                onTap: (() => Navigator.push(
                    context,
                    user == null
                        ? new MaterialPageRoute(
                            builder: (context) => new AuthScreen())
                        : new MaterialPageRoute(
                            builder: (context) => new ProfilePage()))),
                child: CircleAvatar(
                  backgroundColor: Colors.black12,
                  radius: 18.0,
                  child: ClipOval(
                      child: Icon(
                    Icons.person,
                    color: Colors.white,
                  )),
                ),
              ),
            )
          ],
        ),
        drawer: Drawer(child: ManagerDrawer()),
        body: Container());
  }
}
