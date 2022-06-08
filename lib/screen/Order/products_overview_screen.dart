import "package:flutter/material.dart";
import 'package:freemeals/models/cart_model.dart';
import 'package:freemeals/providers/products_provider.dart';
import 'package:freemeals/screen/Order/cart_screen.dart';
import 'package:freemeals/widgets/app_wide/app_wide/badge.dart';
import 'package:freemeals/widgets/app_wide/app_wide/product_item.dart';
import 'package:provider/provider.dart';

enum FilterOptions { Favourites, All }

class ProductsOverviewScreen extends StatefulWidget {
  @override
  State<ProductsOverviewScreen> createState() => _ProductsOverviewScreenState();
}

class _ProductsOverviewScreenState extends State<ProductsOverviewScreen> {
  var _showOnlyFav = false;
  final orderDocId = "";

  @override
  Widget build(BuildContext context) {
    final productsData = Provider.of<Products>(context, listen: false);
    final products = _showOnlyFav ? productsData.faouriteItems : productsData.items;
    
    final cart = Provider.of<Cart>(context);
    return Scaffold(
        appBar: AppBar(
          title: Text("Menu Items"),
          actions: <Widget>[
            Consumer<Cart>(
              builder: (_, cart, ch) => Badge(child: ch, value: cart.itemCount.toString()),
              child: IconButton(
                icon: Icon(Icons.shopping_cart),
                onPressed: () => {
                  Navigator.push(context, MaterialPageRoute(builder: (_)=> ChangeNotifierProvider.value(
                    value : cart,
                    child: CartScreen(),
                  )))
                },
              ),
            ),
            PopupMenuButton(
                onSelected: (FilterOptions selectedValue) {
                  setState(() {
                    if (selectedValue == FilterOptions.Favourites) {
                      _showOnlyFav = true;
                    } else {
                      _showOnlyFav = false;
                    }
                  });
                },
                icon: Icon(Icons.more_vert),
                itemBuilder: (_) => [
                      PopupMenuItem(
                          child: Text('Only Faourites'),
                          value: FilterOptions.Favourites),
                      PopupMenuItem(
                          child: Text('Show All'), value: FilterOptions.All),
                    ]),
          ],
        ),
        body: ListView.builder(
          padding: const EdgeInsets.all(10.0),
          itemCount: products.length,
          itemBuilder: (ctx, i) => ChangeNotifierProvider.value(
              value: products[i],
              child: ProductItem(
                  // title: products[i].title,
                  // id: products[i].id,
                  // imgUrl: products[i].imageUrl,
                  // description: products[i].description,
                  // price: products[i].price,
                  )),
        ));
  }
}
