import 'package:flutter/material.dart';

class TableBookingRequest extends StatefulWidget {
  // const OrderRequest({ Key? key }) : super(key: key);

  @override
  State<TableBookingRequest> createState() => _TableBookingRequestState();
}

class _TableBookingRequestState extends State<TableBookingRequest> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Table Booking Request"),
      ),
    );
  }
}
