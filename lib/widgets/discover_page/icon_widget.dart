  import 'package:flutter/material.dart';

  Widget getAlbum(albumImg) {
    return Container(
      width: 55,
      height: 55,
      child: Stack(
        children: <Widget>[
          Container(
            width: 55,
            height: 55,
            decoration:
                BoxDecoration(shape: BoxShape.circle, color: Colors.black),
            child: Container(
              width: 30,
              height: 30,
              decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  image: DecorationImage(
                      image: NetworkImage(albumImg), fit: BoxFit.cover)),
            ),
          ),
        ],
      ),
    );
  }

  Widget getIcons(icon, size, count) {
    return Column(
      children: <Widget>[
        Icon(
          icon,
          color: Colors.white,
          size: size,
        ),
        SizedBox(
          height: 5,
        ),
        Text("13K",
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600))
      ],
    );
  }

  Widget getProfile(profileImg) {
    return Container(
      width: 55,
      height: 55,
      child: Stack(
        children: <Widget>[
          Container(
              height: 50,
              width: 50,
              decoration: BoxDecoration(
                  border: Border.all(color: Colors.white),
                  shape: BoxShape.circle,
                  image: DecorationImage(
                      image: NetworkImage(profileImg), fit: BoxFit.cover))),
          Positioned(
              left: 18,
              bottom: -5,
              child: Container(
                width: 20,
                height: 20,
                decoration: BoxDecoration(
                    shape: BoxShape.circle, color: Colors.blueGrey[200]),
                child: Center(
                  child: Icon(
                    Icons.add,
                    color: Colors.white,
                    size: 15,
                  ),
                ),
              ))
        ],
      ),
    );
  }