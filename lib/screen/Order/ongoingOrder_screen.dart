import 'package:flutter/material.dart';
import 'package:freemeals/models/cart_model.dart';
import 'package:freemeals/models/order_model.dart';
import 'package:freemeals/models/user_model.dart';
import 'package:freemeals/providers/order_provider.dart';
import 'package:freemeals/providers/products_provider.dart';
import 'package:freemeals/providers/user_provider.dart';
import 'package:freemeals/screen/Order/products_overview_screen.dart';
import 'package:provider/provider.dart';

class OngoingOrder extends StatefulWidget {
  static final routeName = '/routeName';
  final OrderDoc orderDoc;
 
  OngoingOrder({ @required this.orderDoc});

  @override
  State<OngoingOrder> createState() => _OngoingOrderState();
}

class _OngoingOrderState extends State<OngoingOrder> {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (ctx) => Products(),
        ),
        ChangeNotifierProvider(create: (ctx) => Cart(),
        ),
        ChangeNotifierProvider(create: (ctx) => OrderProvider()),
      ],
      child: Container(
        child: ProductsOverviewScreen(orderDoc: widget.orderDoc,)
      ),
    );
  }
}
