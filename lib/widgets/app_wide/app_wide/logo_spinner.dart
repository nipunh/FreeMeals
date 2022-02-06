import 'package:flutter/material.dart';
import 'package:freemeals/services/device_service.dart';

class LogoSpinner extends StatefulWidget {
  LogoSpinner({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _LogoSpinnerState createState() => _LogoSpinnerState();
}

class _LogoSpinnerState extends State<LogoSpinner>
    with TickerProviderStateMixin {
  AnimationController _controller;

  void _repeat() {
    if (_controller.isCompleted) {
      _controller.repeat();
    }
  }

  @override
  void initState() {
    _controller = AnimationController(
      duration: const Duration(milliseconds: 5000),
      vsync: this,
    );

    _controller.addListener(_repeat);

    super.initState();
  }

  @override
  void dispose() {
    _controller.removeListener(_repeat);
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    bool isTab = DeviceService().isTablet(context);
    _controller.forward();
    return RotationTransition(
      turns: Tween(begin: 0.0, end: 1.0).animate(_controller),
      child: Container(
        height: !isTab ? 100 : 210,
        width: !isTab ? 100 : 210,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Image.asset(
            'assets/images/platos-original-png-circle.png',
          ),
        ),
      ),
    );
  }
}
