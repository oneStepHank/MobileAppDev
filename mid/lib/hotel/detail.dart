import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shrine/model/hotel.dart';

class DetailHotels extends StatefulWidget {
  const DetailHotels({super.key});

  @override
  State<DetailHotels> createState() => _DetailHotelsState();
}

class _DetailHotelsState extends State<DetailHotels> {
  @override
  Widget build(BuildContext context) {
    final mediaWidth = MediaQuery.of(context).size.width;
    final mediaHeight = MediaQuery.of(context).size.height;
    final Hotel hotel =
        ModalRoute.of(context)!.settings.arguments as Hotel; // Hotel 데이터 추출
    return Scaffold(
      appBar: AppBar(
        title: const Text('Detail'),
      ),
      body: Column(
        children: [
          Column(
            children: [
              // IMAGE SECTOR
              ImageSector(
                  mediaWidth: mediaWidth,
                  mediaHeight: mediaHeight,
                  hotel: hotel),
              // TITLE SECTOR
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    TitleSector(hotel: hotel),
                    const SizedBox(height: 6),
                    const Divider(
                      height: 5,
                    ),
                    const SizedBox(height: 6),
                    Text(hotel.desription)
                  ],
                ),
              )
            ],
          ),
        ],
      ),
    );
  }
}

class ImageSector extends StatefulWidget {
  const ImageSector({
    super.key,
    required this.mediaWidth,
    required this.mediaHeight,
    required this.hotel,
  });

  final double mediaWidth;
  final double mediaHeight;
  final Hotel hotel;

  @override
  State<ImageSector> createState() => _ImageSectorState();
}

class _ImageSectorState extends State<ImageSector> {
  bool _isFavorite = false;
  @override
  Widget build(BuildContext context) {
    var hotelState = context.watch<HotelState>();
    _isFavorite = hotelState.favoriteList.contains(widget.hotel);
    return Stack(
      children: [
        InkWell(
          onDoubleTap: () => setState(() {
            hotelState.toggleFavorite(widget.hotel);
          }),
          child: SizedBox(
              width: widget.mediaWidth,
              height: widget.mediaHeight * 0.4,
              child: Hero(
                  tag: widget.hotel.id,
                  child: Image.asset(widget.hotel.img, fit: BoxFit.cover))),
        ),
        Positioned(
          top: 10,
          right: 10,
          child: _isFavorite
              ? const Icon(Icons.favorite, color: Colors.red)
              : const Icon(Icons.favorite_border, color: Colors.red),
        )
      ],
    );
  }
}

class TitleSector extends StatelessWidget {
  const TitleSector({
    super.key,
    required this.hotel,
  });

  final Hotel hotel;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Star Rating
        Row(
          children: List.generate(
            hotel.stars,
            (index) => const Icon(
              Icons.star,
              color: Colors.amber,
              size: 15,
            ),
          ),
        ),
        // Hotel Name
        AnimatedTextKit(
          animatedTexts: [
            TyperAnimatedText(hotel.name),
          ],
          repeatForever: true,
        ),
        const SizedBox(height: 5),
        // Hotel Location
        Row(
          children: [
            const Icon(Icons.location_on, size: 20, color: Colors.grey),
            const SizedBox(width: 8),
            Text(
              hotel.location,
              style: const TextStyle(
                fontSize: 12,
                color: Colors.grey,
              ),
            ),
          ],
        ),

        const SizedBox(height: 5),
        // Phone Number
        Row(
          children: [
            const Icon(Icons.phone, size: 20, color: Colors.grey),
            const SizedBox(width: 5),
            Text(
              hotel.phoneNum,
              style: const TextStyle(fontSize: 12),
            ),
          ],
        ),
      ],
    );
  }
}
