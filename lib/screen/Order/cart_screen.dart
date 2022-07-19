import 'package:flutter/material.dart';
import 'package:freemeals/models/cart_model.dart';
import 'package:freemeals/models/order_model.dart';
import 'package:freemeals/services/order_service.dart';
import 'package:freemeals/services/user_service.dart';
import 'package:provider/provider.dart';
import '../../widgets/app_wide/app_wide/cart_item.dart' as ci;

class CartScreen extends StatelessWidget {
  static const routeName = '/cart';
  final OrderDoc orderDoc;
  CartScreen({@required this.orderDoc});

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<Cart>(context, listen: true);
    return Scaffold(
        appBar: AppBar(title: Text('Your Cart')),
        body: Column(children: <Widget>[
          Card(
            margin: EdgeInsets.all(15),
            child: Padding(
              padding: EdgeInsets.all(8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    "Total",
                    style: TextStyle(fontSize: 20),
                  ),
                  Spacer(),
                  Chip(
                    label: Text('\$${cart.totalAmount.ceilToDouble()}'),
                    backgroundColor: Colors.white38,
                  ),
                  ElevatedButton(
                      onPressed: () {
                        OrderService().orderItemRequest(orderDoc.id, cart, orderDoc.userId).then((value){
                          if(value == true){
                            print("no issues");
                            cart.clearCart();
                          }else{
                            print("Issue faced");
                          }
                        });
                        
                      },
                      child: Text("ORDER NOW"))
                ],
              ),
            ),
          ),
          ListView.builder(
              physics: NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: cart.itemCount,
              itemBuilder: (ctx, i) {
                return ci.CartItem(
                    id: cart.items.values.toList()[i].id,
                    productId: cart.items.keys.toList()[i],
                    price: cart.items.values.toList()[i].price,
                    quantity: cart.items.values.toList()[i].quantity,
                    title: cart.items.values.toList()[i].title);
              }),
        ]));
  }
}
