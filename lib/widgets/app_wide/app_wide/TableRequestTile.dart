import 'package:flutter/material.dart';
import 'package:freemeals/services/user_service.dart';

class TableRequestTile extends StatelessWidget {
  final String id;
  final DateTime bookingTime;
  final int guestNumber;
  final DateTime bookingDate;
  final bool canDismiss;

  TableRequestTile({
    @required this.id,
    @required this.bookingDate,
    @required this.bookingTime,
    @required this.guestNumber,
     @required this.canDismiss,
  });

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      direction: canDismiss? DismissDirection.horizontal: DismissDirection.none,
      key: ValueKey(id),
      background: Container(
          color: Colors.red,
          padding: EdgeInsets.only(left: 10),
          child: Icon(
            Icons.cancel_outlined,
            size: 40,
            color: Colors.white,
          ),
          alignment: Alignment.centerLeft,
          margin: EdgeInsets.all(4.0)),
      secondaryBackground: Container(
          color: Colors.green[400],
          padding: EdgeInsets.only(right: 10),
          child: Icon(
            Icons.check_circle_outline,
            size: 40,
            color: Colors.white,
          ),
          alignment: Alignment.centerRight,
          margin: EdgeInsets.all(4.0)),
      onDismissed: (direction) {
        if(direction == DismissDirection.endToStart){
          print("accept");
          UserService().acceptTableBookingRequest(id, 1);
        }
        
        if(direction == DismissDirection.startToEnd){
          print("cancel");
          UserService().acceptTableBookingRequest(id, 2);
        }
        // Provider.of<Cart>(context, listen: false).removeItem(productId);
      },
      child: Container(
        margin: EdgeInsets.all(5),
        decoration: BoxDecoration(
            color: Colors.white60,
            borderRadius: BorderRadius.all(Radius.circular(20)),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.5),
                spreadRadius: 2,
                blurRadius: 5,
                offset: Offset(0, 3), // changes position of shadow
              ),
            ]),
        child: ListTile(
          leading: CircleAvatar(
              child: Padding(
            padding: const EdgeInsets.all(5.0),
            child: FittedBox(child: Text('$guestNumber')),
          )),
          title: Text(
              "Booking Date: ${bookingDate.day}/${bookingDate.month}/${bookingDate.year}"),
          subtitle:
              Text("Booking TIme: ${bookingTime.hour}:${bookingTime.minute}"),
          trailing: Text(""),
        ),
      ),
    );
  }
}
