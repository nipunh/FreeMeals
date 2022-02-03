import 'package:flutter/material.dart';
import 'package:freemeals/models/cafe_model.dart';

class CafeteraCard extends StatelessWidget {

  final Cafeteria cafe;
  CafeteraCard(this.cafe);

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.bottomLeft,
      height: 200,
      width : 200,
      decoration: BoxDecoration(
        color: Colors.transparent,
        borderRadius: BorderRadius.all(Radius.circular(15)),
        image :  DecorationImage(
          image: NetworkImage(cafe.banners[0])
          ,
          fit : BoxFit.cover
      ),
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 8, vertical: 14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(cafe.name, 
              style: TextStyle(
                color : Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold
              ),
              ),
            Row(
              children: <Widget>[
                for(var i =0; i< cafe.loyaltyStamps; i++)
                  cafe.cafeLoyalty == true ? const Icon(Icons.check_circle, color: Colors.white,) : const Icon(Icons.check_circle_outline_outlined, color: Colors.white,)
              ],
            )
        ],),
      ),
    );
  }
}