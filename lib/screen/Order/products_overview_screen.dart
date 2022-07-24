import "package:flutter/material.dart";
import 'package:freemeals/constants/order_constants.dart';
import 'package:freemeals/models/cart_model.dart';
import 'package:freemeals/models/order_model.dart';
import 'package:freemeals/providers/products_provider.dart';
import 'package:freemeals/providers/user_provider.dart';
import 'package:freemeals/screen/Order/cart_screen.dart';
import 'package:freemeals/widgets/app_wide/app_wide/badge.dart';
import 'package:freemeals/widgets/app_wide/app_wide/product_item.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart' show toBeginningOfSentenceCase;
import 'dart:ui';

enum FilterOptions { Favourites, All }

class ProductsOverviewScreen extends StatefulWidget {
  final OrderDoc orderDoc;
  ProductsOverviewScreen({@required this.orderDoc});

  @override
  State<ProductsOverviewScreen> createState() => _ProductsOverviewScreenState();
}

class _ProductsOverviewScreenState extends State<ProductsOverviewScreen> {
  var _showOnlyFav = false;
  final orderDocId = "";

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final productsData = Provider.of<Products>(context, listen: false);
    final products =
        _showOnlyFav ? productsData.faouriteItems : productsData.items;
    final categories = [
      "Beverage",
      "Beer",
      "Burger",
      "Pizza",
      "Dessert",
      "Pasta"
    ];
    final user = Provider.of<SelectedUser>(context, listen: false);
    final cart = Provider.of<Cart>(context);
    final waiterId = Provider.of<SelectedWaiter>(context).waiterId;
    final waiterName = Provider.of<SelectedWaiter>(context).waiterName;
    final waiterProfileImg =
        Provider.of<SelectedWaiter>(context).waiterProfileImg;
    final waiterRating = Provider.of<SelectedWaiter>(context).rating;

    final stats = ['orderId', 'tableNumber', 'noOfCustomers', 'itemsTotal'];

    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      // appBar: null,
      resizeToAvoidBottomInset: false,

      // bottomNavigationBar: null,
      // extendBodyBehindAppBar: true,

