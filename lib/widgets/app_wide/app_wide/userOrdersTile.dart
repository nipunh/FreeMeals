import 'package:flutter/material.dart';
import 'package:freemeals/models/user_orderDetails.dart';
import 'package:freemeals/services/order_service.dart';
import 'package:freemeals/services/user_service.dart';

class UserOrderstTile extends StatelessWidget {
  final String id;
  final String orderId;
  final String guestName;
  final UserOrderDetail orderDetail;

  UserOrderstTile({
    @required this.id,
    @required this.guestName,
    @required this.orderId,
    @required this.orderDetail
  });

  @override
  Widget build(BuildContext context) {
    return 
    Dismissible(
      key: ValueKey(id),
      background: Container(
          color: Colors.red,
          padding: EdgeInsets.only(left: 10),
          child: Icon(
            Icons.cancel_outlined,
            size: 40,
            color: Colors.white,
          ),
          alignment: Alignment.centerLeft,
          margin: EdgeInsets.all(4.0)),
      secondaryBackground: Container(
          color: Colors.green[400],
          padding: EdgeInsets.only(right: 10),
          child: Icon(
            Icons.check_circle_outline,
            size: 40,
            color: Colors.white,
          ),
          alignment: Alignment.centerRight,
          margin: EdgeInsets.all(4.0)),
      onDismissed: (direction) {
        if (direction == DismissDirection.endToStart) {
          print("accept");
          OrderService().acceptRejectUserToOrder(id, orderId, 1);
        }

        if (direction == DismissDirection.startToEnd) {
          print("cancel");
          OrderService().acceptRejectUserToOrder(id, orderId, 2);
        }
        // Provider.of<Cart>(context, listen: false).removeItem(productId);
      },
      child: Container(
        margin: EdgeInsets.all(5),
        decoration: BoxDecoration(
            color: Colors.white60,
            borderRadius: BorderRadius.all(Radius.circular(20)),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.5),
                spreadRadius: 2,
                blurRadius: 5,
                offset: Offset(0, 3), // changes position of shadow
              ),
            ]),
        child: ListTile(
          title: Text("Guest Name: $guestName"),
          
        ),
      ),
    );
  }
}
