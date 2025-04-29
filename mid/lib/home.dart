// Copyright 2018-present the Flutter authors. All Rights Reserved.
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
// http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

import 'package:flutter/material.dart';
import 'package:shrine/model/hotel.dart';
import 'package:shrine/model/hotel_repository.dart';
import 'package:url_launcher/url_launcher.dart';

const List<Widget> toggledIcons = [
  Icon(Icons.list),
  Icon(Icons.grid_view_rounded)
];

final Uri _url = Uri.parse('https://handong.edu');

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Card> _buildGridCards(BuildContext context) {
    List<Hotel> hotels = HotelRepository.createHotelList();

    if (hotels.isEmpty) {
      return const <Card>[];
    }

    return hotels.map((hotel) {
      return Card(
        clipBehavior: Clip.antiAlias,
        child: LayoutBuilder(builder: (context, constraints) {
          final double availableWidth = constraints.maxWidth;
          final double availableHeight = constraints.maxHeight;
          // 폰트 사이즈 비율 정의
          const double nameFontSizeRatio = 0.06;
          const double locationFontSizeRatio = 0.05;
          const double iconSizeRatio = 0.04;

          final double nameFontSize = availableWidth * nameFontSizeRatio;
          final double locationFontSize =
              availableWidth * locationFontSizeRatio;
          final double iconSize = availableWidth * iconSizeRatio;

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Hero(
                tag: hotel.id,
                child: AspectRatio(
                    aspectRatio: 18 / 11,
                    child: Image.asset(hotel.img, fit: BoxFit.cover)),
              ),
              Flexible(
                fit: FlexFit.loose,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(12.0, 12.0, 6.0, 12.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Row(children: [
                        for (int i = 0; i < hotel.stars; i++)
                          Icon(
                            Icons.star,
                            size: availableWidth * 0.06,
                            color: Colors.amber,
                          )
                      ]),
                      Text(
                        overflow: TextOverflow.ellipsis,
                        hotel.name,
                        softWrap: true,
                        maxLines: 2,
                        style: TextStyle(
                            fontSize: nameFontSize,
                            fontWeight: FontWeight.bold),
                      ),

                      SizedBox(height: availableHeight * 0.02),
                      // locdation section
                      Row(
                        children: [
                          Icon(
                            Icons.location_pin,
                            size: iconSize,
                          ),
                          const SizedBox(width: 1.0),
                          Expanded(
                            child: Text(
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontSize: locationFontSize,
                              ),
                              hotel.location,
                              softWrap: false,
                            ),
                          )
                        ],
                      ),
                      Align(
                        alignment: Alignment.bottomRight,
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(0, 3.0, 2.0, 0),
                          child: ToDetailPage(
                            nameFontSize: nameFontSize,
                            hotel: hotel,
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ],
          );
        }),
      );
    }).toList();
  }

  List<Card> _buildListViews(BuildContext context) {
    const imageHeight = 80.0; // 원하는 이미지 섹터 높이
    const aspectRatio = 4 / 3;

    List<Hotel> hotels = HotelRepository.createHotelList();
    if (hotels.isEmpty) {
      return <Card>[];
    }
    return hotels.map((hotel) {
      return Card(
        clipBehavior: Clip.antiAlias,
        child: LayoutBuilder(builder: (context, constraints) {
          final double availableWidth = constraints.maxWidth;
          final double availableHeight = constraints.maxHeight;
          // 폰트 사이즈 비율 정의
          const double nameFontSizeRatio = 0.03;
          const double locationFontSizeRatio = 0.02;
          const double iconSizeRatio = 0.03;

          final double nameFontSize = availableWidth * nameFontSizeRatio;
          final double locationFontSize =
              availableWidth * locationFontSizeRatio;
          final double iconSize = availableWidth * iconSizeRatio;

          return Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(
                height: imageHeight,
                width: imageHeight * aspectRatio, // 높이에 맞춰 너비 계산
                child: Hero(
                  tag: hotel.id,
                  child: AspectRatio(
                    aspectRatio: aspectRatio,
                    child: Image.asset(hotel.img, fit: BoxFit.cover),
                  ),
                ),
              ),
              SizedBox(
                width: availableWidth * 0.04,
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        for (int i = 0; i < hotel.stars; i++)
                          Icon(size: iconSize, Icons.star, color: Colors.amber)
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      hotel.name,
                      style: TextStyle(
                          fontWeight: FontWeight.bold, fontSize: nameFontSize),
                    ),
                    Text(
                      hotel.location,
                      style: TextStyle(fontSize: locationFontSize),
                    ),
                    Align(
                        alignment: const Alignment(0.8, 1),
                        child: ToDetailPage(
                          hotel: hotel,
                          nameFontSize: nameFontSize,
                        ))
                  ],
                ),
              )
            ],
          );
        }),
      );
    }).toList();
  }

  final List<bool> _selectedView = <bool>[false, true];
  Future<void> _launchUrl() async {
    if (!await launchUrl(_url)) {
      throw Exception('Could not launch $_url');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // drawer
      drawer: const HomePageDrawer(),
      appBar: AppBar(
        // Drawer button
        leading: Builder(builder: (context) {
          return IconButton(
            icon: const Icon(
              Icons.menu,
              semanticLabel: 'menu',
            ),
            onPressed: () {
              Scaffold.of(context).openDrawer();
            },
          );
        }),
        title: const Text('Main'),
        actions: <Widget>[
          IconButton(
            icon: const Icon(
              Icons.search,
              semanticLabel: 'search',
            ),
            onPressed: () {
              Navigator.pushNamed(context, '/search');
            },
          ),
          IconButton(
            icon: const Icon(
              Icons.language,
              semanticLabel: 'filter',
            ),
            onPressed: _launchUrl,
          ),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          // Toggle Buttons
          Padding(
            padding: const EdgeInsets.fromLTRB(0, 10, 10, 5),
            child: ToggleButtons(
              constraints: const BoxConstraints(minWidth: 50, minHeight: 30),
              onPressed: (index) {
                setState(() {
                  for (var i = 0; i < toggledIcons.length; i++) {
                    _selectedView[i] = (i == index);
                  }
                });
              },
              isSelected: _selectedView,
              children: toggledIcons,
            ),
          ),
          // Items
          _selectedView[1]
              ? Expanded(
                  child: OrientationBuilder(builder: (context, orientation) {
                  return GridView.count(
                    crossAxisCount: orientation == Orientation.portrait ? 2 : 3,
                    padding: const EdgeInsets.all(16.0),
                    childAspectRatio: 8.0 / 9.0,
                    children: _buildGridCards(context),
                  );
                }))
              : Expanded(
                  child: ListView(
                  children: _buildListViews(context),
                ))
        ],
      ),
      resizeToAvoidBottomInset: false,
    );
  }
}

