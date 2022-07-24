import 'package:flutter/foundation.dart';

class Product with ChangeNotifier {
  final String id;
  final String title;
  final String description;
  final double price;
  final String imageUrl;
  final String category;
  final int status;
  bool isFavourite;

  Product(
      {@required this.id,
      @required this.description,
      @required this.title,
      @required this.imageUrl,
      this.isFavourite = false,
      @required this.price,
      @required this.category,
      this.status});

  void toggleFavStatus() {
    isFavourite = !isFavourite;
    notifyListeners();
  }
}
