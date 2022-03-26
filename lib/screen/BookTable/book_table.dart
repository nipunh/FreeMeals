import 'package:flutter/material.dart';
import 'package:freemeals/models/cafe_model.dart';
import 'package:freemeals/models/slot_times_model.dart';
import 'package:freemeals/models/user_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:freemeals/services/device_service.dart';
import 'package:freemeals/services/notification_service.dart';

class BookTable extends StatefulWidget {
  final User user;
  final UserDoc userData;
  final Cafeteria cafe;
  final List<SlotTime> slotTimes;

  const BookTable(
      {Key key, this.user, this.userData, this.slotTimes, this.cafe})
      : super(key: key);

  @override
  State<BookTable> createState() => _BookTableState();
}

class _BookTableState extends State<BookTable> {
  List<SlotTime> slots = [];
  SlotTime slot;

  // @override
  // void initState() {
  //   slots = [...widget.slotTimes];
  //   slots.insert(0, SlotTime(slot: '', seats: 1));
  //   slots.insert(1,SlotTime(
  //       slot: 'Not Required-Selected a slot on a previous order',
  //       seats: 1));

  //   slot = slots.first;
  //   super.initState();
  // }

  // @override
  // void dispose() {
  //   super.dispose();
  // }

  @override
  Widget build(BuildContext context) {
    final notificationService = NotificationService();
    // final localdb = DatabaseHelper();
    // final cartContainer = Provider.of<CartProvider>(context, listen: false);
    final isTab = DeviceService().isTablet(context);

    return Scaffold(
      appBar: AppBar(
        title: Text("Book Table"),
      ),
      body: Column(
        children: <Widget>[
          Row(children: <Widget>[
            DropdownButton<int>(
              items: <int>[1, 2, 3, 4, 5, 6, 7, 8, 9, 10].map((int value) {
                return DropdownMenuItem<int>(
                  value: value,
                  child: Text(value.toString()),
                );
              }).toList(),
              onChanged: (_) {},
            ),
            
          ]),
        ],
      ),
    );
  }
}
