import 'package:flutter/material.dart';
import 'package:freemeals/models/cafe_model.dart';
import 'package:freemeals/widgets/cafeteria_card.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';


class CafeteriaSelection extends StatelessWidget {

  static const routeName = '/cafe-selection';

  CafeteriaSelection({Key? key}) : super(key: key);

  final cafeList = [];

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white24,
        body: Container(
          margin: EdgeInsets.all(12),
          child:  StaggeredGridView.countBuilder(
          padding: const EdgeInsets.all(12.0),
          crossAxisCount: 4,
          mainAxisSpacing: 24,
          crossAxisSpacing: 12,
          itemCount: cafeList.length,
          itemBuilder: (BuildContext context, int index) => CafeteraCard(cafeList[index]),
          staggeredTileBuilder: (int index) => StaggeredTile.fit(2),
        ),
              ),
          ),
    );
}}
