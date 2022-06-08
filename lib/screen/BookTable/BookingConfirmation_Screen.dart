import 'package:flutter/material.dart';
import 'package:freemeals/constants/request_constants.dart';
import 'package:freemeals/models/bookeingRequest_model.dart';
import 'package:qr_flutter/qr_flutter.dart';

class BookingConfirmationScreen extends StatelessWidget {
  BookingDoc booking;

  BookingConfirmationScreen({key, @required this.booking}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return SafeArea(
        child: Scaffold(
      appBar: AppBar(
        title: Text("Booking Details"),
      ),
      body: Container(
        decoration: BoxDecoration(color: Colors.grey[200]),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Container(
            padding: EdgeInsets.all(12),
            margin: EdgeInsets.only(top: 10),
            color: Colors.white,
            width: size.width,
            child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(
                    Icons.fact_check_outlined,
                    size: 64,
                    color: Color.fromRGBO(132, 82, 161, 1),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 5.0, top: 8.0),
                    child: RichText(
                        text: TextSpan(children: [
                      TextSpan(
                        text: RequestDecrypt.tableBookingStatus[booking.requestStatus],
                        style: TextStyle(
                            fontSize: 18,
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1,
                            wordSpacing: 2),
                      ),
                      TextSpan(
                          text:
                              "\n\nWe have booked your spot for the ${booking.bookingDate.day}/${booking.bookingDate.month}/${booking.bookingDate.year} at the ${booking.cafeName}. Please arrive at the restaurant at the selected time.",
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey,
                            wordSpacing: 1,
                            height: 1.5,
                          ))
                    ])),
                  )
                ]),
          ),
          Container(
            padding: EdgeInsets.all(16),
            margin: EdgeInsets.only(top: 10),
            color: Colors.white,
            width: size.width,
            height: size.height * 0.30,
            child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(bottom: 8.0),
                    child: Text(
                      "Booking Details",
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1,
                        wordSpacing: 2,
                      ),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Container(
                        height: size.height * 0.20,
                        width: size.width * 0.40,
                        decoration: BoxDecoration(),
                        child: QrImage(
                          padding: EdgeInsets.all(0),
                          data: booking.id,
                          version: QrVersions.auto,
                          size: 180.0,
                        ),
                      ),
                      VerticalDivider(width: 10),
                      Container(
                          height: size.height * 0.20,
                          width: size.width * 0.40,
                          padding: EdgeInsets.all(8.0),
                          decoration: BoxDecoration(),
                          child: RichText(
                              text: TextSpan(
                                  style: TextStyle(color: Colors.black),
                                  children: [
                                TextSpan(children: [
                                  TextSpan(text: "Date :"),
                                  TextSpan(text: "${booking.bookingDate.day}/${booking.bookingDate.month}/${booking.bookingDate.year} \n\n")
                                ]),
                                TextSpan(children: [
                                  TextSpan(text: "Booking Time : "),
                                  TextSpan(text: "${booking.bookingTime.hour}:${booking.bookingTime.minute} \n\n")
                                ]),
                                TextSpan(children: [
                                  TextSpan(text: "Guests :"),
                                  TextSpan(text: "${booking.noOfGuests} \n\n")
                                ]),
                              ])))
                    ],
                  )
                ]),
          )
        ]),
      ),
    ));
  }
}
