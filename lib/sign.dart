import 'package:firebase_ui_auth/firebase_ui_auth.dart';
import 'package:firebase_ui_oauth_google/firebase_ui_oauth_google.dart';
import 'package:flutter/material.dart';

class Sign extends StatelessWidget {
  const Sign({super.key});

  @override
  Widget build(BuildContext context) {
    return SignInScreen(
      actions: [
        AuthStateChangeAction<SignedIn>((context, state) {
          print('로그인 성공! 메인으로 이동');
          Navigator.of(context, rootNavigator: true).pushReplacementNamed('/');
        }),
      ],
      providers: [
        GoogleProvider(
          clientId:
              '977177627097-lp7b7lm9vpsddc1d8p7ts9umt9r5hu4p.apps.googleusercontent.com',
        ),
      ],
    );
  }
}
