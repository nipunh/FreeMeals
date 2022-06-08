import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:freemeals/enums/connectivity_status.dart';
import 'package:freemeals/enums/view_state.dart';
import 'package:freemeals/models/cafe_model.dart';
import 'package:freemeals/models/order_model.dart';
import 'package:freemeals/providers/order_provider.dart';
import 'package:freemeals/screen/discover_page.dart';
import 'package:freemeals/services/connectivity_service.dart';
import 'package:freemeals/services/order_service.dart';
import 'package:freemeals/widgets/app_wide/app_wide/error_connection_page.dart';
import 'package:freemeals/widgets/app_wide/app_wide/error_page.dart';
import 'package:freemeals/widgets/app_wide/app_wide/loading_page.dart';
import 'package:provider/provider.dart';

class OrderWaitingScreen extends StatelessWidget {
  static const routeName = "/orderWaitingScreen";
  int orderCode;
  User user;
  String cafeId;
  String orderDocId;

  OrderWaitingScreen(
      {@required this.user,
      @required this.orderCode,
      @required this.orderDocId,
      @required this.cafeId});

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
            Center(child: Text("Show this code to your server ${orderCode}")),
            MultiProvider(
                providers: [
                  StreamProvider(
                      initialData: ConnectivityStatus.Connected,
                      create: (ctx) => ConnectivityService()
                          .connectionStatusController
                          .stream),
                  StreamProvider(
                      create: (ctx) =>
                          OrderService().getOngoingOrder(orderDocId),
                      initialData: const Loading(),
                      catchError: (_, error) => Error(error.toString())),
                ],
                child: Consumer<ConnectivityStatus>(
                    builder: (ctx, connectionStatus, ch) {
                  if (connectionStatus == ConnectivityStatus.None) {
                    return ErrorConnectionPage(
                        routeName: DiscoverPage.routeName);
                  } else {
                    if (_viewState == ViewState.Loading)
                      return LoadingPage();
                    else {
                      // var requestProvider =Provider.of<OrderProvider>(context, listen: true);
                      // var userProvider = Provider.of<UserProvider>(context, listen: true);
                      // requestProvider.getOrder(orderDocId);
                      // userProvider.getUser(user.uid);
                      // OrderDoc currOrder = requestProvider.currentOrder;
                      // UserDoc userDoc = userProvider.user;
                      return Consumer<OrderProvider>(
                          builder: (ctx, data, child) {
                        if (data is Loading) {
                          return LoadingPage();
                        } else if (data is Error) {
                          print(data);
                          return ErrorPage(
                              routeName: OrderWaitingScreen.routeName);
                        } else if (data is OrderDoc) {
                          // OrderDoc orderDetails = data2.currentOrder;
                          // print(orderDetails.displayName);

                          // If User is waiter/server
                          // if (userDoc.userType == 0) {
                          //   return Container(
                          //     child: Text("Waiter SCreen"),
                          //   );
                          //   // if (currOrder.orderStatus == 0 &&
                          //   //     userDoc.userType == 0) {
                          //   //   // Waiting for the server to join
                          //   //   return Container(
                          //   //     child:
                          //   //         Text(currOrder.numberOfCustomers.toString()),
                          //   //   );
                          //   // }
                          // }

                          // // If User is customer
                          // if (userDoc.userType == 1) {
                          //   return Container(
                          //     child: Text("Customer SCreen"),
                          //   );
                          //   // if (currOrder.orderStatus == 1) {
                          //   //   // Order in progress
                          //   //   return ProductsOverviewScreen();
                          //   // } else if (currOrder.orderStatus == 2) {
                          //   //   // Order Completed, table closed
                          //   //   return Container();
                          //   // }
                          // }
                        }
                        return Container();
                      });
                    }
                  }
                }))
          ]),
        ));
  }
}
