import 'package:data_connection_checker/data_connection_checker.dart';
import 'package:flutter/material.dart';
import 'package:freemeals/screen/ErrorScreen/order_offline_screen.dart';

class ConnectionErrorScreen extends StatelessWidget {
  static const routeName = '/connection-error';
  const ConnectionErrorScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String pageRouteName;
    String pageRouteArguments;
    final arguments = ModalRoute.of(context).settings.arguments;
    if (arguments.runtimeType.toString() == 'String') {
      pageRouteName = arguments;
    } else {
      final args = arguments as List<String>;
      pageRouteName = args[0];
      pageRouteArguments = args[1];
    }
    return SafeArea(
      child: Scaffold(
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        floatingActionButton: FloatingActionButton.extended(
            icon: Icon(
              Icons.list,
              color: Colors.white,
            ),
            label: Text(
              'Recent Orders',
              style: TextStyle(color: Colors.white),
            ),
            onPressed: () {
              Navigator.of(context).pushNamed(OrderOfflineScreen.routeName);
            }),
        body: Center(
          child: Column(
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
                    return Navigator.of(context).pushReplacementNamed(
                        pageRouteName,
                        arguments: pageRouteArguments);
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
