import 'package:flutter/material.dart';
import 'package:freemeals/models/cart_model.dart';
import 'package:provider/provider.dart';

class CartItem extends StatelessWidget {
  final String id;
  final String productId;
  final double price;
  final int quantity;
  final String title;
  final int status;

  CartItem(
      {@required this.id,
      @required this.productId,
      @required this.price,
      @required this.quantity,
      @required this.title,
      this.status});

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      direction: DismissDirection.endToStart,
      key: ValueKey(id),
      background: Container(
          color: Colors.red,
          child: Icon(
            Icons.delete,
            size: 40,
            color: Colors.white,
          ),
          alignment: Alignment.centerRight,
          margin: EdgeInsets.all(4.0)),
      onDismissed: (direction) {
        Provider.of<Cart>(context, listen: false).removeItem(productId);
      },
      child: Card(
        elevation: 8,
        margin: EdgeInsets.symmetric(horizontal: 15, vertical: 4),
        child: Padding(
            padding: EdgeInsets.all(8),
            child: ListTile(
              // leading: CircleAvatar(
              //     child: Padding(
              //   padding: const EdgeInsets.all(5.0),
              //   child: FittedBox(child: Text('\$$price')),
              // )),
              title: Text(title),
              subtitle: Text("Total: \$${price * quantity}"),
              trailing: Container(
                width: 60,
                padding: EdgeInsets.all(3),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    color: Theme.of(context).backgroundColor),
                child: Row(
                  children: [
                    InkWell(
                        onTap: () {
                          Provider.of<Cart>(context, listen: false)
                              .updateQuantity(productId, 1);
                        },
                        child: Icon(
                          Icons.remove,
                          color: Colors.white,
                          size: 16,
                        )),
                    Container(
                      margin: EdgeInsets.symmetric(horizontal: 3),
                      padding: EdgeInsets.symmetric(horizontal: 3, vertical: 2),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(3),
                          color: Colors.white),
                      child: Text(
                        quantity.toString(),
                        style: TextStyle(color: Colors.black, fontSize: 16),
                      ),
                    ),
                    InkWell(
                        onTap: () {
                          Provider.of<Cart>(context, listen: false)
                              .updateQuantity(productId, 0);
                        },
                        child: Icon(
                          Icons.add,
                          color: Colors.white,
                          size: 16,
                        )),
                  ],
                ),
              ),
            )),
      ),
    );
  }
}
