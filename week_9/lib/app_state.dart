import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart'
    hide EmailAuthProvider, PhoneAuthProvider;
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_ui_auth/firebase_ui_auth.dart';
import 'package:flutter/material.dart';

import 'firebase_options.dart';
import 'guest_book_message.dart';

enum Attending { yes, no, unknown }

class ApplicationState extends ChangeNotifier {
  ApplicationState() {
    init();
  }
  bool _loggedIn = false;
  bool get loggedIn => _loggedIn;

  int _attendees = 0;
  int get attendees => _attendees;

  StreamSubscription<QuerySnapshot>? _guestBookSubscription;
  List<GuestBookMessage> _guestBookMessages = [];
  List<GuestBookMessage> get guestBookMessages => _guestBookMessages;

  Attending _attending = Attending.unknown;
  StreamSubscription<DocumentSnapshot>? _attendingSubscription;
  Attending get attending => _attending;

  StreamSubscription<QuerySnapshot>? _totalAttendeesSubscription;

  set attending(Attending attending) {
    final userDoc = FirebaseFirestore.instance
        .collection('attendees')
        .doc(FirebaseAuth.instance.currentUser!.uid);
    if (attending == Attending.yes) {
      userDoc.set(<String, dynamic>{'attending': true});
    } else {
      userDoc.set(<String, dynamic>{'attending': false});
    }
  }

  Future<void> init() async {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );

    FirebaseUIAuth.configureProviders([EmailAuthProvider()]);

    FirebaseFirestore.instance
        .collection('attendees')
        .where('attending', isEqualTo: true)
        .snapshots()
        .listen((snapshot) {
          _attendees = snapshot.docs.length;
          notifyListeners();
        });

    FirebaseAuth.instance.userChanges().listen((user) {
      if (user != null) {
        _loggedIn = true;
        _guestBookSubscription = FirebaseFirestore.instance
            .collection('guestbook')
            .orderBy('timestamp', descending: true)
            .snapshots()
            .listen((snapshot) {
              _guestBookMessages = [];
              for (final docs in snapshot.docs) {
                final data = docs.data();
                final timestamp = data['timestamp'] as Timestamp?;
                final messageTime = timestamp?.toDate() ?? DateTime.now();

                _guestBookMessages.add(
                  GuestBookMessage(
                    id: docs.id,
                    uid: data['userId'] as String,
                    time: messageTime,
                    name: data['name'] as String,
                    message: data['text'] as String,
                  ),
                );
              }
              notifyListeners();
            });
        _attendingSubscription = FirebaseFirestore.instance
            .collection('attendees')
            .doc(user.uid)
            .snapshots()
            .listen((snapshot) {
              if (snapshot.data() != null) {
                if (snapshot.data()!['attending'] as bool) {
                  _attending = Attending.yes;
                } else {
                  _attending = Attending.no;
                }
                notifyListeners();
              }
            });
      } else {
        print("--- Logout block started ---"); // 디버깅 로그 추가
        _loggedIn = false;
        _guestBookMessages = [];
        _guestBookSubscription?.cancel();
        _attendingSubscription?.cancel();
        _totalAttendeesSubscription?.cancel();
        _attending = Attending.unknown;
        print("Attending state set to: $_attending"); // 상태 확인 로그
        notifyListeners();
      }
      // notifyListeners();
    });
  }

  Future<DocumentReference> addMessageToGuestBook(String message) {
    if (!_loggedIn) {
      throw Exception('Must be logged in');
    }

    return FirebaseFirestore.instance
        .collection('guestbook')
        .add(<String, dynamic>{
          'text': message,
          'timestamp': FieldValue.serverTimestamp(),
          'name': FirebaseAuth.instance.currentUser!.displayName,
          'userId': FirebaseAuth.instance.currentUser!.uid,
        });
  }
}
