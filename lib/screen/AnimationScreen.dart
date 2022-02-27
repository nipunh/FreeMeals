import 'package:flutter/material.dart';

class AnimationScreen extends StatefulWidget {
  // const AnimationScreen({ Key? key }) : super(key: key);

  @override
  _AnimationScreenState createState() => _AnimationScreenState();
}

class _AnimationScreenState extends State<AnimationScreen> {

    double _opacity = 1;
    double _margin = 0;
    double _width = 200;
    Color _color = Colors.blue;


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnimatedContainer(
        duration: Duration(seconds: 1),
        color: _color,
        margin: EdgeInsets.all(_margin),
        width: _width,
        child: 
          Column(
            crossAxisAlignment : CrossAxisAlignment.center,
            children: <Widget>[
              ElevatedButton(
                child : Text('Animate MAagin'),
                onPressed: () => setState((){
                  _margin= 50;
                }),
              ),
              ElevatedButton(
                child : Text('Animate MAagin'),
                onPressed: () => setState((){
                  _margin= 0;
                }),
              )
        ],),
      ),
    );
  }
}