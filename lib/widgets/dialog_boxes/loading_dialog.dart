import 'package:flutter/material.dart';
import '../app_wide/logo_spinner.dart';

class Dialogs {
  static Future<void> showLoadingDialog(BuildContext context) async {
    return showDialog<void>(
      barrierColor: Colors.white.withOpacity(0.7),
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
                        children: [
                          LogoSpinner(),
                        ]),
                  )));
        });
  }
}
