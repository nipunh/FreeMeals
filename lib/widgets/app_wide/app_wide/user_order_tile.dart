import 'package:flutter/material.dart';
import 'package:freemeals/constants/order_constants.dart';
import 'package:freemeals/models/user_orderDetails.dart';
import 'package:freemeals/services/order_service.dart';

class UserOrderTile extends StatelessWidget {
  final UserOrderDetail user;
  final String orderId;

  const UserOrderTile({this.user, this.orderId});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 200,
      child: Card(
          clipBehavior: Clip.antiAlias,
          child: Column(children: [
            ListTile(
              leading: Icon(Icons.person),
              title: Text('${user.displayName}'),
              // subtitle: Text(
              //   'Secondary Text',
              //   style: TextStyle(color: Colors.black.withOpacity(0.6)),
              // ),
            ),
            Expanded(
              child: ListView.builder(
                  physics: NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: user.items.length,
                  itemBuilder: (BuildContext context, int index) {
                    return Dismissible(
                        key: ValueKey(user.items[index]),
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
                            OrderService().orderItemStatusUpdate(orderId,
                                user.userId, user.items[index]["id"], "next");
                          }

                          if (direction == DismissDirection.startToEnd) {
                            print("cancel");
                            OrderService().orderItemStatusUpdate(orderId,
                                user.userId, user.items[index]["id"], "prev");
                          }
                        },
                        child: ListTile(
                          leading: Text('${user.items[index]["title"]}'),
                          title: Text('${user.items[index]["quantity"]}'),
                          trailing: Text(
                              '${OrderDecrypt.cookingStatus[user.items[index]["status"]]}'),
                        ));
                  }),
            )
          ])),
    );
  }
}
