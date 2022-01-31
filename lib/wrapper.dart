import 'package:flutter/material.dart';
import 'package:freemeals/screen/Authentication/authenticate.dart';
// import 'package:freemeals/screen/Home/home.dart';

class Wrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
  //  Either home or authenticate
    return Authenticate();
  }
}