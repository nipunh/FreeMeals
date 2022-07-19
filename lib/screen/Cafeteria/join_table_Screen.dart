import 'package:flutter/cupertino.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:freemeals/screen/Cafeteria/join_table_waiting_screen.dart';
import 'package:freemeals/services/cafeteria_service.dart';

class JoinTableScreen extends StatefulWidget {
  final String cafeId;

  const JoinTableScreen({Key key, @required this.cafeId});

  @override
  State<JoinTableScreen> createState() => _JoinTableScreenState();
}

class _JoinTableScreenState extends State<JoinTableScreen> {
  String orderDocId = "";

  @override
  Widget build(BuildContext context) {
    User user = FirebaseAuth.instance.currentUser;
    // Show form directly
    return Scaffold(
      appBar: AppBar(
        title: Text("Join a table"),
      ),
      body: (user.uid != null)
          ? Container(
              child: new Form(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      "Enter the OrderId",
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 10),
                    TextFormField(
                      decoration: const InputDecoration(
                        icon: const Icon(Icons.dining),
                        hintText: 'Enter order id',
                        labelText: 'Order Id',
                      ),
                      onChanged: ((value) => {
                            setState(() {
                              orderDocId = value;
                            })
                          }),
                    ),
                    new Container(
                        padding: const EdgeInsets.only(left: 150.0, top: 40.0),
                        child: new ElevatedButton(
                            child: const Text('Next'),
                            onPressed: () {
                              // order update function get orderId

                              CafeteriasService()
                                  .getOrderDocByOrderCode(widget.cafeId, orderDocId, user)
                                  .then((value) => 
                                  {
                                  Navigator.push(
                                      context,
                                      new MaterialPageRoute(
                                          builder: (context) =>
                                              new JoinTableWaitingScreen(
                                                orderId: value,
                                              )))});
                            })),
                  ],
                ),
              ),
            )
          : Container(
              child: Text("THis container"),
            ),
    );
  }
  // Show option to get in as a Guest User or login
}
