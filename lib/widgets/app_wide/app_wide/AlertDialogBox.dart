import 'package:flutter/material.dart';
import 'package:freemeals/services/user_service.dart';

class AlertDialogBox extends StatelessWidget {
  final String text;
  final String orderId;
  final String waiterId;

  AlertDialogBox({
    key,
    @required this.text,
    @required this.orderId,
    @required this.waiterId
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: ElevatedButton(
        child: Text('Cancel'),
        onPressed: () {
          showAlertDialog(context);
        },
      ),
    );
  }

  showAlertDialog(BuildContext context) {
    Widget cancelButton = TextButton(
      child: Text("No"),
      onPressed: () {
        Navigator.of(context).pop();  
      },
    );

    Widget continueButton = TextButton(
      child: Text("Yes"),
      onPressed: () {
        UserService().deleteOrderRequest(waiterId, orderId);
        Navigator.of(context).pop();  
        Navigator.pop(context);
      },
    );

    AlertDialog alert = AlertDialog(
      title: Text("Change Server"),
      content: Text("$text"),
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
