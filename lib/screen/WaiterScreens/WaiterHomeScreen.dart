import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:freemeals/enums/connectivity_status.dart';
import 'package:freemeals/enums/view_state.dart';
import 'package:freemeals/models/cafe_model.dart';
import 'package:freemeals/models/order_model.dart';
import 'package:freemeals/models/user_model.dart';
import 'package:freemeals/providers/waiter_selection_provider.dart';
import 'package:freemeals/services/order_service.dart';
import 'package:freemeals/services/user_service.dart';
import 'package:freemeals/widgets/app_wide/app_wide/error_connection_page.dart';
import 'package:freemeals/widgets/app_wide/app_wide/error_page.dart';
import 'package:freemeals/widgets/app_wide/app_wide/loading_page.dart';
import 'package:provider/provider.dart';
import 'package:freemeals/services/connectivity_service.dart';
import 'package:data_connection_checker/data_connection_checker.dart';

class WaiterHomeScreen extends StatefulWidget {
  static String routeName = '/waiter-home-screen';

  @override
  _WaiterHomeScreenState createState() => _WaiterHomeScreenState();
}

class _WaiterHomeScreenState extends State<WaiterHomeScreen> {
  ViewState _viewState = ViewState.Idle;
  bool _isInit = true;
  bool _loading = true;

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
          return _viewState;
        });
      }).then((connection) {
        if (connection == DataConnectionStatus.disconnected) {
          return setState(() {
            _viewState = ViewState.ConnectionError;
          });
        } else {
          // final selectedCafeteriaId =
          //     Provider.of<SelectedCafeteria>(context, listen: false).cafeId;
          // Provider.of<CafeteriaProvider>(context, listen: false)
          //     .getSelectedCafe(selectedCafeteriaId)
          //     .catchError((err) {
          //   print('error cafeteria screen - get cities/ selected cafe' +
          //       err.toString());
          //   return setState(() {
          //     _viewState = ViewState.Error;
          //   });
          // }).then((_) {
          final provider = Provider.of<WaiterProvider>(context, listen: false);
          if (provider.waiters == null) {
            // companyCode = provider.selectedCafeteria.companyCode.toString();
            // city = provider.selectedCafeteria.city;
            // provider.getCompany(companyCode).catchError((err) {
            //   print('error cafeteria screen - get company' + err.toString());
            //   return setState(() {
            //     _viewState = ViewState.Error;
            //   });
            // }).then((_) {

            //   final provider1 =
            //       Provider.of<WaiterProvider>(context, listen: false);
            //   if (provider1.cafes.isEmpty) {
            //     provider1.getCafes('Montreal').catchError((err) {
            //       print('error cafeteria screen - get company' + err.toString());
            //       return setState(() {
            //         _viewState = ViewState.Error;
            //       });
            //     }).then((_) {
            //       setState(() {
            //         _viewState = ViewState.Idle;
            //         _isInit = false;
            //       });
            //       return;
            //     });
            //   } else {
            //     setState(() {
            //       _viewState = ViewState.Idle;
            //       _isInit = false;
            //     });
            //     return;
            //   }
            // }
            // } else {
            //   setState(() {
            //     _viewState = ViewState.Idle;
            //     _isInit = false;
            //   });
            //   return;
            // }
            // });
          }
        }
      });
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: MultiProvider(
          providers: [
            StreamProvider(
                initialData: ConnectivityStatus.Connected,
                create: (ctx) =>
                    ConnectivityService().connectionStatusController.stream),
            StreamProvider(
                create: (ctx) =>
                    OrderService().getCartItems("BXO9L4PwBrMHTCK3z6yhNjfPHsG3"),
                initialData: const Loading(),
                catchError: (_, error) => Error(error.toString())),
          ],
          child: Consumer<ConnectivityStatus>(
              builder: (ctx, connectionStatus, ch) {
            if (connectionStatus == ConnectivityStatus.None) {
              return ErrorConnectionPage(routeName: WaiterHomeScreen.routeName);
            } else {
              print("here");
              Consumer<OrderRequests>(builder: (context, data, child) {
                print(data);
                if (data is Loading) {
                  return LoadingPage();
                } else if (data is Error) {
                  return ErrorPage(routeName: WaiterHomeScreen.routeName);
                } else if (data is OrderRequests) {
                  final orderList = data;
                  if (_viewState == ViewState.Loading)
                    return LoadingPage();
                  else
                    return SafeArea(
                      child: Scaffold(
                        appBar: AppBar(
                          title: Text('Awaiting Customers'),
                        ),
                        body: Text("Hello")

                        // ListView.separated(
                        //     separatorBuilder: (context, index) => Divider(
                        //           color: Colors.black,
                        //         ),
                        //     itemCount: orderList,
                        //     itemBuilder: (BuildContext context, int index) {
                        //       OrderDoc order = orderList.elementAt(index);
                        //       return new Column(
                        //         children: <Widget>[
                        //           new ListTile(
                        //             enabled:
                        //                 order.orderStatus == 0 ? true : false,
                        //             onTap: () {
                        //               // UserService().getWaiterOrders(widget.waiter.id);
                        //             },
                        //             leading: ClipOval(
                        //               child: CachedNetworkImage(
                        //                 imageUrl: "",
                        //                 placeholder: (context, url) =>
                        //                     new CircularProgressIndicator(),
                        //                 errorWidget: (context, url, error) =>
                        //                     new Icon(Icons.error),
                        //               ),
                        //             ),
                        //             title: new Text(order.displayName),
                        //             subtitle: Text(
                        //                 "Requested at : ${order.waiterRequestTime.toString()}"),
                        //           ),
                        //         ],
                        //       );
                        //     })

                        ,
                      ),
                    );
                } else {
                  print('cart page consumer cart items error');
                  return Container(height: 0, width: 0);
                }
              });

              print('cart page consumer cart items error');
              return Container(height: 0, width: 0);
            }
          }),
        ),
      ),
    );
  }
}
