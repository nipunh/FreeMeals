import "package:flutter/material.dart";
import 'package:freemeals/models/cart_model.dart';
import 'package:freemeals/models/product.dart';
import 'package:provider/provider.dart';


class ProductItem extends StatelessWidget {
  // final String id;
  // final String title;
  // final String imgUrl;
  // final String description;
  // final double price;

  // ProductItem({this.id, this.imgUrl, this.title, this.description, this.price});

  @override
  Widget build(BuildContext context) {
    final product = Provider.of<Product>(context);
    final cart = Provider.of<Cart>(context, listen: false);
    return Container(
      margin: EdgeInsets.all(10),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(10),
              topRight: Radius.circular(10),
              bottomLeft: Radius.circular(10),
              bottomRight: Radius.circular(10)),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 5,
              blurRadius: 7,
              offset: Offset(0, 3), // changes position of shadow
            ),
          ]),
      child: ListTile(
        
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: BorderSide(
            color: Colors.black,
          ),
        ),
        leading: Image.network(
          '${product.imageUrl}',
          fit: BoxFit.contain,
          height: 100,
          width: 50,
        ),
        title: Text(product.title, textAlign: TextAlign.left),
        subtitle: RichText(
          text: TextSpan(children: [
            TextSpan(
                text: product.description,
                style: TextStyle(color: Colors.black)),
            TextSpan(text: "\n\n"),
            TextSpan(
                text: product.price.toString(),
                style:
                    TextStyle(fontWeight: FontWeight.bold, color: Colors.black))
          ]),
        ),
        trailing: Wrap(
          spacing: 12,
          children: [
            GestureDetector(
              onTap: () => product.toggleFavStatus(),
              child: Icon(
                Icons.favorite,
                color: product.isFavourite ? Colors.red : Colors.grey,
              ),
            ),
            GestureDetector(
              onTap: () => cart.addItem(product.id, product.title, product.price),
              child: Icon(
                Icons.add_circle_outlined,
                color: Colors.black87,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
