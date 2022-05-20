import 'package:flutter/cupertino.dart';

import 'package:flutter/material.dart';
import '../models/product.dart';

class Products with ChangeNotifier {
  List<Product> _items = [
    Product(
      id: 'p1',
      title: 'Filtered Coffee',
      description: 'Latte Machiato glasses of 280ml',
      price: 1.99,
      imageUrl:
          'https://images.pexels.com/photos/4547567/pexels-photo-4547567.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1',
    ),
    Product(
      id: 'p2',
      title: 'Latte Machiato',
      description: 'Latte Machiato glasses of 280ml.',
      price: 4.99,
      imageUrl:
          'https://images.pexels.com/photos/4349777/pexels-photo-4349777.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1',
    ),
    Product(
      id: 'p3',
      title: 'Cloud Macchiato',
      description: 'Latte Machiato glasses of 280ml.',
      price: 5.49,
      imageUrl:
          'https://images.pexels.com/photos/573916/pexels-photo-573916.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1',
    ),
    Product(
      id: 'p4',
      title: 'Espresso',
      description: 'Latte Machiato glasses of 280ml.',
      price: 1.49,
      imageUrl:
          'https://images.pexels.com/photos/849643/pexels-photo-849643.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1',
    ),
  ];

  var _showFavOnly = false;

  List<Product> get items {
    if (_showFavOnly) {
      return _items.where((prodItem) => prodItem.isFavourite == true).toList();
    }

    return [..._items];
  }

  void addProduct() {
    // _items.add(value);
    notifyListeners();
  }


  List<Product> get faouriteItems{
    return _items.where((prod) => prod.isFavourite == true).toList();
  }

  // void showFavsOnly(){
  //   _showFavOnly = true;
  //   notifyListeners();
  // }

  //  void showAll(){
  //   _showFavOnly = false;
  //   notifyListeners();
  // }
}
