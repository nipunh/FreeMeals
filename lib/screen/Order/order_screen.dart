import 'package:data_connection_checker/data_connection_checker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:freemeals/enums/view_state.dart';
// import 'package:platos_client_app/enums/connectivity_status.dart';
// import 'package:platos_client_app/enums/view_state.dart';
// import 'package:platos_client_app/models/order_model.dart';
// import 'package:platos_client_app/models/user_model.dart';
// import 'package:platos_client_app/providers/order_provider.dart';
// import 'package:platos_client_app/screens/cart_screen.dart';
// import 'package:platos_client_app/services/connectivity_service.dart';
// import 'package:platos_client_app/services/user_service.dart';
// import 'package:platos_client_app/widgets/app_wide/error_connection_page.dart';
// import 'package:platos_client_app/widgets/app_wide/error_page.dart';
// import 'package:platos_client_app/widgets/app_wide/loading_page.dart';
// import 'package:platos_client_app/widgets/orders/order_listview.dart';
import 'package:provider/provider.dart';

class OrdersScreen extends StatefulWidget {
  static const routeName = '/orders-Screen';

  @override
  _OrdersScreenState createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {
  bool _isInit = true;
  ViewState _viewState = ViewState.Idle;

  @override
  void didChangeDependencies() {
    if (_isInit) {
      setState(() {
        _viewState = ViewState.Loading;
      });
      DataConnectionChecker().connectionStatus.catchError((err) {
        print(err.toString());
        setState(() {
          _viewState = ViewState.Error;
        });
        return null;
      }).then((connection) {
        if (connection == DataConnectionStatus.disconnected) {
          return setState(() {
            _viewState = ViewState.ConnectionError;
          });
        } else {
          setState(() {
            _viewState = ViewState.Idle;
            _isInit = false;
          });
        }
      });
      _isInit = false;
    }
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext){}
  // Widget build(BuildContext context) {
  //   final args = ModalRoute.of(context).settings.arguments;
  //   User user = FirebaseAuth.instance.currentUser;
  //   if (_viewState == ViewState.ConnectionError)
  //     return ErrorConnectionPage(routeName: OrdersScreen.routeName);
  //   if (_viewState == ViewState.Error)
  //     return ErrorPage(routeName: OrdersScreen.routeName);
  //   else
  //     // closely related to home - bottom app bar click
  //     return WillPopScope(
  //         onWillPop: () async {
  //           if (args == "cart") {
  //             await Navigator.of(context).pushReplacementNamed(
  //                 CartScreen.routeName,
  //                 arguments: "order");
  //             return false;
  //           } else {
  //             await Navigator.pop(context);
  //             return false;
  //           }
  //         },
  //         child: ChangeNotifierProvider(
  //           create: (ctx) => OrdersProvider(),
  //           child: Consumer<OrdersProvider>(
  //             builder: (ctx, ordersProvider, ch) => MultiProvider(
  //               providers: [
  //                 StreamProvider(
  //                     initialData: ConnectivityStatus.Connected,
  //                     create: (ctx) => ConnectivityService()
  //                         .connectionStatusController
  //                         .stream),
  //                 StreamProvider(
  //                     create: (ctx) => ordersProvider.listenToOrders(user.uid),
  //                     initialData: const Loading(),
  //                     catchError: (_, error) => Error(error.toString())),
  //                 StreamProvider(
  //                     create: (ctx) => UserService().getUserData(user.uid),
  //                     initialData: const Loading1(),
  //                     catchError: (_, error) => Error1(error.toString())),
  //               ],
  //               child: Consumer<ConnectivityStatus>(
  //                 builder: (ctx, connectionStatus, ch) => (connectionStatus ==
  //                         ConnectivityStatus.None)
  //                     ? ErrorConnectionPage(routeName: OrdersScreen.routeName)
  //                     : Consumer<UserData>(builder: (ctx, data, ch) {
  //                         if (data is Loading1) {
  //                           return LoadingPage();
  //                         } else if (data is Error1) {
  //                           print(data.errorMsg);
  //                           return ErrorPage(routeName: OrdersScreen.routeName);
  //                         } else if (data is UserDoc) {
  //                           UserDoc userData = data;
  //                           return Consumer<OrdersData>(
  //                               builder: (ctx, data, ch) {
  //                             if (data is Loading) {
  //                               return LoadingPage();
  //                             } else if (data is Error) {
  //                               print(data.errorMsg);
  //                               return ErrorPage(
  //                                   routeName: OrdersScreen.routeName);
  //                             } else if (data is Orders) {
  //                               if (_viewState == ViewState.Loading)
  //                                 return LoadingPage();
  //                               else
  //                                 return OrderListView(
  //                                   orders: data.orders,
  //                                   user: user,
  //                                   userData: userData,
  //                                   args: args,
  //                                 );
  //                             } else {
  //                               print('Order page consumer order error');
  //                               return Container();
  //                             }
  //                           });
  //                         } else {
  //                           print(
  //                               'Order page consumer user error - Platos credits');
  //                           return Container();
  //                         }
  //                       }),
  //               ),
  //             ),
  //           ),
  //         ));
  // }
}
