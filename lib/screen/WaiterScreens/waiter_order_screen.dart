import 'package:flutter/material.dart';
import 'package:freemeals/constants/order_constants.dart';
import 'package:freemeals/models/order_model.dart';
import 'package:freemeals/models/user_orderDetails.dart';
import 'package:freemeals/widgets/app_wide/app_wide/user_reques_tile.dart';

class WaiterOrderScreen extends StatefulWidget {
  final OrderDoc orderdata;

  const WaiterOrderScreen({this.orderdata});

  @override
  State<WaiterOrderScreen> createState() => _WaiterOrderScreenState();
}

class _WaiterOrderScreenState extends State<WaiterOrderScreen> {
  @override
  Widget build(BuildContext context) {
    List<UserOrderDetail> userList = widget.orderdata.userList;
    List<UserOrderDetail> userWaitingList;
    List<UserOrderDetail> userJoinedList;
    List<UserOrderDetail> userCancelledList;
    if (userList.length > 0) {
      userWaitingList =
          userList.where((element) => element.status == 0).toList();
      userJoinedList =
          userList.where((element) => element.status == 1).toList();
      userCancelledList =
          userList.where((element) => element.status == 2).toList();
    }
    return Container(
        child: Column(children: [
      Container(
          margin: EdgeInsets.all(10.0),
          padding: EdgeInsets.all(14.0),
          decoration: BoxDecoration(
              color: Colors.green[100],
              borderRadius: BorderRadius.all(Radius.circular(20)),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.5),
                  spreadRadius: 2,
                  blurRadius: 5,
                  offset: Offset(0, 3), // changes position of shadow
                ),
              ]),
          child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  "User Details",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                Divider(),
                Text(
                  "Customer : " + widget.orderdata.displayName,
                  style: TextStyle(color: Colors.black87),
                ),
                Text(
                  "Party : " + widget.orderdata.numberOfCustomers.toString(),
                  style: TextStyle(color: Colors.black87),
                ),
                Text(
                  "Order Status : " +
                      OrderDecrypt.orderStaus[widget.orderdata.orderStatus],
                  style: TextStyle(color: Colors.black87),
                ),
              ])),
      Container(
          margin: EdgeInsets.all(10.0),
          padding: EdgeInsets.all(14.0),
          decoration: BoxDecoration(
              color: Colors.green[100],
              borderRadius: BorderRadius.all(Radius.circular(20)),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.5),
                  spreadRadius: 2,
                  blurRadius: 5,
                  offset: Offset(0, 3), // changes position of shadow
                ),
              ]),
          child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  "User Waiting to join",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                Divider(),
                SizedBox(
                  height: 100,
                  child: ListView.builder(
                      physics: NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: userWaitingList.length,
                      itemBuilder: (BuildContext context, int index) {
                        return UserRequestTile(
                          id: userWaitingList[index].userId,
                          guestName: userWaitingList[index].displayName,
                          orderId: widget.orderdata.id,
                        );
                      }),
                )
              ])),
      Container(
          margin: EdgeInsets.all(10.0),
          padding: EdgeInsets.all(14.0),
          decoration: BoxDecoration(
              color: Colors.green[100],
              borderRadius: BorderRadius.all(Radius.circular(20)),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.5),
                  spreadRadius: 2,
                  blurRadius: 5,
                  offset: Offset(0, 3), // changes position of shadow
                ),
              ]),
          child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  "Joined User",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                Divider(),
                SizedBox(
                  height: 200,
                  child: ListView.builder(
                      physics: NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: userJoinedList.length,
                      itemBuilder: (BuildContext context, int index) {
                        return UserRequestTile(
                          id: userJoinedList[index].userId,
                          guestName: userJoinedList[index].displayName,
                          orderId: widget.orderdata.id,
                        );
                      }),
                )
              ])),
      Container(
          margin: EdgeInsets.all(10.0),
          padding: EdgeInsets.all(14.0),
          decoration: BoxDecoration(
              color: Colors.green[100],
              borderRadius: BorderRadius.all(Radius.circular(20)),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.5),
                  spreadRadius: 2,
                  blurRadius: 5,
                  offset: Offset(0, 3), // changes position of shadow
                ),
              ]),
          child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  "Rejected User",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                Divider(),
                SizedBox(
                  height: 200,
                  child: ListView.builder(
                      physics: NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: userCancelledList.length,
                      itemBuilder: (BuildContext context, int index) {
                        return UserRequestTile(
                          id: userCancelledList[index].userId,
                          guestName: userCancelledList[index].displayName,
                          orderId: widget.orderdata.id,
                        );
                      }),
                )
              ]))
    ]));
  }
}
