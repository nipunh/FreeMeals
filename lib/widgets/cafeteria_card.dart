import 'package:flutter/material.dart';
import 'package:freemeals/models/cafe_model.dart';
import 'package:freemeals/models/user_model.dart';

class CafeteraCard extends StatelessWidget {
  final Cafeteria cafe;
  final UserDoc user;

  CafeteraCard(this.cafe, this.user);

  List<Icon> _loyaltyStamps() {
    List<Icon> stars = [];
    for (int i = 0; i < cafe.cafeLoyaltyStamps; i++) {
      stars.add(
          Icon(Icons.check_circle_rounded, color: i < 4 ? Colors.amber.shade400 : Colors.white));
    }
    return stars;
  }

  dynamic myFabButton = Container(


    width: 90.0,
    height: 30.0,
    child: new RawMaterialButton(
      fillColor: Colors.white70,
      shape: new RoundedRectangleBorder(
          borderRadius: new BorderRadius.circular(30.0),
          side: BorderSide(color: Colors.black26, width: 1.0)),
      elevation: 18.0,
      highlightElevation: 18.0,
      child: Container(
        child: Row(
          children: [
            ClipRRect(
              borderRadius: new BorderRadius.circular(15.0),
              child: Image.asset('assets/images/manager.jpg',
                  height: 30.0, width: 30.0),
            ),
            SizedBox(width: 5.0),
            Text(
              "Book Table",
              style: TextStyle(
                fontWeight: FontWeight.w100,
                fontSize: 10.0,
              ),
            ),
          ],
        ),
      ),
      onPressed: () {},
    ),
  );

  @override
  Widget build(BuildContext context) {
    return Container(
        child: Card(
      clipBehavior: Clip.antiAlias,
      margin: EdgeInsets.all(4.0),
      elevation: 18.0,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(10.0))),
      child: Container(
          height: (200 * cafe.bannerSize["height"]).toDouble(),
          width: (200 * cafe.bannerSize['width']).toDouble(),
          decoration: BoxDecoration(
            color: Colors.transparent,
            borderRadius: BorderRadius.all(Radius.circular(10.0)),
            image: DecorationImage(
                image: NetworkImage(cafe.banners[0]), fit: BoxFit.cover),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              ButtonBar(
                alignment: MainAxisAlignment.end,
                children: [myFabButton],
              ),
              new Container(
                  decoration: new BoxDecoration(
                      color: Colors.white54,
                      borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(10.0),
                          bottomRight: Radius.circular(10.0))),
                  child: new ListTile(
                    title: Text(
                      cafe.name,
                      style: TextStyle(
                        color: ThemeData.dark().primaryColor,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    subtitle: Row(children: _loyaltyStamps()),
                  )),
            ],
          )),
    ));

    // ignore: dead_code
    //   return Container(

    //     alignment: Alignment.bottomLeft,
    //     height: (200 * cafe.bannerSize["height"]).toDouble(),
    //     width: (200 * cafe.bannerSize['width']).toDouble(),
    //     decoration: BoxDecoration(
    //       color: Colors.transparent,
    //       borderRadius: BorderRadius.all(Radius.circular(15)),
    //       image: DecorationImage(
    //           image: NetworkImage(cafe.banners[0]), fit: BoxFit.cover),
    //     ),

    //     child: Container(
    //         color: Colors.white70,
    //         padding: EdgeInsets.symmetric(horizontal: 8, vertical: 24),
    //         child: Column(
    //             mainAxisAlignment: MainAxisAlignment.start,
    //             crossAxisAlignment: CrossAxisAlignment.start,
    //             mainAxisSize: MainAxisSize.min,
    //             children: [
    //               Text(
    //                 cafe.name,
    //                 style: TextStyle(
    //                     color: ThemeData.dark().primaryColor ,
    //                     fontSize: 16,
    //                     fontWeight: FontWeight.bold),
    //               ),
    //             Row(

    //               children : _loyaltyStamps()
    //             ),
    //             ])
    //     ));
  }
}