      //     appBar: AppBar(
      //       title: Text("Menu Items"),
      //       actions: <Widget>[
      //         Consumer<Cart>(
      //           builder: (_, cart, ch) => Badge(child: ch, value: cart.itemCount.toString()),
      //           child: IconButton(
      //             icon: Icon(Icons.shopping_cart),
      //             onPressed: () => {
      //               Navigator.push(context, MaterialPageRoute(builder: (_)=> ChangeNotifierProvider.value(
      //                 value : cart,
      //                 child: CartScreen(orderDoc: widget.orderDoc),
      //               )))
      //             },
      //           ),
      //         ),
      //         PopupMenuButton(
      //             onSelected: (FilterOptions selectedValue) {
      //               setState(() {
      //                 if (selectedValue == FilterOptions.Favourites) {
      //                   _showOnlyFav = true;
      //                 } else {
      //                   _showOnlyFav = false;
      //                 }
      //               });
      //             },
      //             icon: Icon(Icons.more_vert),
      //             itemBuilder: (_) => [
      //                   PopupMenuItem(
      //                       child: Text('Only Faourites'),
      //                       value: FilterOptions.Favourites),
      //                   PopupMenuItem(
      //                       child: Text('Show All'), value: FilterOptions.All),
      //                 ]),
      //       ],
      //     ),
      body: SingleChildScrollView(
        child: Container(
          child: Column(children: [
            Padding(
              padding: const EdgeInsets.only(left: 14.0, right: 14.0, top: 0),
              child: Container(
                  height: size.height * 0.25,
                  decoration: BoxDecoration(color: Colors.white),
                  padding: EdgeInsets.only(bottom: 25),
                  //ClipRRect for image border radius
                  child: Container(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          height: size.height,
                          width: size.width * 0.45,
                          child: Stack(
                            children: [
                              Image.network(waiterProfileImg,
                                  // "https://firebasestorage.googleapis.com/v0/b/freemeals-3d905.appspot.com/o/cafeterias%2FCXdKnqsdwetprt885KVx%2FwaiterImages%2Fwithout-bg-02.png?alt=media&token=c52c7b13-cdf0-4b7d-b1b0-998529a85896",
                                  width: double.infinity,
                                  height: size.height,
                                  fit: BoxFit.cover),
                              Positioned(
                                // The Positioned widget is used to position the text inside the Stack widget
                                bottom: 0,
                                right: 10,
                                child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(15.0)),
                                    border: Border.all(color: Colors.black),
                                    color: Colors.black54,
                                  ),
                                  width: size.width * 0.40,
                                  padding: const EdgeInsets.all(10),
                                  child: Text(
                                    '$waiterName | $waiterRating',
                                    style: TextStyle(
                                        fontSize: 18, color: Colors.white),
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),

                        Container(
                            padding: EdgeInsets.only(top: 15),
                            height: size.height,
                            width: size.width * 0.45,
                            child: GridView.count(
                                crossAxisCount: 2,
                                mainAxisSpacing: 4,
                                crossAxisSpacing: 4,
                                childAspectRatio: 1,
                                children: List.generate(4, (index) {
                                  return Card(
                                      clipBehavior: Clip.antiAlias,
                                      elevation: 4.0,
                                      shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(10.0))),
                                      child: new ClipRect(
                                        child: new BackdropFilter(
                                          filter: new ImageFilter.blur(
                                              sigmaX: 10.0, sigmaY: 10.0),
                                          child: new Container(
                                            width: 220.0,
                                            height: 220.0,
                                            decoration: new BoxDecoration(
                                                color: Colors.blueAccent
                                                    .withOpacity(0.5)),
                                            child: new Center(
                                                child: RichText(
                                              text: TextSpan(children: [
                                                TextSpan(
                                                    text: stats[index] ==
                                                            'orderId'
                                                        ? 'Order\n'
                                                        : stats[index] ==
                                                                'tableNumber'
                                                            ? 'Table\n'
                                                            : stats[index] ==
                                                                    'noOfCustomers'
                                                                ? 'Guests\n'
                                                                : stats[index] ==
                                                                        'itemsTotal'
                                                                    ? 'Total'
                                                                    : ""),
                                                // '${stats[index].split(RegExp(r"(?=[A-Z])")).map((element) => toBeginningOfSentenceCase(element)).join(" ")}\n'),
                                                TextSpan(
                                                    text: stats[index] ==
                                                            'orderId'
                                                        ? '${widget.orderDoc.getOrderId()}'
                                                        : stats[index] ==
                                                                'tableNumber'
                                                            ? '${widget.orderDoc.getNumberOfCustomers()}'
                                                            : stats[index] ==
                                                                    'noOfCustomers'
                                                                ? '${widget.orderDoc.getTableNumber()}'
                                                                : stats[index] ==
                                                                        'totalCost'
                                                                    ? '${widget.orderDoc.getTotalCost(user.userId)}'
                                                                    : ""),
                                              ]),
                                            )),
                                          ),
                                        ),
                                      ));
                                }))),

                        //       Container(
                        //           padding: EdgeInsets.all(4.0),
                        //           alignment: Alignment.centerLeft,
                        //           decoration: BoxDecoration(
                        //             color: Colors.red,
                        //             borderRadius: BorderRadius.all(
                        //                 Radius.circular(10.0)),
                        //           ),
                        //           child: RichText(
                        //             text: TextSpan(children: [
                        //               TextSpan(
                        //                   text:
                        //                       '${stats[index].split(RegExp(r"(?=[A-Z])")).map((element) => toBeginningOfSentenceCase(element)).join(" ")}\n'),
                        //               TextSpan(
                        //                   text: stats[index] ==
                        //                           'orderId'
                        //                       ? '${widget.orderDoc.getOrderId()}'
                        //                       : stats[index] ==
                        //                               'tableNumber'
                        //                           ? '${widget.orderDoc.getNumberOfCustomers()}'
                        //                           : stats[index] ==
                        //                                   'noOfCustomers'
                        //                               ? '${widget.orderDoc.getTableNumber()}'
                        //                               : stats[index] ==
                        //                                       'totalCost'
                        //                                   ? '${widget.orderDoc.getTotalCost(user.userId)}'
                        //                                   : ""),
                        //             ]),
                        //           )));
                        // }))
                        // )
                      ],
                    ),
                  )),
            ),
            Container(
              height: 600,
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    SizedBox(height: 5.0),
                    Padding(
                      padding: const EdgeInsets.only(left: 14.0, right: 14.0),
                      child: Container(
                        decoration: BoxDecoration(
                            borderRadius:
                                BorderRadius.all(Radius.circular(15.0)),
                            border: Border.all(color: Colors.black),
                            color: Colors.white),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                              'Status : ${OrderDecrypt.orderStaus[widget.orderDoc.orderStatus]}',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold)),
                        ),
                      ),
                    ),
                    DefaultTabController(
                        length: categories.length, // length of tabs
                        initialIndex: 0,
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: <Widget>[
                              Container(
                                child: TabBar(
                                  isScrollable: true,
                                  labelColor: Colors.green,
                                  unselectedLabelColor: Colors.black,
                                  tabs: [
                                    ...categories.map((e) => Tab(text: e))
                                  ],
                                ),
                              ),
                              Container(
                                  height:
                                      size.height * 0.55, //height of TabBarView
                                  decoration: BoxDecoration(
                                      border: Border(
                                          top: BorderSide(
                                              color: Colors.grey, width: 0.5))),
                                  child: TabBarView(children: <Widget>[
                                    ...categories.map((e) => Container(
                                          child: Center(
                                            child: ListView.builder(
                                              clipBehavior: Clip.antiAlias,
                                              shrinkWrap: true,
                                              padding:
                                                  const EdgeInsets.all(10.0),
                                              itemCount: products
                                                  .where((element) =>
                                                      element.category == e)
                                                  .length,
                                              itemBuilder: (ctx, i) =>
                                                  ChangeNotifierProvider.value(
                                                      value: products
                                                          .where((element) =>
                                                              element
                                                                  .category ==
                                                              e)
                                                          .toList()[i],
                                                      child: ProductItem(
                                                          // title: products[i].title,
                                                          // id: products[i].id,
                                                          // imgUrl: products[i].imageUrl,
                                                          // description: products[i].description,
                                                          // price: products[i].price,
                                                          )),
                                            ),
                                          ),
                                        ))
                                  ]))
                            ])),
                  ]),
            ),
          ]),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        child: IconButton(
          icon: Icon(Icons.shopping_cart),
          onPressed: () => {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (_) => ChangeNotifierProvider.value(
                          value: cart,
                          child: CartScreen(orderDoc: widget.orderDoc),
                        )))
          },
        ),
      ),
    );
  }
}
