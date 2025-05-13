import 'package:final_exam/firebase_options.dart';
import 'package:firebase_ui_oauth_google/firebase_ui_oauth_google.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart'
    hide EmailAuthProvider, PhoneAuthProvider;
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_ui_auth/firebase_ui_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AppSate extends ChangeNotifier {
  // @constructor
  AppSate() {
    init();
  }

  bool _loggedIn = false;
  bool get loggedIn => _loggedIn;

  Future<void> init() async {
    // Connect Firebase DB
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );

    FirebaseUIAuth.configureProviders([
      GoogleProvider(
        clientId:
            '977177627097-lp7b7lm9vpsddc1d8p7ts9umt9r5hu4p.apps.googleusercontent.com',
      ),
    ]);

    // monitoring user logged state.
    FirebaseAuth.instance.userChanges().listen((user) {
      // Log-In status
      if (user != null) {
        _loggedIn = true;
        notifyListeners();
      } else {
        // Log-Out status
      }
    });
  }
}
