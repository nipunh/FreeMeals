import 'package:flutter/material.dart';
import 'package:freemeals/screen/ManagerScreens/OrderHistory.dart';
import 'package:freemeals/screen/ManagerScreens/TableBookingHistory.dart';
import 'package:freemeals/screen/ManagerScreens/TableBookingRequest.dart';

class ManagerDrawer extends StatefulWidget {
  // const ManagerDrawer({ Key? key }) : super(key: key);

  @override
  State<ManagerDrawer> createState() => _ManagerDrawerState();
}

class _ManagerDrawerState extends State<ManagerDrawer> {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      // Add a ListView to the drawer. This ensures the user can scroll
      // through the options in the drawer if there isn't enough vertical
      // space to fit everything.
      child: ListView(
        // Important: Remove any padding from the ListView.
        padding: EdgeInsets.zero,
        children: [
          const DrawerHeader(
            decoration: BoxDecoration(
              color: Colors.blue,
            ),
            child: Text('Manager Name', style: TextStyle(  ),),
          ),
          ListTile(
            title: const Text('Table Booking Request'),
            onTap: () {
              Navigator.push(
                  context,
                  new MaterialPageRoute(
                      builder: (context) => new TableBookingRequest()));
            },
          ),
          ListTile(
            title: const Text('Table Booking History'),
            onTap: () {
              Navigator.push(
                  context,
                  new MaterialPageRoute(
                      builder: (context) => new TableBookingHistory()));
            },
          ),
          ListTile(
            title: const Text('Orders'),
            onTap: () {
              Navigator.push(
                  context,
                  new MaterialPageRoute(
                      builder: (context) => new OrderHistory()));
            },
          ),
        ],
      ),
    );
  }
}
