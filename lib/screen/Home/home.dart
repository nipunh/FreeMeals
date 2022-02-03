import 'package:flutter/material.dart';
import 'package:freemeals/screen/Cafeteria/cateteria_selecttion_screen.dart';

class Home extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        backgroundColor:  Color(0xFFFEFEFE),
        primaryColor : Color(0xFFf36f7c),
      ),
      home: Scaffold(
        body : Center(
          // child: CafeteriaSelection(), 
        ) 
      )
    );
  }
}