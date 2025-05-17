import 'package:final_exam/model/appstate.dart';
import 'package:final_exam/model/product.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import 'dart:io';

class UpdateProduct extends StatefulWidget {
  const UpdateProduct({super.key});

  @override
  State<UpdateProduct> createState() => _UpdateProductState();
}

class _UpdateProductState extends State<UpdateProduct> {
  File? _imgFile;
  late TextEditingController _nameController;
  late TextEditingController _priceController;
  late TextEditingController _descController;
  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(source: ImageSource.gallery);
    if (picked != null) {
      setState(() {
        _imgFile = File(picked.path);
      });
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final product = ModalRoute.of(context)!.settings.arguments as Product;
    _nameController = TextEditingController(text: product.name);
    _priceController = TextEditingController(text: product.price.toString());
    _descController = TextEditingController(text: product.description);
  }

  @override
  Widget build(BuildContext context) {
    final product = ModalRoute.of(context)!.settings.arguments as Product;
    return Scaffold(
      appBar: (AppBar(
        leadingWidth: 100,
        leading: SizedBox(
          child: TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text('cancel'),
          ),
        ),
        title: const Text('Edit'),
        actions: [
          TextButton(
            onPressed: () async {
              final appState = context.read<AppState>();
              String? newImgUrl;

              // 이미지가 변경된 경우에만 업로드
              if (_imgFile != null) {
                // 기존 이미지가 있다면 삭제 (선택)
                if (product.imgUrl.isNotEmpty) {
                  await appState.deleteImage(product.imgUrl);
                }
                newImgUrl = await appState.uploadImage(_imgFile!);
              }

              await appState.updateProduct(
                id: product.id,
                name: _nameController.text,
                price: int.parse(_priceController.text),
                description: _descController.text,
                imgUrl: newImgUrl, // 변경된 경우에만 전달
              );
              Navigator.of(context).pushReplacementNamed('/');
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(const SnackBar(content: Text('Modified!')));
            },
            child: const Text('Save'),
          ),
        ],
      )),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: 200,
              child:
                  _imgFile != null
                      ? Image.file(_imgFile!)
                      : (product.imgUrl.isEmpty
                          ? Image.network(
                            'https://handong.edu/site/handong/res/img/logo.png',
                          )
                          : Image.network(product.imgUrl)),
            ),
            Divider(height: 10),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      IconButton(
                        onPressed: _pickImage,
                        icon: Icon(Icons.camera_alt),
                      ),
                    ],
                  ),
                  TextFormField(
                    controller: _nameController,
                    decoration: const InputDecoration(
                      label: Text('Product Name'),
                    ),
                  ),
                  TextFormField(
                    controller: _priceController,
                    keyboardType: TextInputType.numberWithOptions(),
                    decoration: const InputDecoration(label: Text('Price')),
                  ),
                  TextFormField(
                    controller: _descController,
                    decoration: const InputDecoration(
                      label: Text('Description'),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
