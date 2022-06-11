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
import 'package:freemeals/screen/Order/OrderWaitingScreen.dart';
import 'package:freemeals/screen/Order/ongoingOrder_screen.dart';
import 'package:freemeals/screen/discover_page.dart';
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
        appBar: AppBar(
          title: Text("Server Home"),
          actions: [
            GestureDetector(
              child: CircleAvatar(
                backgroundColor: Colors.black12,
                child: ClipOval(
                    child: Icon(
                  Icons.person,
                  color: Colors.white,
                )),
              ),
            )
          ],
        ),
        body: SingleChildScrollView(
            child: MultiProvider(
          providers: [
            StreamProvider(
                initialData: ConnectivityStatus.Connected,
                create: (ctx) =>
                    ConnectivityService().connectionStatusController.stream),
          ],
          child: Container(
            child: Column(
              children: [
                Row(
                  children: [
                    ElevatedButton(
                        onPressed: () {
                          _settingModalBottomSheet(context, "BXO9L4PwBrMHTCK3z6yhNjfPHsG3");
                        },
                        child: Text("Start Order"))
                  ],
                ),
                Consumer<ConnectivityStatus>(
                    builder: (ctx, connectionStatus, ch) {
                  if (connectionStatus == ConnectivityStatus.None) {
                    return ErrorConnectionPage(
                        routeName: DiscoverPage.routeName);
                  } else {
                    if (_viewState == ViewState.Loading)
                      return LoadingPage();
                    else {
                      final orderProvider = Provider.of<OrderProvider>(context);
                      orderProvider.getWaitersOrders("BXO9L4PwBrMHTCK3z6yhNjfPHsG3");
                      List<OrderDoc> orderRequest = orderProvider.orders;
                      return Container(
                          child: Column(children: [
                        Container(
                            margin: EdgeInsets.all(10.0),
                            padding: EdgeInsets.all(14.0),
                            decoration: BoxDecoration(
                                color: Colors.green[100],
                                borderRadius:
                                    BorderRadius.all(Radius.circular(20)),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.withOpacity(0.5),
                                    spreadRadius: 2,
                                    blurRadius: 5,
                                    offset: Offset(
                                        0, 3), // changes position of shadow
                                  ),
                                ]),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text(
                                  "Ongoing Order",
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold),
                                ),
                                Divider(),
                                ListView.builder(
                                    physics: NeverScrollableScrollPhysics(),
                                    shrinkWrap: true,
                                    itemCount: orderRequest
                                        .where((element) =>
                                            element.orderStatus == 1 ||
                                            element.orderStatus == 2)
                                        .toList()
                                        .length,
                                    itemBuilder:
                                        (BuildContext context, int index) {
                                      List<OrderDoc> pendingRequestList =
                                          orderRequest
                                              .where((e) =>
                                                  e.orderStatus == 1 ||
                                                  e.orderStatus == 2)
                                              .toList();
                                      OrderDoc order =
                                          pendingRequestList.elementAt(index);
                                      return pendingRequestList.length > 0
                                          ? Container(child: Text("Order"))
                                          : ListTile(
                                              leading:
                                                  Text("No pending Request"),
                                            );
                                    })
                              ],
                              //  Padding(
                              //     padding: const EdgeInsets.fromLTRB(10, 0, 10, 5),
                              //     child: ListView.separated(
                              //         separatorBuilder: (context, index) => Divider(
                              //               color: Colors.black,
                              //             ),
                              //         itemCount: orderRequest.length,
                              //         itemBuilder: (BuildContext context, int index) {
                              //           OrderDoc order =
                              //               orderRequest.elementAt(index);
                              //           return new Column(
                              //             children: <Widget>[
                              //               new ListTile(
                              //                 enabled: order.orderStatus == 0
                              //                     ? true
                              //                     : false,
                              //                 onTap: () {
                              //                   _settingModalBottomSheet(
                              //                       context,
                              //                       "BXO9L4PwBrMHTCK3z6yhNjfPHsG3",
                              //                       order.id);
                              //                 },
                              //                 leading: ClipOval(
                              //                   child: CachedNetworkImage(
                              //                     imageUrl: "",
                              //                     placeholder: (context, url) =>
                              //                         new CircularProgressIndicator(),
                              //                     errorWidget:
                              //                         (context, url, error) =>
                              //                             new Icon(Icons.error),
                              //                   ),
                              //                 ),
                              //                 title: new Text(order.displayName),
                              //                 subtitle: Text(
                              //                     order.waiterRequestTime.toString()),
                              //               ),
                              //             ],
                              //           );
                              //         }))
                            ))
                      ]));
                    }
                  }
                }),
              ],
            ),
          ),
        )));
  }
}

void _settingModalBottomSheet(context, waiterId) {
  int _currentHorizontalIntValue = 1;
  int tableNumber = 0;
  int noOfCustomer = 0;
  int orderId = 0;

  showModalBottomSheet(
      isDismissible: true,
      context: context,
      builder: (BuildContext bc) {
        return StatefulBuilder(builder: (context, StateSetter setState) {
          return Container(
              height: MediaQuery.of(context).size.height * 0.50,
              padding:
                  EdgeInsets.only(top: 20, left: 20, right: 20, bottom: 20),
              child: new Form(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      "Enter the following details",
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 10),
                    TextFormField(
                      decoration: const InputDecoration(
                        icon: const Icon(Icons.dining),
                        hintText: 'Enter order id',
                        labelText: 'Order Id',
                      ),
                      onChanged: ((value) => {
                            setState(() {
                              orderId = int.parse(value);
                            })
                          }),
                    ),
                    TextFormField(
                      decoration: const InputDecoration(
                        icon: const Icon(Icons.dining),
                        hintText: 'Enter table number',
                        labelText: 'Table Number',
                      ),
                      onChanged: ((value) => {
                            setState(() {
                              tableNumber = int.parse(value);
                            })
                          }),
                    ),
                    TextFormField(
                      decoration: const InputDecoration(
                        icon: const Icon(Icons.person),
                        hintText: 'Enter number of people on table',
                        labelText: 'Customer Count',
                      ),
                      onChanged: ((value) => {
                            setState(() {
                              noOfCustomer = int.parse(value);
                            })
                          }),
                    ),
                    new Container(
                        padding: const EdgeInsets.only(left: 150.0, top: 40.0),
                        child: new ElevatedButton(
                          child: const Text('Next'),
                          onPressed: () {
                            OrderProvider().startNewOrder(waiterId, orderId, tableNumber, noOfCustomer);
                            Navigator.push(
                                context,
                                new MaterialPageRoute(
                                    builder: (context) => OrderWaitingScreen(
                                      orderCode: orderId,
                                    )));
                          },
                        )),
                  ],
                ),
              ));
        });
      });
}
