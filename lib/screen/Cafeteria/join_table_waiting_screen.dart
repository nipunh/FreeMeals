import 'package:flutter/material.dart';
import 'package:freemeals/models/order_model.dart';
import 'package:freemeals/services/order_service.dart';
import 'package:freemeals/widgets/app_wide/app_wide/error_page.dart';
import 'package:freemeals/widgets/app_wide/app_wide/loading_page.dart';

class JoinTableWaitingScreen extends StatefulWidget {
  final String orderId;

  const JoinTableWaitingScreen(
      {@required this.orderId});

  @override
  State<JoinTableWaitingScreen> createState() => _JoinTableWaitingScreenState();
}

class _JoinTableWaitingScreenState extends State<JoinTableWaitingScreen> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: OrderService().getOngoingOrder(widget.orderId),
        builder: (ctx, orderSnapshot) {
          if (orderSnapshot.connectionState == ConnectionState.waiting) {
            return LoadingPage();
          } else {
            if (orderSnapshot.hasData) {
              
              OrderDoc data = orderSnapshot.data;
              
              if(data.userList.contains("userId")){
                return Container(
                  child:  Center(child: Text("Waiting")),
                );
              }else{
                return ErrorPage();
              }
            }
            return ErrorPage();
          }
        });
  }
}
