import 'package:flutter/material.dart';
import 'package:launch_review/launch_review.dart';

class VersionCheckScreen extends StatelessWidget {
  const VersionCheckScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text('App Update'),
        ),
        body: SingleChildScrollView(
          child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
            Container(
              height: MediaQuery.of(context).size.height * 0.4,
              width: MediaQuery.of(context).size.width * 0.80,
              child: Image.asset('assets/images/auth_screen.png'),
            ),
            Padding(
              padding: const EdgeInsets.all(25.0),
              child: Card(
                color: Colors.grey[200],
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                      'The current version of the app is no longer in use. Please update your app to continue.',
                      style: TextStyle(
                          fontWeight: FontWeight.w500, letterSpacing: 0.5)),
                ),
              ),
            ),
            ElevatedButton(
              child: Text('Update App'),
              onPressed: () => LaunchReview.launch(
                  androidAppId: 'com.platos.platos.prod',
                  iOSAppId: '1544403322'),
            ),
          ]),
        ),
      ),
    );
  }
}