class ToDetailPage extends StatelessWidget {
  const ToDetailPage({
    super.key,
    required this.nameFontSize,
    required this.hotel,
  });

  final double nameFontSize;
  final Hotel hotel;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(
          context,
          '/detailHotel',
          arguments: hotel,
        );
      },
      child: Text(
        'more',
        style: TextStyle(
            color: const Color.fromARGB(255, 0, 140, 255),
            fontSize: nameFontSize),
      ),
    );
  }
}

class HomePageDrawer extends StatelessWidget {
  const HomePageDrawer({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Drawer(
        child: ListView(
      padding: EdgeInsets.zero,
      children: [
        const DrawerHeader(
          decoration: BoxDecoration(color: Colors.blue),
          child: Padding(
            padding: EdgeInsets.all(12.0),
            child: Text(
                style: TextStyle(
                    fontSize: 20,
                    color: Colors.white,
                    fontWeight: FontWeight.bold),
                'Pages'),
          ),
        ),
        // Home LIST ITEM
        ListTile(
          onTap: () => Navigator.pop(context),
          contentPadding: const EdgeInsets.fromLTRB(24, 0, 12, 0),
          leading: const Icon(Icons.home),
          title: const Text('Home'),
        ),
        // search LIST ITEM
        ListTile(
          onTap: () {
            Navigator.pop(context);
            Navigator.pushNamed(context, '/search');
          },
          contentPadding: const EdgeInsets.fromLTRB(24, 0, 12, 0),
          leading: const Icon(Icons.search),
          title: const Text('Search'),
        ),
        // favorite LIST ITEM
        ListTile(
          onTap: () {
            Navigator.pop(context);
            Navigator.pushNamed(context, '/favorites');
          },
          contentPadding: const EdgeInsets.fromLTRB(24, 0, 12, 0),
          leading: const Icon(Icons.location_city),
          title: const Text('Favorite Hotel'),
        ),
        // My Page LIST ITEM
        ListTile(
          onTap: () {
            Navigator.pop(context);
            Navigator.pushNamed(context, '/mypage');
          },
          contentPadding: const EdgeInsets.fromLTRB(24, 0, 12, 0),
          leading: const Icon(Icons.person),
          title: const Text('My Page'),
        ),
        ListTile(
          onTap: () {
            Navigator.pushReplacementNamed(context, '/login');
          },
          contentPadding: const EdgeInsets.fromLTRB(24, 0, 12, 0),
          leading: const Icon(Icons.logout),
          title: const Text('Log Out'),
        ),
      ],
    ));
  }
}
