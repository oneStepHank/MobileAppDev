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
import 'package:provider/provider.dart';
import 'package:shrine/hotel/detail.dart';
import 'package:shrine/hotel/favorite.dart';
import 'package:shrine/model/hotel.dart';
import 'package:shrine/mypage.dart';
import 'package:shrine/search.dart';
import 'package:shrine/SignPage/signup.dart';

import 'home.dart';
import 'SignPage/login.dart';

class ShrineApp extends StatelessWidget {
  const ShrineApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => HotelState(),
      child: MaterialApp(
        title: 'Shrine',
        initialRoute: '/login',
        routes: {
          '/mypage': (BuildContext context) => const MyPage(),
          '/detailHotel': (BuildContext context) => const DetailHotels(),
          '/favorites': (BuildContext context) => const FavoritePages(),
          '/search': (BuildContext context) => const SearchPage(),
          '/signUP': (BuildContext context) => const SignUp(),
          '/login': (BuildContext context) => const LoginPage(),
          '/': (BuildContext context) => const HomePage(),
        },
        theme: ThemeData.light(useMaterial3: true),
      ),
    );
  }
}
