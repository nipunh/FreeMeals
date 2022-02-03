import 'package:data_connection_checker/data_connection_checker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
// import 'package:platos_client_app/screens/order_offline_screen.dart';

class ErrorConnectionPage extends StatelessWidget {
  final String routeName;
  final String args;
  const ErrorConnectionPage({Key key, this.routeName, this.args})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    User user = FirebaseAuth.instance.currentUser;
    return SafeArea(
      child: Scaffold(
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        floatingActionButton: (user != null &&
                user.displayName != null &&
                user.displayName.isNotEmpty &&
                user.email != null &&
                user.email.isNotEmpty)
            ? _FloatingActionButton()
            : Container(
                height: 0,
                width: 0,
              ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(
                height: MediaQuery.of(context).size.height * 0.4,
                width: MediaQuery.of(context).size.width * 0.80,
                child: Image.asset('assets/images/connection.png'),
              ),
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Text(
                  'No Internet Connectivity',
                  style: TextStyle(
                    fontWeight:
                        Theme.of(context).textTheme.headline2.fontWeight,
                    fontSize: Theme.of(context).textTheme.headline2.fontSize,
                  ),
                ),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  primary: Colors.grey[100],
                  elevation: 3,
                ),
                child: Text('Try Again'),
                onPressed: () async {
                  final connectionStatus =
                      await DataConnectionChecker().connectionStatus;
                  if (connectionStatus == DataConnectionStatus.connected) {
                    return Navigator.of(context)
                        .pushReplacementNamed(routeName, arguments: args);
                  } else {
                    return null;
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _FloatingActionButton extends StatelessWidget {
  const _FloatingActionButton({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton.extended(
        icon: Icon(
          Icons.list,
          color: Colors.black,
        ),
        label: Text(
          'Recent Orders',
          style: TextStyle(color: Colors.black),
        ),
        onPressed: () {
          // Navigator.of(context).pushNamed(OrderOfflineScreen.routeName);
          print("Order offline Screen");
        });
  }
}
