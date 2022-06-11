import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:freemeals/enums/connectivity_status.dart';
import 'package:freemeals/enums/view_state.dart';
import 'package:freemeals/models/cafe_model.dart';
import 'package:freemeals/models/order_model.dart';
import 'package:freemeals/providers/order_provider.dart';
import 'package:freemeals/providers/user_provider.dart';
import 'package:freemeals/screen/Order/ongoingOrder_screen.dart';
import 'package:freemeals/screen/Order/products_overview_screen.dart';
import 'package:freemeals/screen/discover_page.dart';
import 'package:freemeals/services/connectivity_service.dart';
import 'package:freemeals/services/order_service.dart';
import 'package:freemeals/widgets/app_wide/app_wide/error_connection_page.dart';
import 'package:freemeals/widgets/app_wide/app_wide/error_page.dart';
import 'package:freemeals/widgets/app_wide/app_wide/loading_page.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OrderWaitingScreen extends StatefulWidget {
  static const routeName = "/orderWaitingScreen";
  int orderCode;
  User user;
  String cafeId;
  String orderDocId;

  OrderWaitingScreen({this.user, this.orderCode, this.orderDocId, this.cafeId});

  @override
  State<OrderWaitingScreen> createState() => _OrderWaitingScreenState();
}

class _OrderWaitingScreenState extends State<OrderWaitingScreen> {
  @override
  Widget build(BuildContext context) {
    ViewState _viewState = ViewState.Idle;
    bool _isInit = true;
    bool _loading = true;

    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(title: Text("Order")),
        body: Container(
          child: Column(children: [
            Center(
                child:
                    Text("Show this code to your server ${widget.orderCode}")),
            StreamBuilder(
                stream: OrderService().getOngoingOrder(widget.orderDocId),
                builder: (ctx, orderSnapshot) {
                  if (orderSnapshot.connectionState ==
                      ConnectionState.waiting) {
                    return LoadingPage();
                  } else {
                    final currUsertype = Provider.of<SelectedUser>(context, listen: false).userType;
                    if (orderSnapshot.hasData) {
                      OrderDoc data = orderSnapshot.data;
                      print(data);
                      // If User is waiter/server
                      if (currUsertype == 0) {
                        // return Container(
                        //   child: Text("Waiter SCreen"),
                        // );
                        if (data.orderStatus == 0 && currUsertype == 0) {
                          // Waiting for the server to join
                          return Container(
                            child:
                                Text(data.numberOfCustomers.toString()),
                          );
                        }
                      }

                      // If User is customer
                      if (currUsertype == 1) {
                        // return Container(
                        //   child: Center(child: Text("Customer SCreen")),
                        // );
                        if (data.orderStatus == 1) {
                          // Order in progress
                          return Container(
                            height: 600,
                            child: OngoingOrder(),
                          ); 
                        } else if (data.orderStatus == 2) {
                          // Order Completed, table closed
                          return Container();
                        }
                      }
                    }
                    return Container(child: Text("This mf"));
                  }
                })
          ]),
        ));
  }
}
