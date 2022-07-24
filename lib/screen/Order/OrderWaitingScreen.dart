import 'package:assorted_layout_widgets/assorted_layout_widgets.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:freemeals/constants/order_constants.dart';
import 'package:freemeals/enums/connectivity_status.dart';
import 'package:freemeals/enums/view_state.dart';
import 'package:freemeals/models/cafe_model.dart';
import 'package:freemeals/models/order_model.dart';
import 'package:freemeals/models/user_model.dart';
import 'package:freemeals/providers/order_provider.dart';
import 'package:freemeals/providers/user_provider.dart';
import 'package:freemeals/screen/Order/cart_screen.dart';
import 'package:freemeals/screen/Order/ongoingOrder_screen.dart';
import 'package:freemeals/screen/Order/products_overview_screen.dart';
import 'package:freemeals/screen/WaiterScreens/waiter_order_screen.dart';
import 'package:freemeals/screen/discover_page.dart';
import 'package:freemeals/services/connectivity_service.dart';
import 'package:freemeals/services/order_service.dart';
import 'package:freemeals/services/user_service.dart';
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
    final size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.white,
      floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
      resizeToAvoidBottomInset: false,
      appBar: AppBar(title: Text("Order")),
      body: SingleChildScrollView(
        child: Stack(children: <Widget>[
          Column(children: [
            StreamBuilder(
                stream: OrderService().getOngoingOrder(widget.orderDocId),
                builder: (ctx, orderSnapshot) {
                  if (orderSnapshot.connectionState ==
                      ConnectionState.waiting) {
                    return LoadingPage();
                  } else {
                    final currUsertype =
                        Provider.of<SelectedUser>(context, listen: false)
                            .userType;
                    if (orderSnapshot.hasData) {
                      OrderDoc data = orderSnapshot.data;
                      UserService().getUserDoc(data.waiterId).then((waiter) => {
                            Provider.of<SelectedWaiter>(context, listen: false)
                                .setWaiter(waiter.id, waiter.displayName,
                                    waiter.profileImageUrl, waiter.rating)
                          });

                      if (currUsertype == 0) {
                        if (data.orderStatus == 0) {
                          // Waiting for the server to join
                          return Container(
                              height: 600, child: Text("Dont know what to do"));
                        }
                        if (data.orderStatus == 1) {
                          // Waiting for the server to join
                          return WaiterOrderScreen(
                            orderdata: data,
                          );
                        }
                      }

                      // If User is customer
                      if (currUsertype == 1) {
                        if (data.orderStatus == 0) {
                          return Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: <Widget>[
                                Container(
                                    height: size.height * 0.35,
                                    decoration:
                                        BoxDecoration(color: Colors.white),
                                    padding: EdgeInsets.only(bottom: 25),
                                    //ClipRRect for image border radius
                                    child: ClipRRect(
                                        child: Image.network(
                                      "https://firebasestorage.googleapis.com/v0/b/freemeals-3d905.appspot.com/o/cafeterias%2FCXdKnqsdwetprt885KVx%2FofferBanners%2Ffood-offer-banner.jpg?alt=media&token=d966d3aa-d0cc-4dae-bc8f-0b75a8943d47",
                                      width: MediaQuery.of(context).size.width,
                                      fit: BoxFit.cover,
                                    ))),
                                Container(
                                    alignment: Alignment.center,
                                    child: Column(
                                      children: [
                                        Text(
                                          "Show this code to your waiter",
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold),
                                        ),
                                        SizedBox(
                                          height: 40,
                                        ),
                                        SizedBox(
                                          height: 120.0,
                                          width: 120.0,
                                          child: CircularProgressIndicator(
                                            semanticsLabel: "Loading",
                                            strokeWidth: 6.0,
                                          ),
                                        ),
                                        SizedBox(
                                          height: 50,
                                        ),
                                        Card(
                                            clipBehavior: Clip.antiAlias,
                                            margin: EdgeInsets.all(4.0),
                                            elevation: 18.0,
                                            shape: RoundedRectangleBorder(
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(10.0))),
                                            child: Container(
                                              padding: EdgeInsets.all(8.0),
                                              height: size.height * 0.125,
                                              width: size.width * 0.85,
                                              decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.all(
                                                          Radius.circular(
                                                              15.0)),
                                                  color: Colors.white),
                                              child: Column(children: [
                                                Text(
                                                  "Code",
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                                SizedBox(
                                                  height: 10,
                                                ),
                                                Text(
                                                  "${data.orderId}",
                                                  style: TextStyle(
                                                      fontSize: 28,
                                                      letterSpacing: 28.0),
                                                )
                                              ]),
                                            )),
                                      ],
                                    ))
                              ]);
                        }

                        if (data.orderStatus == 1) {
                          return Container(
                            height: size.height * 0.90,
                            child: OngoingOrder(
                              orderDoc: data,
                            ),
                          );
                        } else if (data.orderStatus == 2) {
                          return Container();
                        }
                      }
                    }
                    return Container(child: Text("This mf 3"));
                  }
                })
          ]),
        ]),
      ),
    );
  }
}
