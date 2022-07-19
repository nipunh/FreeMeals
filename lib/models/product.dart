import 'package:flutter/foundation.dart';

class Product with ChangeNotifier{

  final String id;
  final String title;
  final String description;
  final double price;
  final String imageUrl;
  final String category;
  bool isFavourite;

  Product({@required this.id, @required this.description, @required this.title, @required this.imageUrl, this.isFavourite = false ,@required  this.price, @required this.category});

  void toggleFavStatus(){
    isFavourite = !isFavourite;
    notifyListeners();
  }

}