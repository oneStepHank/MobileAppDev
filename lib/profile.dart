import 'package:final_exam/model/appstate.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Profile extends StatelessWidget {
  const Profile({super.key});

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: () async {
              await FirebaseAuth.instance.signOut();
              Navigator.of(
                context,
              ).pushNamedAndRemoveUntil('/sign', (route) => false);
            },
            icon: Icon(Icons.exit_to_app),
          ),
        ],
      ),
      body: Consumer<AppState>(
        builder: (context, appState, _) {
          if (user == null) {
            return const Center(child: CircularProgressIndicator());
          }
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Center(
              child: Column(
                children: [
                  user!.isAnonymous
                      ? AnonymousSection(user: user)
                      : GoogleProfileSection(user: user),
                  const SizedBox(height: 100),
                  const Column(
                    children: [
                      Text('HanGyeol Kim'),
                      Text('I promise to take the test honestly before God.'),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class AnonymousSection extends StatelessWidget {
  const AnonymousSection({super.key, required this.user});

  final User? user;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 300,
          height: 300,
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey, width: 2),
            borderRadius: BorderRadius.circular(12),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.network(
              'https://handong.edu/site/handong/res/img/logo.png',
            ),
          ),
        ),
        const SizedBox(height: 16),
        Text(user!.uid),
        Divider(height: 10),
        Text('Anonymous', style: TextStyle(fontWeight: FontWeight.bold)),
      ],
    );
  }
}

class GoogleProfileSection extends StatelessWidget {
  const GoogleProfileSection({super.key, required this.user});

  final User? user;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 300,
          height: 300,
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey, width: 2),
            borderRadius: BorderRadius.circular(12),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.network(
              user!.photoURL ??
                  'https://handong.edu/site/handong/res/img/logo.png',
              fit: BoxFit.fill,
            ),
          ),
        ),
        const SizedBox(height: 16),
        Text(user!.uid),
        Divider(height: 10),
        Text(user!.email!, style: TextStyle(fontWeight: FontWeight.bold)),
      ],
    );
  }
}
