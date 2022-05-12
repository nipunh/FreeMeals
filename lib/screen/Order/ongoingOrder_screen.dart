import 'package:flutter/material.dart';

class OngoingOrder extends StatefulWidget {
  // const OngoingOrder({ Key? key }) : super(key: key);

  @override
  State<OngoingOrder> createState() => _OngoingOrderState();
}

class _OngoingOrderState extends State<OngoingOrder> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(child: Text("Ongoing Order")),
    );
  }
}