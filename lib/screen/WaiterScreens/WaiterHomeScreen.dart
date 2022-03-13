import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:freemeals/enums/connectivity_status.dart';
import 'package:freemeals/enums/view_state.dart';
import 'package:freemeals/models/cafe_model.dart';
import 'package:freemeals/models/order_model.dart';
import 'package:freemeals/models/user_model.dart';
import 'package:freemeals/providers/order_provider.dart';
import 'package:freemeals/providers/waiter_selection_provider.dart';
import 'package:freemeals/screen/Cafeteria/cateteria_selecttion_screen.dart';
import 'package:freemeals/services/order_service.dart';
import 'package:freemeals/services/user_service.dart';
import 'package:freemeals/widgets/app_wide/app_wide/error_connection_page.dart';
import 'package:freemeals/widgets/app_wide/app_wide/error_page.dart';
import 'package:freemeals/widgets/app_wide/app_wide/loading_page.dart';
import 'package:provider/provider.dart';
import 'package:freemeals/services/connectivity_service.dart';
import 'package:data_connection_checker/data_connection_checker.dart';
import 'package:numberpicker/numberpicker.dart';

import 'package:firebase_auth/firebase_auth.dart';

class WaiterHomeScreen extends StatefulWidget {
  static String routeName = '/waiter-home-screen';

  @override
  _WaiterHomeScreenState createState() => _WaiterHomeScreenState();
}

class _WaiterHomeScreenState extends State<WaiterHomeScreen> {
  ViewState _viewState = ViewState.Idle;
  bool _isInit = true;
  bool _loading = true;

  // @override
  // void didChangeDependencies() {
  //   if (_isInit) {
  //     setState(() {
  //       _viewState = ViewState.Loading;
  //     });
  //     DataConnectionChecker().connectionStatus.catchError((err) {
  //       print(err.toString());
  //       setState(() {
  //         _viewState = ViewState.Error;
  //         return _viewState;
  //       });
  //     }).then((connection) {
  //       if (connection == DataConnectionStatus.disconnected) {
  //         return setState(() {
  //           _viewState = ViewState.ConnectionError;
  //         });
  //       } else {
  //         Provider.of<OrderProvider>(context, listen: false)
  //             .getWaitersOrders("BXO9L4PwBrMHTCK3z6yhNjfPHsG3")
  //             .catchError((err) {
  //           print('error cafeteria screen - get cities/ selected cafe' +
  //               err.toString());

  //           return setState(() {
  //             _viewState = ViewState.Error;
  //           });
  //         });
  //         setState(() {
  //           _viewState = ViewState.Idle;
  //           _isInit = false;
  //         });
  //         return;
  //       }
  //     });
  //   }
  //   _isInit = false;
  //   super.didChangeDependencies();
  // }

  @override
  Widget build(BuildContext context) {
    User user = FirebaseAuth.instance.currentUser;
    return Scaffold(
        body: Container(
            child: MultiProvider(
      providers: [
        StreamProvider(
            initialData: ConnectivityStatus.Connected,
            create: (ctx) =>
                ConnectivityService().connectionStatusController.stream),
      ],
      child: Consumer<ConnectivityStatus>(builder: (ctx, connectionStatus, ch) {
        if (connectionStatus == ConnectivityStatus.None) {
          return ErrorConnectionPage(
              routeName: CafeteriaSelectionScreen.routeName);
        } else {
          if (_viewState == ViewState.Loading)
            return LoadingPage();
          else {
            final orderProvider = Provider.of<OrderProvider>(context);
            orderProvider.getWaitersOrders("BXO9L4PwBrMHTCK3z6yhNjfPHsG3");
            List<OrderDoc> orderRequest = orderProvider.orders;

            return SafeArea(
                child: Scaffold(
                    appBar: AppBar(
                      title: Text('Awaiting Customers'),
                    ),
                    body: Padding(
                        padding: const EdgeInsets.fromLTRB(10, 0, 10, 5),
                        child: ListView.separated(
                            separatorBuilder: (context, index) => Divider(
                                  color: Colors.black,
                                ),
                            itemCount: orderRequest.length,
                            itemBuilder: (BuildContext context, int index) {
                              OrderDoc order = orderRequest.elementAt(index);
                              return new Column(
                                children: <Widget>[
                                  new ListTile(
                                    enabled:
                                        order.orderStatus == 0 ? true : false,
                                    onTap: () {
                                      _settingModalBottomSheet(context);
                                      // UserService().acceptUserRequest(user.uid, order.id);
                                    },
                                    leading: ClipOval(
                                      child: CachedNetworkImage(
                                        imageUrl: "",
                                        placeholder: (context, url) =>
                                            new CircularProgressIndicator(),
                                        errorWidget: (context, url, error) =>
                                            new Icon(Icons.error),
                                      ),
                                    ),
                                    title: new Text(order.displayName),
                                    subtitle: Text(
                                        order.waiterRequestTime.toString()),
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
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text("Enter the following details", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),),
                  SizedBox(height: 10),
                  // NumberPicker(
                  //   value: _currentHorizontalIntValue,
                  //   minValue: 1,
                  //   maxValue: 15,
                  //   step: 1,
                  //   itemHeight: 50,
                  //   axis: Axis.horizontal,
                  //   // onChanged: (value) =>
                  //   //     setState(() => _currentHorizontalIntValue = value),
                  //   decoration: BoxDecoration(
                  //     borderRadius: BorderRadius.circular(16),
                  //     border: Border.all(color: Colors.black26),
                  //   ),
                  // ),
                  TextFormField(
                    decoration: const InputDecoration(
                      icon: const Icon(Icons.dining),
                      hintText: 'Enter table number',
                      labelText: 'Table Number',
                    ),
                  ),
                  TextFormField(
                    decoration: const InputDecoration(
                      icon: const Icon(Icons.person),
                      hintText: 'Enter number of people on table',
                      labelText: 'Customer Count',
                    ),
                  ),
                  new Container(
                      padding: const EdgeInsets.only(left: 150.0, top: 40.0),
                      child: new ElevatedButton(
                        child: const Text('Next'),
                        onPressed: null,
                      )),
                ],
              ),
            ));
      });
}
