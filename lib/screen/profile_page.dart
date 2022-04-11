import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:freemeals/models/user_model.dart';
import 'package:freemeals/screen/UserProfile/numbers_widget.dart';
import 'package:freemeals/screen/UserProfile/profile_widget.dart';
import 'package:freemeals/widgets/app_wide/app_wide/button_widget.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    User user = FirebaseAuth.instance.currentUser;

    return Scaffold(
      appBar: AppBar(
        title: Text("User Details"),
      ),
      body: ListView(
        physics: BouncingScrollPhysics(),
        children: [
          ProfileWidget(
            imagePath:
                "https://firebasestorage.googleapis.com/v0/b/freemeals-3d905.appspot.com/o/dummyCafeImages%2Fpexels-andrea-piacquadio-3801649.jpg?alt=media&token=495b1042-75c0-440b-b267-bc3a50dd64a3",
            onClicked: () async {},
          ),
          const SizedBox(height: 24),
          buildName(user),
          const SizedBox(height: 24),
          Center(child: buildUpgradeButton()),
          const SizedBox(height: 24),
          NumbersWidget(),
          const SizedBox(height: 48),
          buildAbout(user),
        ],
      ),
    );
  }

  Widget buildName(User user) => Column(
        children: [
          Text(
            user.displayName,
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
          ),
          const SizedBox(height: 4),
          Text(
            user.email,
            style: TextStyle(color: Colors.grey),
          )
        ],
      );

  Widget buildUpgradeButton() => ButtonWidget(
        text: 'Upgrade To PRO',
        onClicked: () {},
      );

  Widget buildAbout(User user) => Container(
        padding: EdgeInsets.symmetric(horizontal: 28),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            ExpansionTile(
              title: Text(
                "Personal Details",
                style: TextStyle(fontSize: 22.0, fontWeight: FontWeight.bold),
              ),
              children: <Widget>[
                Text(
                  'Phone Number : ${user.phoneNumber}',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.normal),
                ),
              ],
            ),
            Divider(),
            ExpansionTile(
              title: Text(
                "Orders",
                style: TextStyle(fontSize: 22.0, fontWeight: FontWeight.bold),
              ),
              children: <Widget>[
                ListTile(
                  title: Text(
                    "Expand tile to see previous orders",
                    style: TextStyle(fontWeight: FontWeight.w700),
                  ),
                )
              ],
            ),
            Divider(),
            ExpansionTile(
              title: Text(
                "Reservations",
                style: TextStyle(fontSize: 22.0, fontWeight: FontWeight.bold),
              ),
              children: <Widget>[
                ListTile(
                  title: Text(
                    "Expand tile to see previous orders",
                    style: TextStyle(fontWeight: FontWeight.w700),
                  ),
                )
              ],
            ),
          ],
        ),
      );
}
