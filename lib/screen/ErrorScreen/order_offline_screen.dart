import 'package:flutter/material.dart';
// import 'package:platos_client_app/models/order_model.dart';
// import 'package:platos_client_app/services/database_helper.dart';
// import 'package:platos_client_app/widgets/app_wide/error_page.dart';
// import 'package:platos_client_app/widgets/app_wide/loading_page.dart';
// import 'package:platos_client_app/services/order_service.dart';
// import 'package:platos_client_app/services/device_service.dart';
// import 'package:platos_client_app/widgets/orders/order_item_details_offline_first.dart';
// import 'package:platos_client_app/widgets/orders/order_item_details_offline_second.dart';
// import 'package:platos_client_app/widgets/orders/order_item_details_offline_third.dart';

class OrderOfflineScreen extends StatelessWidget {
  static const routeName = '/order-offline';

  const OrderOfflineScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold()
    );
//     return FutureBuilder(
//         future: DatabaseHelper().getOfflineOrders(),
//         builder: (ctx, snapshot) {
//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return LoadingPage();
//           } else if (snapshot.hasError) {
//             print(snapshot.error);
//             return ErrorPage();
//           } else if (snapshot.hasData) {
//             final List<OfflineOrder> orders = snapshot.data;

//             return SafeArea(
//               child: Scaffold(
//                 appBar: AppBar(
//                   title: Text('Orders (Offline Mode)'),
//                 ),
//                 body: ListView(
//                   children: [
//                     ListView.builder(
//                       shrinkWrap: true,
//                       physics: NeverScrollableScrollPhysics(),
//                       itemCount: orders.length,
//                       itemBuilder: (ctx, i) => _OrderItemDetails(orders[i]),
//                     ),
//                   ],
//                 ),
//               ),
//             );
//           } else {
//             print('future offline order page error');
//             return Container(
//               height: 0,
//               width: 0,
//             );
//           }
//         });
//   }
// }

// class _OrderItemDetails extends StatelessWidget {
//   final OfflineOrder order;

//   _OrderItemDetails(this.order);

//   @override
//   Widget build(BuildContext context) {
//     bool isTab = DeviceService().isTablet(context);
//     final orderService = OrdersService();
//     var orderItems = orderService.offlineOrderItemsList(order.items);
//     return Container(
//         child: Column(
//       mainAxisAlignment: MainAxisAlignment.start,
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: <Widget>[
//         OrderItemDetailsOfflineFirst(order: order),
//         SizedBox(height: !isTab ? 15 : 20),
//         OrderItemDetailsOfflineSecond(order: order, orderItems: orderItems),
//         !isTab ? SizedBox(height: 6) : SizedBox(height: 10),
//         Divider(),
//         OrderItemDetailsOfflineThird(
//             order: order, isTab: isTab, orderService: orderService),
//         Divider(thickness: 5),
//       ],
//     ));
//   }
}
}
