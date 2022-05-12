import 'package:flutter/material.dart';
import 'package:freemeals/models/waiter_Selection.dart';
import 'package:freemeals/screen/Cafeteria/waiter_selection_screen.dart';
class NavBar extends StatelessWidget {
  const NavBar({
    Key key,
    @required this.context,
  }) : super(key: key);

  final BuildContext context;

  @override
  Widget build(BuildContext context) {
    List NavigationBarElements = [
      ElevatedButton(
        style: ButtonStyle(
          backgroundColor:
              MaterialStateProperty.all<Color>(Colors.white.withOpacity(0.30)),
          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
              RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          )),
        ),
        child: Text('Stories',
            style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold)),
      ),
      ElevatedButton(
          style: ButtonStyle(
            backgroundColor:
                MaterialStateProperty.all<Color>(Colors.purple[400]),
            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0),
            )),
          ),
          onPressed: () {
            Navigator.push(
                context,
                new MaterialPageRoute(
                    builder: (context) => new WaiterSelectionScreen(waiterSelection: new WaiterSelection("Priyank"))));
          },
          child: Text("Start Order", style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
              fontWeight: FontWeight.bold))),
      ElevatedButton(
        style: ButtonStyle(
          backgroundColor:
              MaterialStateProperty.all<Color>(Colors.white.withOpacity(0.8)),
          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
              RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                  side: BorderSide(color: Colors.white70))),
        ),
        onPressed: () {},
        child: Wrap(
          children: [
            Text(
              'W',
              style: TextStyle(
                  color: Colors.black,
                  fontSize: 18,
                  fontWeight: FontWeight.w900),
            ),
            Text('.',
                style: TextStyle(
                    color: Colors.purple[400],
                    fontSize: 20,
                    fontWeight: FontWeight.w900))
          ],
        ),
      )
    ];

    return Container(
      width: double.infinity,
      height: 60,
      color: Color(0x00ffffff),
      child: Padding(
        padding: const EdgeInsets.only(left: 20, right: 20, bottom: 5, top: 10),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: List.generate(NavigationBarElements.length, (index) {
            return InkWell(
                onTap: () {},
                child: NavigationBarElements[index]);
          }),
        ),
      ),
    );
  }
}