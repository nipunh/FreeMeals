import 'package:flutter/material.dart';
import 'package:freemeals/models/cafe_model.dart';
import 'package:freemeals/screen/Cafeteria/cateteria_selecttion_screen.dart';
import 'package:freemeals/screen/Cafeteria/freemeals_splash_screen.dart';
import 'package:splashscreen/splashscreen.dart';
// import 'package:platos_client_app/models/cafeteria_model.dart';
// import 'package:platos_client_app/screens/platos_splash_screen.dart';
// import 'package:platos_client_app/screens/vendor_list_screen.dart';
import 'package:splashscreen/splashscreen.dart';

class CafeteriaSplashScreen extends StatefulWidget {
  final Cafeteria cafe;

  CafeteriaSplashScreen({Key key, this.cafe}) : super(key: key);

  @override
  _CafeteriaSplashScreenState createState() => _CafeteriaSplashScreenState();
}

class _CafeteriaSplashScreenState extends State<CafeteriaSplashScreen> {
  bool _loading = true;
  Image _image;
  @override
  void initState() {
    if (widget.cafe.banners != null && widget.cafe.banners.isNotEmpty) {
      _image = Image.network(widget.cafe.banners[0], fit: BoxFit.fill);

      _image.image
          .resolve(new ImageConfiguration())
          .addListener(ImageStreamListener((ImageInfo info, bool syncCall) {
        if (mounted) {
          setState(() {
            _loading = false;
          });
        }
      }));
    } else {
      setState(() {
        _loading = false;
      });
    }
    super.initState();
  }

  @override
  void didChangeDependencies() async {
    if (_loading) {
      await Future.delayed(Duration(seconds: 1));
      setState(() {
        _loading = false;
      });
    }
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    final defaultImage = Image.asset('assets/images/cafe.png');

    if (_loading)
      return FreeMealsSplashScreen();
    else
      return SafeArea(
          child: SplashScreen(
              seconds: 3,
              navigateAfterSeconds: CafeteriaSelectionScreen(),
              title: Text(
                'Welcome to ' + widget.cafe.name,
                style: TextStyle(
                  fontSize: Theme.of(context).textTheme.headline2.fontSize,
                  fontWeight: Theme.of(context).textTheme.headline2.fontWeight,
                ),
              ),
              image: (_image != null) ? _image : defaultImage,
              backgroundColor: Colors.white,
              styleTextUnderTheLoader: TextStyle(),
              photoSize: 150.0,
              loaderColor: Colors.amber));
  }
}
