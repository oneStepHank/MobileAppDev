import 'package:final_exam/model/appstate.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class WishedList extends StatelessWidget {
  const WishedList({super.key});

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    return Scaffold(
      appBar: AppBar(title: const Text('Wish List')),
      body: Consumer<AppState>(
        builder: (context, appState, _) {
          final _wishedIds = appState.wishedItem;
          // 전체 상품 중 찜한 것만 필터링
          final _wishedProducts =
              appState.products
                  .where((p) => _wishedIds.contains(p.id))
                  .toList();
          return Padding(
            padding: const EdgeInsets.all(12.0),
            child: ListView.builder(
              itemCount: _wishedProducts.length,
              itemBuilder: (context, index) {
                final product = _wishedProducts[index];
                return Container(
                  margin: EdgeInsets.fromLTRB(0, 5, 0, 0),
                  decoration: BoxDecoration(color: Colors.white),
                  // 테두리 추가
                  child: ListTile(
                    leading:
                        product.imgUrl.isNotEmpty
                            ? Image.network(
                              product.imgUrl,
                              width: 50,
                              height: 50,
                              fit: BoxFit.cover,
                            )
                            : Image.network(
                              width: 50,
                              height: 50,
                              'https://handong.edu/site/handong/res/img/logo.png',
                            ),
                    title: Text(product.name),
                    trailing: IconButton(
                      onPressed: () {
                        appState.removeWishItem(user!.uid, product.id);
                      },
                      icon: Icon(Icons.delete),
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
