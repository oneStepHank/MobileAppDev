import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_ui_auth/firebase_ui_auth.dart';
import 'package:firebase_ui_oauth_google/firebase_ui_oauth_google.dart';
import 'package:flutter/material.dart';

const GOOGLE_CLIENT_ID =
    '977177627097-lp7b7lm9vpsddc1d8p7ts9umt9r5hu4p.apps.googleusercontent.com';

class Sign extends StatelessWidget {
  const Sign({super.key});
  Future<void> _signInAnonymous(BuildContext context) async {
    try {
      await FirebaseAuth.instance.signInAnonymously();
      Navigator.of(context).popAndPushNamed('/');
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Failed')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          GoogleSignInButton(
            loadingIndicator: CircularProgressIndicator(),
            clientId: GOOGLE_CLIENT_ID,
            onSignedIn: ((credential) async {
              Navigator.of(context).popAndPushNamed('/');
            }),
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: () => _signInAnonymous(context),
            child: const Text('Guest'),
          ),
        ],
      ),
    );
  }
}
