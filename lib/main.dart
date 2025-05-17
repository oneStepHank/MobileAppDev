import 'package:final_exam/firebase_options.dart';
import 'package:final_exam/homepage.dart';
import 'package:final_exam/model/appsate.dart';
import 'package:final_exam/sign.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Connect Firebase DB
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => AppSate(),
      child: MaterialApp(
        initialRoute: '/sign',
        routes: {'/': (context) => Homepage(), '/sign': (context) => Sign()},
        title: 'Flutter Demo',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        ),
      ),
    );
  }
}
