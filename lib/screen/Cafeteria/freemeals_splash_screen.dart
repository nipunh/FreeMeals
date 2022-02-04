import 'package:flutter/material.dart';
import 'package:freemeals/util/theme.dart';

class FreeMealsSplashScreen extends StatelessWidget {
  const FreeMealsSplashScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'FreeMeals',
      theme: MediaQueryData.fromWindow(WidgetsBinding.instance.window)
                  .size
                  .shortestSide <
              600
          ? PhoneGalleryThemeData.lightThemeData
          : TabletGalleryThemeData.lightThemeData,
      home: SafeArea(
        child: Scaffold(
          backgroundColor: Colors.white,
          body: Center(
            child: Image.asset(
              'assets/images/splash.png',
            ),
          ),
        ),
      ),
    );
  }
}
