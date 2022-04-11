import 'package:flutter/material.dart';

class TableBookingHistory extends StatefulWidget {
  // const OrderHistory({ Key? key }) : super(key: key);

  @override
  State<TableBookingHistory> createState() => _TableBookingHistoryState();
}

class _TableBookingHistoryState extends State<TableBookingHistory> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Table Booking History"),
      ),
    );
  }
}