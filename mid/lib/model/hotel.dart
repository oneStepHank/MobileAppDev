import 'package:flutter/material.dart';

class Hotel {
  final String name;
  final int id;
  final String location;
  final String phoneNum;
  final String desription;
  final int stars;
  final String img;
  Hotel(
      {required this.id,
      required this.name,
      required this.location,
      required this.phoneNum,
      required this.desription,
      required this.stars,
      required this.img});
}

class HotelState extends ChangeNotifier {
  GlobalKey? historyListKey;
  var favorites = <Hotel>[];

  List<Hotel> get favoriteList => favorites;

  void toggleFavorite(Hotel h) {
    if (favorites.contains(h)) {
      favorites.remove(h);
    } else {
      favorites.add(h);
    }
    notifyListeners();
  }

  void removeFavorite(Hotel h) {
    favorites.remove(h);
    notifyListeners();
  }
}
