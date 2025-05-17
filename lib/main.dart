import 'package:final_exam/product/updateproduct.dart';
import 'package:final_exam/product/addproduct.dart';
import 'package:final_exam/firebase_options.dart';
import 'package:final_exam/homepage.dart';
import 'package:final_exam/model/appstate.dart';
import 'package:final_exam/product/detail.dart';
import 'package:final_exam/product/wished_list.dart';
import 'package:final_exam/profile.dart';
import 'package:final_exam/sign.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(const AppRoot());
}

// Connect Firebase DB
class AppRoot extends StatelessWidget {
  const AppRoot({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      ),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          return const MyApp();
        }
        return const MaterialApp(
          home: Scaffold(body: Center(child: CircularProgressIndicator())),
        );
      },
    );
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => AppState(),
      child: Consumer<AppState>(
        builder: (context, appState, _) {
          return MaterialApp(
            initialRoute: appState.loggedIn ? '/' : '/sign',
            routes: {
              '/': (context) => Homepage(),
              '/sign': (context) => Sign(),
              '/add': (context) => AddItemPage(),
              '/update': (context) => UpdateProduct(),
              '/detail': (context) => DetailProduct(),
              '/profile': (context) => Profile(),
              '/wishedList': (context) => WishedList(),
            },
            title: 'Final Exam',
            theme: ThemeData(
              colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
            ),
          );
        },
      ),
    );
  }
}
