import 'package:flutter/material.dart';
import './logo_spinner.dart';

class LoadingPage extends StatelessWidget {
  const LoadingPage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Center(
          child: LogoSpinner(),
        ),
      ),
    );
  }
}
