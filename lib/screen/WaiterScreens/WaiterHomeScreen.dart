import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:freemeals/enums/connectivity_status.dart';
import 'package:freemeals/models/order_model.dart';
import 'package:freemeals/models/user_model.dart';
import 'package:freemeals/providers/waiter_selection_provider.dart';
import 'package:freemeals/services/user_service.dart';
import 'package:freemeals/widgets/app_wide/app_wide/error_connection_page.dart';
import 'package:provider/provider.dart';
import 'package:freemeals/services/connectivity_service.dart';

class WaiterHomeScreen extends StatefulWidget {
  static String routeName = '/waiter-home-screen';
  @override
  _WaiterHomeScreenState createState() => _WaiterHomeScreenState();
}

class _WaiterHomeScreenState extends State<WaiterHomeScreen> {
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
        ],
                child: Consumer<ConnectivityStatus>(
                    // ignore: missing_return
                    builder: (ctx, connectionStatus, ch) {
                  if (connectionStatus == ConnectivityStatus.None) {
                    ErrorConnectionPage(routeName: WaiterHomeScreen.routeName);
                  } else {
                    final waiterProvider = Provider.of<WaiterProvider>(context);
                    waiterProvider.getWaitersOrders("BXO9L4PwBrMHTCK3z6yhNjfPHsG3");
                    List<OrderDoc> selectedWaiter = waiterProvider.orders;
                    return SafeArea(
                      child: Scaffold(
                        appBar: AppBar(
                          title: Text('Awaiting Customers'),
                        ),
                        body: ListView.separated(
                            separatorBuilder: (context, index) => Divider(
                                  color: Colors.black,
                                ),
                            itemCount: selectedWaiter.length,
                            itemBuilder: (BuildContext context, int index) {
                              OrderDoc order = selectedWaiter.elementAt(index);
                              return new Column(
                                children: <Widget>[
                                  new ListTile(
                                    enabled:
                                        order.orderStatus == 0 ? true : false,
                                    onTap: () {
                                      // UserService().getWaiterOrders(widget.waiter.id);
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
                                        "Requested at : ${order.waiterRequestTime.toString()}"),
                                  ),
                                ],
                              );
                            }),
                      ),
                    );
                  }
                }))));
  }
}
