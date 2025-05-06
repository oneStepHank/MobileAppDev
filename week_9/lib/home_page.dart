// Copyright 2022 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.
import 'package:firebase_auth/firebase_auth.dart' // new
    hide EmailAuthProvider, PhoneAuthProvider; // new
import 'package:flutter/material.dart'; // new
import 'package:gtk_flutter/yes_no_selection.dart';
import 'package:provider/provider.dart'; // new

import 'app_state.dart'; // new
import 'src/authentication.dart'; // new

import 'guest_book.dart';
import 'src/widgets.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Firebase Meetup')),
      body: ListView(
        children: <Widget>[
          Image.asset('assets/codelab.png'),
          const SizedBox(height: 8),
          const IconAndDetail(Icons.calendar_today, 'October 30'),
          const IconAndDetail(Icons.location_city, 'San Francisco'),

          Consumer<ApplicationState>(
            builder:
                (context, appState, _) => AuthFunc(
                  loggedIn: appState.loggedIn,
                  signOut: () {
                    FirebaseAuth.instance.signOut();
                  },
                ),
          ),
          const Divider(
            height: 8,
            thickness: 1,
            indent: 8,
            endIndent: 8,
            color: Colors.grey,
          ),
          const Header("What we'll be doing"),
          const Paragraph(
            'Join us for a day full of Firebase Workshops and Pizza!',
          ),

          Consumer<ApplicationState>(
            builder: (context, appSate, _) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  switch (appSate.attendees) {
                    1 => const Paragraph('1 Person going'),
                    >= 2 => Paragraph('${appSate.attendees} people going'),
                    _ => const Paragraph('No one going'),
                  },
                  if (appSate.loggedIn) ...[
                    YesNoSelection(
                      state: appSate.attending,
                      onSelection: (attending) => appSate.attending = attending,
                    ),
                    const Header('Discussion'),
                    GuestBook(
                      addMessage:
                          (message) => appSate.addMessageToGuestBook(message),
                      messages: appSate.guestBookMessages,
                    ),
                  ],
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}
