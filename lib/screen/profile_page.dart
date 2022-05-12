import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:freemeals/enums/connectivity_status.dart';
import 'package:freemeals/enums/view_state.dart';
import 'package:freemeals/models/bookeingRequest_model.dart';
import 'package:freemeals/models/user_model.dart';
import 'package:freemeals/providers/bookingTable_provider.dart';
import 'package:freemeals/screen/Authentication/auth_screen.dart';
import 'package:freemeals/screen/UserProfile/numbers_widget.dart';
import 'package:freemeals/screen/UserProfile/profile_widget.dart';
import 'package:freemeals/services/auth_service.dart';
import 'package:freemeals/services/bookTable_services.dart';
import 'package:freemeals/widgets/app_wide/app_wide/button_widget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:freemeals/widgets/app_wide/app_wide/error_connection_page.dart';
import 'package:freemeals/widgets/app_wide/app_wide/loading_page.dart';
import 'package:provider/provider.dart';
import 'package:freemeals/services/connectivity_service.dart';
import 'package:data_connection_checker/data_connection_checker.dart';

class ProfilePage extends StatefulWidget {
  static String routeName = '/profile-page';

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  static List<BookingDoc> myBookings;
  User user = FirebaseAuth.instance.currentUser;
  ViewState _viewState = ViewState.Idle;
  bool _isInit = true;
  bool _loading = true;

  // @override
  // void initState() {
  //   myBookings = BookTableService().getAllUserBookings(user.uid);
  //   super.initState();
  // }

  @override
  Widget build(BuildContext context) {
    print(myBookings);
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
        text: 'Logout',
        onClicked: () {
          AuthService().signOut();
          Navigator.of(context).pushReplacementNamed(AuthScreen.routeName);
        },
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
            Container(
              child: MultiProvider(
                  providers: [
                    StreamProvider(
                        initialData: ConnectivityStatus.Connected,
                        create: (ctx) => ConnectivityService()
                            .connectionStatusController
                            .stream),
                  ],
                  child: Consumer<ConnectivityStatus>(
                      builder: (ctx, connectionStatus, ch) {
                    if (connectionStatus == ConnectivityStatus.None) {
                      return ErrorConnectionPage(
                          routeName: ProfilePage.routeName);
                    } else {
                      if (_viewState == ViewState.Loading)
                        return LoadingPage();
                      else {
                        final bookingProvider =
                            Provider.of<BookingRequestProvider>(context);
                        bookingProvider.getUserBookings(user.uid);
                        List<BookingDoc> bookings =
                            bookingProvider.customerBookings;
                        return ExpansionTile(
                          title: Text(
                            "Reservations",
                            style: TextStyle(
                                fontSize: 22.0, fontWeight: FontWeight.bold),
                          ),
                          childrenPadding: EdgeInsets.only(left :15, right: 15),
                          children: [
                            new ListView.builder(
                              shrinkWrap: true,
                              physics: NeverScrollableScrollPhysics(),
                              itemCount: bookings.length,
                              itemBuilder: (BuildContext ctx, int index) {
                                return new Container(
                                    height: 50 ,
                                    margin: EdgeInsets.only(bottom: 5),
                                    decoration: BoxDecoration(
                                        color: Colors.grey[100],
                                        border: Border.all(
                                            width: 1, color: Colors.grey[300]),
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(10))),
                                    child: Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          Column( children : [Text(bookings[index].cafeName)])
                                        ]));
                              },
                            )
                          ],
                        );
                      }
                    }
                  })),
            ),
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
          ],
        ),
      );
}
