import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:shrine/model/hotel.dart';

class MyPage extends StatelessWidget {
  const MyPage({super.key});

  @override
  Widget build(BuildContext context) {
    var hotelState = context.watch<HotelState>();
    var mediaWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Pages'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(30.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              LottieSector(mediaWidth: mediaWidth * 0.5),
              const SizedBox(height: 20),
              const Text(
                'HanGyeol Kim',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              const Text('22100229'),
              const SizedBox(height: 30),
              const Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'My Favorite Hotel List',
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                ),
              ),
              Expanded(
                  child: Padding(
                padding: const EdgeInsets.only(top: 12.0),
                child: ListView(
                    children: hotelState.favoriteList.map((h) {
                  return InkWell(
                    onTap: () {
                      Navigator.pushNamed(context, '/detailHotel',
                          arguments: h);
                    },
                    child: Card(
                      clipBehavior: Clip.antiAlias,
                      child: LayoutBuilder(builder: (context, constraints) {
                        return SizedBox(
                          width: constraints.maxWidth,
                          height: constraints.maxWidth * 2 / 5,
                          child: Stack(
                            children: [
                              Image.asset(
                                  width: constraints.maxWidth,
                                  height: constraints.maxWidth * 2 / 5,
                                  h.img,
                                  fit: BoxFit.cover),
                              Align(
                                alignment: const Alignment(0.8, 0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Text(
                                      h.name,
                                      style: const TextStyle(
                                          fontWeight: FontWeight.w700,
                                          color: Color.fromARGB(
                                              255, 255, 250, 238)),
                                    ),
                                    Text(
                                      h.location,
                                      style: const TextStyle(
                                          fontWeight: FontWeight.w700,
                                          color: Color.fromARGB(
                                              255, 255, 250, 238)),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        );
                      }),
                    ),
                  );
                }).toList()),
              ))
            ],
          ),
        ),
      ),
    );
  }
}

class LottieSector extends StatelessWidget {
  const LottieSector({
    super.key,
    required this.mediaWidth,
  });

  final double mediaWidth;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: mediaWidth * 0.5,
      child: ClipOval(
          child: Lottie.network(
              'https://cdn.lottielab.com/l/4uMomdmrGvEAg6.json')),
    );
  }
}
