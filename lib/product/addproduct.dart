import 'dart:io';
import 'package:final_exam/model/appstate.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AddItemPage extends StatefulWidget {
  const AddItemPage({super.key});

  @override
  State<AddItemPage> createState() => _AddItemPageState();
}

class _AddItemPageState extends State<AddItemPage> {
  File? _imgFile;
  bool _isLoading = false; // 로딩 상태 변수

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(source: ImageSource.gallery);
    if (picked != null) {
      setState(() {
        _imgFile = File(picked.path);
      });
    }
  }

  final _nameController = TextEditingController();
  final _priceController = TextEditingController();
  final _descController = TextEditingController();

  @override
  void dispose() {
    // dispose
    _nameController.dispose();
    _priceController.dispose();
    _descController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
        title: const Text('Add'),
        actions: [
          TextButton(
            onPressed:
                _isLoading
                    ? null
                    : () async {
                      setState(() {
                        _isLoading = true;
                      });
                      try {
                        final appState = context.read<AppState>();
                        await appState.addProduct(
                          name: _nameController.text,
                          price: int.tryParse(_priceController.text) ?? 0,
                          description: _descController.text,
                          img: _imgFile,
                        );
                        if (mounted) {
                          Navigator.of(context).pop();
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Added!')),
                          );
                        }
                      } finally {
                        if (mounted) {
                          setState(() {
                            _isLoading = false;
                          });
                        }
                      }
                    },
            child: const Text('Save'),
          ),
        ],
      )),
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(
                  height: 200,
                  child:
                      _imgFile != null
                          ? Image.file(_imgFile!)
                          : Image.network(
                            'https://handong.edu/site/handong/res/img/logo.png',
                          ),
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
