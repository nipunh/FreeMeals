import 'package:flutter/material.dart';
import 'package:freemeals/models/cafe_model.dart';
import 'package:freemeals/models/slot_times_model.dart';
import 'package:freemeals/models/user_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:freemeals/screen/Authentication/auth_screen.dart';
import 'package:freemeals/services/bookTable_services.dart';
import 'package:freemeals/services/device_service.dart';
import 'package:freemeals/services/notification_service.dart';
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
  // List<SlotTime> slots = [];
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

  void updateSelectedSlot(String updatedVal) {
    setState(() {
      selectedTimeSlot = new DateTime(selectedDate.year, selectedDate.month, selectedDate.day, int.parse(updatedVal.split(":")[0]), int.parse(updatedVal.split(":")[1]), 0, 0, 0);
    });
  }

  void updateParty(int people) {
    setState(() {
      _party = people;
    });
  }

  @override
  void initState() {
    // slots = [...widget.slotTimes];
    // slots.insert(0, SlotTime(slot: '', seats: 1));
    // slots.insert(1,SlotTime(
    //     slot: 'Not Required-Selected a slot on a previous order',
    //     seats: 1));

    // slot = slots.first;
    selectedTimeSlot = nextTimeSlot();
    selectedDate = DateTime.now();
    _party = 1;
    super.initState();
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
        title: Text("Book Table"),
      ),
      bottomNavigationBar: Container(
        margin: EdgeInsets.all(8.0),
        child: ElevatedButton(
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all(Colors.blue[400]),
          ),
          child: Text(
            "Continue",
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
            ),
          ),
          onPressed: (() => user != null ? 
            BookTableService().registerTable("CXdKnqsdwetprt885KVx", selectedDate, _party, selectedTimeSlot, user)
            : Navigator.push(context, MaterialPageRoute(builder: (context) => AuthScreen()))
            )
        ),
      ),
      body:
          Column(mainAxisAlignment: MainAxisAlignment.start, children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(top: 18.0),
          child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Party"),
                    DropdownButton<int>(
                      hint: Text(1.toString()),
                      elevation: 20,
                      value: _party,
                      items:
                          <int>[1, 2, 3, 4, 5, 6, 7, 8, 9, 10].map((int value) {
                        return DropdownMenuItem<int>(
                          value: value,
                          child: new Text(value.toString()),
                        );
                      }).toList(),
                      onChanged: (newVal) {
                        updateParty(newVal);
                      },
                    )
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Date"),
                    TextButton(
                      style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all(Colors.white),
                      ),
                      onPressed: _selectDate,
                      child: Row(children: [
                        Text(
                          DateFormat.EEEE().format(selectedDate) +
                              " , " +
                              DateFormat.MMMMd().format(selectedDate),
                          style: TextStyle(color: Colors.black54),
                        ),
                        Icon(Icons.arrow_drop_down_sharp, color: Colors.black54)
                      ]),
                    ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Time"),
                    DropdownButton<String>(
                      hint: Text(DateFormat.Hm().format(selectedTimeSlot)),
                      items: slots.map((val) {
                        var index = slots.indexOf(val);
                        return DropdownMenuItem<String>(
                          value: slots[index].keys.first ??
                              DateFormat.Hm().format(selectedTimeSlot),
                          child: Text(slots[index].keys.first.toString()),
                        );
                      }).toList(),
                      onChanged: (newVal) {
                        updateSelectedSlot(newVal);
                      },
                    ),
                  ],
                ),
              ]),
        ),
        Divider(),
        Padding(
          padding: const EdgeInsets.only(top: 18.0),
          child: Row(children: [
            Column(children: <Widget>[
              Text("Please select the time slot"),
              Divider(),
              Container(
                padding: EdgeInsets.all(8.0),
                width: size.width,
                height: size.height * 0.50,
                child: GridView.count(
                    padding: const EdgeInsets.all(4.0),
                    crossAxisCount: 3,
                    mainAxisSpacing: 16,
                    crossAxisSpacing: 4,
                    childAspectRatio: 2.5,
                    children: List.generate(9, (index) {
                      return SizedBox(
                          child: GestureDetector(
                        onTap: () =>
                            updateSelectedSlot(slots[index].keys.first),
                        child: Card(
                            semanticContainer: true,
                            margin: EdgeInsets.all(4.0),
                            elevation: 18.0,
                            
                            child: Container(
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                  color: slots[index].keys.first == ((selectedTimeSlot.hour).toString()+":"+(selectedTimeSlot.minute).toString()) ? Colors.blue[400] : Colors.white,
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(6.0)),
                                  border: Border.all(
                                      color: Colors.blueAccent[400])),
                              child: Text(
                                slots[index].keys.first,
                                style: TextStyle(
                                  color: slots[index].keys.first == ((selectedTimeSlot.hour).toString()+":"+(selectedTimeSlot.minute).toString()) ? Colors.white : Colors.blue[400],
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            )),
                      ));
                    })),
              ),
            ])
          ]),
        ),
      ]),
    );
  }
}
