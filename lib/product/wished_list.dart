import 'package:final_exam/model/appstate.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class WishedList extends StatelessWidget {
  const WishedList({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Wish List')),
      body: Consumer<AppState>(
        builder: (context, appState, _) {
          return ListView(children: [Text('Hello')]);
        },
      ),
    );
  }
}
