import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';

class CartItem {
  final String id;
  final String title;
  final int quantity;
  final double price;
  final int status;

  CartItem(
      {@required this.id,
      @required this.price,
      @required this.quantity,
      @required this.title,
      this.status});
}

class Cart with ChangeNotifier {
  Map<String, CartItem> _items = {};

  Map<String, CartItem> get items {
    return {..._items};
  }

  int get itemCount {
    return _items == null ? 0 : _items.length;
  }

  double get totalAmount {
    double total = 0.0;
    // print(_items);
    _items.forEach((key, cartItem) {
      total += cartItem.price * cartItem.quantity;
    });

    return total;
  }

  void addItem(String productId, String title, double price, int status) {
    if (_items.containsKey(productId)) {
      _items.update(
          productId,
          (existingItem) => CartItem(
              id: existingItem.id,
              price: existingItem.price,
              quantity: existingItem.quantity + 1,
              title: existingItem.title,
              status: existingItem.status));
    } else {
      _items.putIfAbsent(
          productId,
          () => new CartItem(
              id: DateTime.now().toString(),
              price: price,
              quantity: 1,
              title: title,
              status: status));
    }

    notifyListeners();
  }

  void removeItem(String productId) {
    _items.remove(productId);
    notifyListeners();
  }

  void clearCart() {
    _items.clear();
    notifyListeners();
  }

  void updateQuantity(String productId, int type) {
    if (_items.containsKey(productId)) {
      print("update");
      _items.update(
          productId,
          (existingItem) => CartItem(
              id: existingItem.id,
              price: existingItem.price,
              quantity: type == 0
                  ? existingItem.quantity + 1
                  : existingItem.quantity - 1,
              title: existingItem.title,
              status: 0));
    }
    notifyListeners();
  }
}
