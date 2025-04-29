import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shrine/model/hotel.dart';

class FavoritePages extends StatefulWidget {
  const FavoritePages({super.key});

  @override
  State<FavoritePages> createState() => _FavoritePagesState();
}

class _FavoritePagesState extends State<FavoritePages> {
  @override
  Widget build(BuildContext context) {
    var hotelState = context.watch<HotelState>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Favorite Hotels'),
      ),
      body: ListView(
        children: hotelState.favoriteList.map((hotel) {
          return Dismissible(
            key: ValueKey(hotel.id),
            background: Container(
              color: Colors.red,
              alignment: Alignment.centerRight,
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: const Icon(Icons.delete, color: Colors.white),
            ),
            onDismissed: (direction) {
              setState(() {
                hotelState.removeFavorite(hotel);
                ScaffoldMessenger.of(context)
                    .showSnackBar(const SnackBar(content: Text('Removed')));
              });
            },
            child: Container(
              decoration: const BoxDecoration(
                border: Border(
                  bottom: BorderSide(color: Colors.grey, width: 1),
                ),
              ),
              child: ListTile(
                title: Text(hotel.name),
                subtitle: Text(hotel.location),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}
