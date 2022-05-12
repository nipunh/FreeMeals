import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:freemeals/enums/connectivity_status.dart';
import 'package:freemeals/enums/view_state.dart';
import 'package:freemeals/models/bookeingRequest_model.dart';
import 'package:freemeals/providers/bookingTable_provider.dart';
import 'package:freemeals/screen/Authentication/auth_screen.dart';
import 'package:freemeals/screen/BookTable/book_table.dart';
import 'package:freemeals/screen/ManagerScreens/ManagerDrawer.dart';
import 'package:freemeals/screen/discover_page.dart';
import 'package:freemeals/screen/profile_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:freemeals/services/bookTable_services.dart';
import 'package:freemeals/services/connectivity_service.dart';
import 'package:freemeals/widgets/app_wide/app_wide/error_connection_page.dart';
import 'package:freemeals/widgets/app_wide/app_wide/loading_page.dart';
import 'package:provider/provider.dart';

class ManagerHomeScreen extends StatefulWidget {
  @override
  _ManagerHomeScreenState createState() => _ManagerHomeScreenState();
}

class _ManagerHomeScreenState extends State<ManagerHomeScreen> {
  ViewState _viewState = ViewState.Idle;
  bool _isInit = true;
  bool _loading = true;

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
        body: Container(
            child: MultiProvider(
          providers: [
            StreamProvider(
                initialData: ConnectivityStatus.Connected,
                create: (ctx) =>
                    ConnectivityService().connectionStatusController.stream),
          ],
          child: Consumer<ConnectivityStatus>(
              builder: (ctx, connectionStatus, ch) {
            if (connectionStatus == ConnectivityStatus.None) {
              return ErrorConnectionPage(routeName: DiscoverPage.routeName);
            } else {
              if (_viewState == ViewState.Loading)
                return LoadingPage();
              else {
                final requestProvider =
                    Provider.of<BookingRequestProvider>(context);
                requestProvider.getBookingRequests("CXdKnqsdwetprt885KVx");
                List<BookingDoc> orderRequest = requestProvider.bookings;

                return SafeArea(
                    child: Scaffold(
                        appBar: AppBar(
                          title: Text('Booking Requests'),
                        ),
                        body: Padding(
                            padding: const EdgeInsets.fromLTRB(10, 0, 10, 5),
                            child: ListView.separated(
                                separatorBuilder: (context, index) => Divider(
                                      color: Colors.black,
                                    ),
                                itemCount: orderRequest.length,
                                itemBuilder: (BuildContext context, int index) {
                                  BookingDoc order =
                                      orderRequest.elementAt(index);
                                  return new Column(
                                    children: <Widget>[
                                      new ListTile(
                                        enabled: order.requestStatus == 0
                                            ? true
                                            : false,
                                        onTap: () {
                                          _settingModalBottomSheet(context);
                                          // UserService().acceptUserRequest(user.uid, order.id);
                                        },
                                        leading: ClipOval(
                                          child: CachedNetworkImage(
                                            imageUrl: "",
                                            placeholder: (context, url) =>
                                                new CircularProgressIndicator(),
                                            errorWidget:
                                                (context, url, error) =>
                                                    new Icon(Icons.person),
                                          ),
                                        ),
                                        title: new Text(
                                            "Booking for ${order.noOfGuests} guests"),
                                        subtitle: Text(
                                            "Date :${order.bookingTime.toString().split(" ")[0]}, Time :${order.bookingTime.toString().split(" ")[1]}"),
                                      ),
                                    ],
                                  );
                                }))));
              }
            }
          }),
        )));
  }
}

void _settingModalBottomSheet(context) {
  int _currentHorizontalIntValue = 1;
  showModalBottomSheet(
      isDismissible: true,
      context: context,
      builder: (BuildContext bc) {
        return Container(
            height: MediaQuery.of(context).size.height * 0.40,
            padding: EdgeInsets.only(top: 20, left: 20, right: 20, bottom: 20),
            child: new Form(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Text(
                    "Accept or Decline Booking Request",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 10),
                  new Container(
                      child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      new ElevatedButton(
                        child: const Text('Decline'),
                        onPressed: null,
                      ),
                      new ElevatedButton(
                        child: const Text('Accept'),
                        onPressed: null,
                      ),
                    ],
                  ))
                ],
              ),
            ));
      });
}
