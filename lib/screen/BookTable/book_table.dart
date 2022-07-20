import 'package:flutter/material.dart';
import 'package:freemeals/models/bookeingRequest_model.dart';
import 'package:freemeals/models/cafe_model.dart';
import 'package:freemeals/models/slot_times_model.dart';
import 'package:freemeals/models/user_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:freemeals/screen/Authentication/auth_screen.dart';
import 'package:freemeals/screen/BookTable/BookingConfirmation_Screen.dart';
import 'package:freemeals/services/bookTable_services.dart';
import 'package:freemeals/services/device_service.dart';
import 'package:freemeals/services/notification_service.dart';
import 'package:freemeals/widgets/app_wide/app_wide/NavigationBar.dart';
import 'package:intl/intl.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

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
  List<Map<String, int>> slots = [
    {'10:00': 10},
    {'10:30': 20},
    {'11:00': 10},
    {'11:30': 15},
    {'12:00': 10},
    {'12:30': 15},
    {'13:00': 30},
    {'13:30': 15},
    {'14:00': 10},
    {'14:30': 30},
    {'15:00': 10},
    {'15:30': 10},
    {'16:00': 10},
    {'16:30': 20},
    {'17:00': 10},
    {'17:30': 10},
    {'18:00': 10},
    {'18:30': 15},
    {'19:00': 10},
    {'19:30': 15},
    {'20:00': 30},
    {'20:30': 15},
    {'21:00': 30},
    {'21:30': 15},
    {'22:00': 10},
  ];

  List<Map<String, int>> slotList;

  SlotTime slot;
  DateTime _date = DateTime.now();
  int _party;

  DateTime selectedTimeSlot;
  DateTime selectedDate;

  void _selectDate() async {
    final DateTime newDate = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime.now(),
      lastDate: DateTime(2022, 7),
      helpText: 'Select a date',
    );

    if (newDate != null) {
      setState(() {
        selectedDate = newDate;
      });
    }
  }

  DateTime nextTimeSlot() {
    DateTime currDateTime = DateTime.now();
    int remainingMinutes = currDateTime.minute > 30
        ? 60 - currDateTime.minute
        : 30 - currDateTime.minute;

    currDateTime = currDateTime.add(Duration(minutes: remainingMinutes));

    return currDateTime;
  }

  void updateSelectedSlot(String updatedVal, bool update) {
    if (selectedDate.compareTo(DateTime.now()) <= 0
        ? int.parse(updatedVal.split(":")[0]) > DateTime.now().hour
        : true) {
      setState(() {
        selectedTimeSlot = new DateTime(
            selectedDate.year,
            selectedDate.month,
            selectedDate.day,
            int.parse(updatedVal.split(":")[0]),
            int.parse(updatedVal.split(":")[1]),
            0,
            0,
            0);

        if (update)
          slotList = slots
              .where((s) =>
                  selectedTimeSlot.hour - 3 <
                      int.parse(s.keys.first.split(":").first) &&
                  int.parse(s.keys.first.split(":").first) <
                      selectedTimeSlot.hour + 3)
              .toList();
      });
    }
  }

  void updateParty(int people) {
    setState(() {
      _party = people;
    });
  }

  @override
  void initState() {
    super.initState();
    selectedTimeSlot = nextTimeSlot();
    selectedDate = DateTime.now().hour > 22
        ? DateTime(_date.year, _date.month, _date.day + 1, 10)
        : DateTime.now();
    _party = 1;

    slotList = slots
        .where((s) =>
            selectedDate.hour - 2 < int.parse(s.keys.first.split(":").first) &&
            int.parse(s.keys.first.split(":").first) < selectedDate.hour + 3)
        .toList();
  }

  // @override
  // void dispose() {
  //   super.dispose();
  // }

  @override
  Widget build(BuildContext context) {
    final notificationService = NotificationService();
    User user = FirebaseAuth.instance.currentUser;

    // final localdb = DatabaseHelper();
    // final cartContainer = Provider.of<CartProvider>(context, listen: false);
    final isTab = DeviceService().isTablet(context);
    var size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 60,
        centerTitle: true,
        backgroundColor: Colors.transparent,
        title: RichText(
            textAlign: TextAlign.center,
            text: TextSpan(children: [
              TextSpan(
                  text: "Deli Planet",
                  style: TextStyle(fontSize: 20, color: Colors.black)),
            ])),
      ),
      bottomNavigationBar: Container(
          margin: EdgeInsets.all(8.0), child: NavBar(context: context)),
      body: Container(
        decoration: BoxDecoration(
          color: Colors.grey[200],
        ),
        child: Column(mainAxisAlignment: MainAxisAlignment.start, children: <
            Widget>[
          Container(
            padding: EdgeInsets.only(bottom: 15),
            decoration: BoxDecoration(
              color: Colors.white,
            ),
            child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                      padding: EdgeInsets.only(right: 7.5),
                      margin: EdgeInsets.all(0),
                      child: Stack(
                        alignment: Alignment.center,
                        // ignore: deprecated_member_use
                        // overflow: Overflow.visible,
                        children: <Widget>[
                          new Positioned(
                            left: -5,
                            top: -7.5,
                            child: Icon(
                              Icons.check_circle_rounded,
                              size: 45,
                              color: Colors.grey[200],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 38.0),
                            child: Text("7th Meal Free",
                                style: TextStyle(
                                  color: Colors.white,
                                )),
                          )
                        ],
                      ),
                      height: 35,
                      width: 160,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(20)),
                        border: Border.all(
                          width: 2,
                          color: Colors.white,
                        ),
                        color: Color.fromRGBO(132, 82, 161, 1),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.5),
                            spreadRadius: 2,
                            blurRadius: 5,
                            offset: Offset(0, 3), // changes position of shadow
                          ),
                        ],
                      )),
                ]),
          ),
          Container(
            margin: EdgeInsets.only(top: 10),
            color: Colors.white,
            child: Padding(
              padding: const EdgeInsets.only(top: 18.0),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text("Party"),
                          Container(
                            height: 40,
                            width: 70,
                            margin: EdgeInsets.only(top: 7.5),
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              color: Colors
                                  .white, //background color of dropdown button
                              border: Border.all(
                                  color: Colors.black38,
                                  width: 1), //border of dropdown button
                              borderRadius: BorderRadius.circular(
                                  20), //border raiuds of dropdown button
                              boxShadow: <BoxShadow>[
                                //apply shadow on Dropdown button
                                BoxShadow(
                                    color: Color.fromRGBO(
                                        0, 0, 0, 0.57), //shadow for button
                                    blurRadius: 5) //blur radius of shadow
                              ],
                            ),
                            child: DropdownButton<int>(
                              hint: Text(1.toString()),
                              elevation: 20,
                              value: _party,
                              items: <int>[1, 2, 3, 4, 5, 6, 7, 8, 9, 10]
                                  .map((int value) {
                                return DropdownMenuItem<int>(
                                  value: value,
                                  child: new Text(value.toString()),
                                );
                              }).toList(),
                              onChanged: (newVal) {
                                updateParty(newVal);
                              },
                            ),
                          )
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text("Date"),
                          Container(
                            height: 40,
                            width: 180,
                            margin: EdgeInsets.only(top: 7.5),
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              color: Colors
                                  .white, //background color of dropdown button
                              border: Border.all(
                                  color: Colors.black38,
                                  width: 1), //border of dropdown button
                              borderRadius: BorderRadius.circular(
                                  20), //border raiuds of dropdown button
                              boxShadow: <BoxShadow>[
                                //apply shadow on Dropdown button
                                BoxShadow(
                                    color: Color.fromRGBO(
                                        0, 0, 0, 0.57), //shadow for button
                                    blurRadius: 5) //blur radius of shadow
                              ],
                            ),
                            child: TextButton(
                              style: ButtonStyle(
                                  backgroundColor:
                                      MaterialStateProperty.all(Colors.white),
                                  shadowColor:
                                      MaterialStateProperty.all(Colors.black),
                                  alignment: Alignment.center,
                                  shape: MaterialStateProperty.all<
                                          RoundedRectangleBorder>(
                                      RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(18.0),
                                  ))),
                              onPressed: _selectDate,
                              child: Row(children: [
                                Text(
                                  DateFormat.EEEE().format(selectedDate) +
                                      " , " +
                                      DateFormat.MMMMd().format(selectedDate),
                                  style: TextStyle(color: Colors.black54),
                                ),
                                Icon(Icons.arrow_drop_down_sharp,
                                    color: Colors.black54)
                              ]),
                            ),
                          ),
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text("Time"),
                          Container(
                            height: 40,
                            width: 80,
                            margin: EdgeInsets.only(top: 7.5),
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              color: Colors
                                  .white, //background color of dropdown button
                              border: Border.all(
                                  color: Colors.black38,
                                  width: 1), //border of dropdown button
                              borderRadius: BorderRadius.circular(
                                  20), //border raiuds of dropdown button
                              boxShadow: <BoxShadow>[
                                //apply shadow on Dropdown button
                                BoxShadow(
                                    color: Color.fromRGBO(
                                        0, 0, 0, 0.57), //shadow for button
                                    blurRadius: 5) //blur radius of shadow
                              ],
                            ),
                            child: DropdownButton<String>(
                              hint: Text(
                                  DateFormat.Hm().format(selectedTimeSlot)),
                              items: slots.map((val) {
                                var index = slots.indexOf(val);
                                return DropdownMenuItem<String>(
                                  value: slots[index].keys.first ??
                                      DateFormat.Hm().format(selectedTimeSlot),
                                  child: Text(
                                    slots[index].keys.first.toString(),
                                    style: TextStyle(
                                        color: int.parse(slots[index]
                                                        .keys
                                                        .first
                                                        .split(":")
                                                        .first) <
                                                    DateTime.now().hour &&
                                                selectedDate.compareTo(
                                                        DateTime.now()) <=
                                                    0
                                            ? Colors.grey
                                            : Colors.black),
                                  ),
                                );
                              }).toList(),
                              onChanged: (newVal) {
                                updateSelectedSlot(newVal, true);
                              },
                            ),
                          ),
                        ],
                      ),
                    ]),
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.only(top: 10),
            color: Colors.white,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(8.0, 20, 8.0, 8.0),
              child: Row(children: [
                Column(children: <Widget>[
                  Text(
                    "Please select the time slot",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                  ),
                  Divider(),
                  Container(
                    padding: EdgeInsets.all(8.0),
                    width: size.width * 0.95,
                    height: size.height * 0.40,
                    child: GridView.count(
                        padding: const EdgeInsets.all(4.0),
                        crossAxisCount: 3,
                        mainAxisSpacing: 20,
                        crossAxisSpacing: 12,
                        childAspectRatio: 2,
                        children: List.generate(slotList.length, (index) {
                          return SizedBox(
                            child: GestureDetector(
                                onTap: () => updateSelectedSlot(
                                    slotList[index].keys.first, false),
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    shape: new RoundedRectangleBorder(
                                      borderRadius:
                                          new BorderRadius.circular(30.0),
                                    ),
                                    primary: int.parse(slotList[index]
                                                    .keys
                                                    .first
                                                    .split(":")
                                                    .first) <
                                                DateTime.now().hour &&
                                            selectedDate.compareTo(
                                                    DateTime.now()) <=
                                                0
                                        ? Colors.grey
                                        : slotList[index].keys.first ==
                                                (selectedTimeSlot.hour)
                                                        .toString() +
                                                    ":" +
                                                    (selectedTimeSlot.minute)
                                                        .toString()
                                            ? Colors.white
                                            : Color.fromRGBO(132, 82, 161, 1),
                                  ),
                                  onPressed: () {
                                    updateSelectedSlot(
                                        slotList[index].keys.first, false);
                                  },
                                  child: Text(slotList[index].keys.first,
                                      style: TextStyle(
                                          color: slotList[index].keys.first ==
                                                  (selectedTimeSlot.hour)
                                                          .toString() +
                                                      ":" +
                                                      (selectedTimeSlot.minute)
                                                          .toString()
                                              ? Color.fromRGBO(132, 82, 161, 1)
                                              : Colors.white)),
                                )),
                          );
                        })),
                  ),
                  SizedBox(
                      width: size.width * 0.95,
                      child: ElevatedButton(
                          style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all(
                                Color.fromRGBO(132, 82, 161, 1),
                              ),
                              shape: MaterialStateProperty.all<
                                      RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(18.0),
                                // side: BorderSide(color: Colors.red)
                              ))),
                          child: Text(
                            "Book Table",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                            ),
                          ),
                          onPressed: (() => showAlertDialog(context, user)))),
                ])
              ]),
            ),
          ),
        ]),
      ),
    );
  }

  showAlertDialog(BuildContext context, User user) {
    Widget cancelButton = TextButton(
      child: Text("No",
          style: const TextStyle(
            color: Color.fromRGBO(132, 82, 161, 1),
          )),
      onPressed: () {
        Navigator.of(context).pop();
      },
    );

    Widget continueButton = TextButton(
        child: Text("Yes",
            style: const TextStyle(
              color: Color.fromRGBO(132, 82, 161, 1),
            )),
        onPressed: () async {
          if (user != null) {
            String bookingId;
            bookingId = await BookTableService().registerTable(
                "CXdKnqsdwetprt885KVx",
                selectedDate,
                _party,
                selectedTimeSlot,
                user);

            BookTableService().getBookingDetails(bookingId).then((bookingDoc) {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          BookingConfirmationScreen(booking: bookingDoc)));
            });

            Navigator.of(context).pop();
          } else {
            Navigator.push(
                context, MaterialPageRoute(builder: (context) => AuthScreen()));
          }
        });

    AlertDialog alert = AlertDialog(
      title: Text("Booking Confirmation"),
      content: RichText(
          text: TextSpan(
              text:
                  "Party : $_party \n\nBooking Date : ${selectedDate.day}/${selectedDate.month}/${selectedDate.year} \n\nBooking Time : ${selectedTimeSlot.hour}:${selectedTimeSlot.minute}",
              style: const TextStyle(
                color: Colors.black,
              ))),
      actions: [cancelButton, continueButton],
    );

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }
}
