import 'package:flutter/material.dart';

class FailureDialog {
  static Future<void> showFailureDialog(BuildContext context) async {
    return showDialog<void>(
        barrierColor: Colors.white,
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return new WillPopScope(
              onWillPop: () async => false,
              child: Scaffold(
                  backgroundColor: Colors.transparent,
                  body: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Container(
                          height: MediaQuery.of(context).size.height * 0.5,
                          width: MediaQuery.of(context).size.width * 0.80,
                          child: Image.asset('assets/images/order-failed.png'),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Text(
                            'Payment Failed.',
                            style: TextStyle(
                              fontWeight: Theme.of(context)
                                  .textTheme
                                  .headline2
                                  .fontWeight,
                              fontSize: Theme.of(context)
                                  .textTheme
                                  .headline2
                                  .fontSize,
                            ),
                          ),
                        ),
                      ],
                    ),
                  )));
        });
  }
}
