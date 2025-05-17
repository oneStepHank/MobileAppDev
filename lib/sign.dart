import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_ui_oauth_google/firebase_ui_oauth_google.dart';
import 'package:flutter/material.dart';

const GOOGLE_CLIENT_ID =
    '977177627097-lp7b7lm9vpsddc1d8p7ts9umt9r5hu4p.apps.googleusercontent.com';

class Sign extends StatefulWidget {
  const Sign({super.key});

  @override
  State<Sign> createState() => _SignState();
}

class _SignState extends State<Sign> {
  bool _isLoading = false;

  Future<void> _signInAnonymous(BuildContext context) async {
    setState(() {
      _isLoading = true;
    });
    try {
      await FirebaseAuth.instance.signInAnonymously();
      Navigator.of(context).popAndPushNamed('/');
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Failed')));
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  width: 300,
                  child: GoogleSignInButton(
                    loadingIndicator: CircularProgressIndicator(),
                    clientId: GOOGLE_CLIENT_ID,
                    onSignedIn: ((credential) async {
                      Navigator.of(context).popAndPushNamed('/');
                    }),
                  ),
                ),
                const SizedBox(height: 24),
                SizedBox(
                  width: 300,

                  child: ElevatedButton(
                    onPressed:
                        _isLoading ? null : () => _signInAnonymous(context),
                    child: const Text('Anonymous Login-in'),
                  ),
                ),
              ],
            ),
          ),
          if (_isLoading)
            Container(
              color: Colors.black.withOpacity(0.3),
              child: const Center(child: CircularProgressIndicator()),
            ),
        ],
      ),
    );
  }
}
