import 'package:final_exam/model/appstate.dart';
import 'package:final_exam/model/product.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  String _sortOrder = 'asc';

  @override
  Widget build(BuildContext context) {
    final products = context.watch<AppState>().products;
    List<Product> sortedProducts = List.from(products);
    if (_sortOrder == 'desc') {
      sortedProducts = sortedProducts.reversed.toList();
    }

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.person),
          onPressed: () {
            Navigator.pushNamed(context, '/profile');
          },
        ),
        title: const Text('Main'),
        actions: [
          IconButton(
            onPressed: () => Navigator.pushNamed(context, '/wishedList'),
            icon: Icon(Icons.shopping_cart),
          ),
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              Navigator.pushNamed(context, '/add');
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            DropdownButton(
              value: _sortOrder,
              items: const [
                DropdownMenuItem(value: 'asc', child: Text('Asc')),
                DropdownMenuItem(value: 'desc', child: Text('Desc')),
              ],
              onChanged: (value) {
                setState(() {
                  _sortOrder = value!;
                });
              },
            ),
            const SizedBox(height: 16),
            Expanded(
              child: GridView.builder(
                itemCount: sortedProducts.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2, // 한 줄에 2개씩
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  childAspectRatio: 3 / 4, // 카드 비율 조정
                ),
                itemBuilder: (context, index) {
                  final product = sortedProducts[index];
                  return ProductCard(product: product);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ProductCard extends StatelessWidget {
  const ProductCard({super.key, required this.product});
  final Product product;

  @override
  Widget build(BuildContext context) {
    final wishedIds = context.watch<AppState>().wishedItem;
    final isWished = wishedIds.contains(product.id);

    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Stack(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(5),
                    child:
                        product.imgUrl.isNotEmpty
                            ? Image.network(
                              product.imgUrl,
                              width: double.infinity,
                              fit: BoxFit.cover,
                            )
                            : Image.network(
                              'https://handong.edu/site/handong/res/img/logo.png',
                              width: double.infinity,
                              fit: BoxFit.cover,
                            ),
                  ),
                  if (isWished)
                    Positioned(
                      top: 8,
                      right: 8,
                      child: Icon(
                        Icons.check_circle,
                        color: Colors.blue,
                        size: 28,
                      ),
                    ),
                ],
              ),
            ),
            const SizedBox(height: 3),
            Text(
              product.name,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const SizedBox(height: 2),
            Text(
              '\$ ${product.price}',
              style: const TextStyle(fontSize: 12, color: Colors.black87),
            ),
            Align(
              alignment: Alignment.bottomRight,
              child: TextButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/detail', arguments: product);
                },
                child: const Text('more', style: TextStyle(color: Colors.blue)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
