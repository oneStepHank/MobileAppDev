import 'package:final_exam/model/appstate.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../model/product.dart'; // Product 모델 import

class DetailProduct extends StatefulWidget {
  const DetailProduct({super.key});

  @override
  State<DetailProduct> createState() => _DetailProductState();
}

class _DetailProductState extends State<DetailProduct> {
  @override
  Widget build(BuildContext context) {
    // arguments로 전달된 Product 받기
    final argProduct = ModalRoute.of(context)!.settings.arguments as Product;
    final appState = context.watch<AppState>();

    final uid = FirebaseAuth.instance.currentUser!.uid;
    // 최신 product를 Provider에서 다시 찾기
    final product = appState.products.firstWhere(
      (p) => p.id == argProduct.id,
      orElse: () => argProduct,
    );
    bool _isWished = appState.wishedItem.contains(product.id);
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.blue,
        onPressed:
            _isWished
                ? null // 이미 찜한 경우 비활성화
                : () async {
                  await appState.addWishItem(uid, product.id);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Updated Wished List')),
                  );
                },
        child: Icon(
          _isWished ? Icons.check : Icons.shopping_cart,
          color: Colors.white,
        ),
      ),
      appBar: AppBar(
        title: Text(product.name),
        actions: [
          IconButton(
            onPressed: () async {
              bool isOwner = await appState.checkAuthorized(uid, product.id);
              if (!isOwner) {
                ScaffoldMessenger.of(
                  context,
                ).showSnackBar(SnackBar(content: const Text('Not Allowed')));
              } else {
                Navigator.of(context).pushNamed('/update', arguments: product);
              }
            },
            icon: const Icon(Icons.create),
          ),
          IconButton(
            onPressed: () async {
              try {
                await appState.deleteProduct(uid, product.id);
                Navigator.of(context).pop();
                ScaffoldMessenger.of(
                  context,
                ).showSnackBar(const SnackBar(content: Text('Deleted.')));
              } catch (e) {
                ScaffoldMessenger.of(
                  context,
                ).showSnackBar(SnackBar(content: Text(e.toString())));
              }
            },
            icon: const Icon(Icons.delete),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            product.imgUrl.isNotEmpty
                ? Image.network(
                  product.imgUrl,
                  width: double.infinity,
                  height: 200,
                  fit: BoxFit.cover,
                )
                : Image.network(
                  'https://handong.edu/site/handong/res/img/logo.png',
                  width: double.infinity,
                  height: 200,
                ),
            const SizedBox(height: 16),
            Row(
              children: [
                Row(
                  children: [
                    Text(
                      product.name,
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Row(
                      children: [
                        IconButton(
                          icon: const Icon(
                            Icons.thumb_up,
                            color: Colors.redAccent,
                          ),
                          onPressed: () async {
                            try {
                              String msg = await appState.likeProduct(
                                uid,
                                product.id,
                              );
                              ScaffoldMessenger.of(
                                context,
                              ).showSnackBar(SnackBar(content: Text(msg)));
                            } catch (e) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text(e.toString())),
                              );
                            }
                          },
                        ),
                        Text(
                          '${product.likes}',
                          style: const TextStyle(
                            fontSize: 20,
                            color: Colors.redAccent,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
            Text('\$ ${product.price}', style: const TextStyle(fontSize: 18)),
            const Divider(height: 20),
            Text(product.description),
            const Spacer(), // 이 줄이 아래로 밀어줌
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Creator < ${product.creator} >',
                  style: const TextStyle(color: Colors.grey),
                ),
                Text(
                  'Created : ${product.created}',
                  style: const TextStyle(color: Colors.grey),
                ),
                Text(
                  'Modified : ${product.modified}',
                  style: const TextStyle(color: Colors.grey),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
