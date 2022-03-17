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

    @override
  void initState() {
    slots = [...widget.slotTimes];
    slots.insert(0, SlotTime(slot: '', seats: 1));
    slots.insert(
        1,
        SlotTime(
            slot: 'Not Required-Selected a slot on a previous order',
            seats: 1));

    slot = slots.first;
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

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
          Row(
            children: <Widget>[
              DropdownButtonFormField<SlotTime>(
                decoration: InputDecoration(
                  floatingLabelBehavior: FloatingLabelBehavior.always,
                  fillColor: Colors.blue,
                  labelText: 'Select Time Slot',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                isExpanded: true,
                isDense: true,
                value: slot,
                onChanged: (SlotTime value) {
                  setState(() {
                    slot = value;
                  });
                },
                items: slots
                    .map(
                      (SlotTime value) => DropdownMenuItem<SlotTime>(
                        child: FittedBox(
                          fit: BoxFit.fitWidth,
                          child: RichText(
                            text: TextSpan(
                                // style: DefaultTextStyle.of(context).style,
                                children: [
                                  if (value.slot == '')
                                    TextSpan(
                                      text: value.slot + ' ',
                                      style: TextStyle(
                                        fontSize: !isTab
                                            ? Theme.of(context)
                                                .textTheme
                                                .caption
                                                .fontSize
                                            : Theme.of(context)
                                                .textTheme
                                                .bodyText2
                                                .fontSize,
                                      ),
                                    ),
                                  if (value.slot ==
                                      'Not Required-Selected a slot on a previous order')
                                    TextSpan(
                                      text: "Not Required ",
                                      style: TextStyle(
                                          fontSize: !isTab
                                              ? Theme.of(context)
                                                  .textTheme
                                                  .caption
                                                  .fontSize
                                              : Theme.of(context)
                                                  .textTheme
                                                  .bodyText2
                                                  .fontSize,
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  if (value.slot ==
                                      'Not Required-Selected a slot on a previous order')
                                    TextSpan(
                                      text:
                                          '- Selected a slot on a previous order' +
                                              ' ',
                                      style: TextStyle(
                                        fontSize: !isTab
                                            ? Theme.of(context)
                                                .textTheme
                                                .caption
                                                .fontSize
                                            : Theme.of(context)
                                                .textTheme
                                                .bodyText2
                                                .fontSize,
                                        color: Colors.black,
                                        //fontStyle: FontStyle.italic,
                                      ),
                                    ),
                                  if (value.slot != '' &&
                                      value.slot !=
                                          'Not Required-Selected a slot on a previous order')
                                    TextSpan(
                                      text: value.slot,
                                      style: TextStyle(
                                        fontStyle: FontStyle.normal,
                                        fontSize: !isTab
                                            ? Theme.of(context)
                                                .textTheme
                                                .caption
                                                .fontSize
                                            : Theme.of(context)
                                                .textTheme
                                                .bodyText2
                                                .fontSize,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black,
                                      ),
                                    ),
                                  if (value.slot != '' &&
                                      value.slot !=
                                          'Not Required-Selected a slot on a previous order')
                                    TextSpan(
                                      text: ' - ',
                                      style: TextStyle(
                                        fontStyle: FontStyle.normal,
                                        fontSize: !isTab
                                            ? Theme.of(context)
                                                .textTheme
                                                .caption
                                                .fontSize
                                            : Theme.of(context)
                                                .textTheme
                                                .bodyText2
                                                .fontSize,
                                        color: Colors.black,
                                      ),
                                    ),
                                  if (value.slot != '' &&
                                      value.slot !=
                                          'Not Required-Selected a slot on a previous order')
                                    TextSpan(
                                      text: value.seats.toString(),
                                      style: TextStyle(
                                        color: Colors.green[700],
                                        fontStyle: FontStyle.normal,
                                        fontSize: !isTab
                                            ? Theme.of(context)
                                                .textTheme
                                                .caption
                                                .fontSize
                                            : Theme.of(context)
                                                .textTheme
                                                .bodyText2
                                                .fontSize,
                                      ),
                                    ),
                                  if (value.slot != '' &&
                                      value.slot !=
                                          'Not Required-Selected a slot on a previous order')
                                    TextSpan(
                                      text: ' seats remaining ',
                                      style: TextStyle(
                                        fontStyle: FontStyle.normal,
                                        fontSize: !isTab
                                            ? Theme.of(context)
                                                .textTheme
                                                .caption
                                                .fontSize
                                            : Theme.of(context)
                                                .textTheme
                                                .bodyText2
                                                .fontSize,
                                        color: Colors.black,
                                      ),
                                    ),
                                  if (value.slot != '' && slot == value)
                                    WidgetSpan(
                                      child: Icon(
                                        Icons.check_circle,
                                        color: Colors.green,
                                        size: !isTab ? 20 : 30,
                                      ),
                                    )
                                ]),
                          ),
                        ),
                        value: value,
                      ),
                    )
                    .toList(),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
