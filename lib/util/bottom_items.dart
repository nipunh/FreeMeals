import 'package:flutter/material.dart';
import 'package:freemeals/screen/Cafeteria/cateteria_selecttion_screen.dart';

List iconItems = [
  Icon(Icons.pin_drop_outlined, color: Colors.white,),
  Icon(Icons.chat_bubble_outline_rounded, color: Colors.white,),
  Icon(Icons.photo_camera_outlined, color: Colors.white,),
  Icon(Icons.local_restaurant_outlined, color: Colors.white,),
  Icon(Icons.amp_stories_outlined, color: Colors.white,)
];

List textItems = ['Map', 'Chat', 'Camera', 'Restuarants', 'Discover'];

List RouteNames = ['/map', '/chat', '/camera', CafeteriaSelectionScreen(), '/restro-vids'];