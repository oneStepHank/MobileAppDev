import 'dart:io';

import 'package:final_exam/model/product.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart'
    hide EmailAuthProvider, PhoneAuthProvider;
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

class AppState extends ChangeNotifier {
  // @constructor
  AppState() {
    init();
  }

  bool _loggedIn = false;
  bool get loggedIn => _loggedIn;

  List<Product> _products = [];
  List<String> _wisedItems = [];
  List<String> get wishedItem => _wisedItems;
  List<Product> get products => _products;
  StreamSubscription<QuerySnapshot>? _productSubscription;
  StreamSubscription<DocumentSnapshot>? _wishSubscription;

  Future<void> init() async {
    // monitoring user logged state.
    FirebaseAuth.instance.userChanges().listen((user) {
      // Log-In status
      if (user != null) {
        _loggedIn = true;
        createUser(user); // 유저정보 저장
        _productSubscription = FirebaseFirestore.instance
            .collection('product')
            .orderBy('price', descending: false)
            .snapshots()
            .listen((snapshot) {
              _products =
                  snapshot.docs
                      .map((doc) => Product.fromMap(doc.id, doc.data()))
                      .toList();
              notifyListeners();
            });
        // wished item 구독
        _wishSubscription?.cancel();
        _wishSubscription = FirebaseFirestore.instance
            .collection('user')
            .doc(user.uid)
            .snapshots()
            .listen((doc) {
              _wisedItems = List<String>.from(doc['wishedList'] ?? []);
              notifyListeners();
            });
        notifyListeners();
      } else {
        _loggedIn = false;
        _productSubscription?.cancel();
        _wishSubscription?.cancel();
        _products = [];
        _wisedItems = [];
        notifyListeners();
        notifyListeners();
      }
    });
  }

  Future<void> addWishItem(String uid, String productId) async {
    final doc = FirebaseFirestore.instance.collection('user').doc(uid);
    await doc.update({
      'wishedList': FieldValue.arrayUnion([productId]),
    });
  }

  Future<void> removeWishItem(String uid, String productId) async {
    final doc = FirebaseFirestore.instance.collection('user').doc(uid);
    await doc.update({
      'wishedList': FieldValue.arrayRemove([productId]),
    });
  }

  Future<void> createUser(User user) async {
    final doc = FirebaseFirestore.instance.collection('user').doc(user.uid);
    final snapshot = await doc.get();

    if (!snapshot.exists) {
      // Google 로그인: displayName, email이 있음
      if (user.isAnonymous) {
        // 익명 로그인
        await doc.set({
          'uid': user.uid,
          'status_message': 'I promise to take the test honestly before GOD.',
          'wishedList': <String>[],
        });
      } else {
        // Google 로그인
        await doc.set({
          'name': '${user.displayName!}학부생',
          'email': user.email ?? '',
          'uid': user.uid,
          'status_message': 'I promise to take the test honestly before GOD.',
          'wishedList': <String>[],
        });
      }
    }
  }

  Future<String?> uploadImage(File imgFile) async {
    try {
      final fileName = DateTime.now().millisecondsSinceEpoch.toString();
      final ref = FirebaseStorage.instance.ref().child('product/$fileName');
      await ref.putFile(imgFile);
      final url = await ref.getDownloadURL();

      return url;
    } catch (e) {
      return null;
    }
  }

  Future<void> deleteImage(String imgUrl) async {
    try {
      final ref = FirebaseStorage.instance.refFromURL(imgUrl);
      await ref.delete();
    } catch (e) {
      // 에러 무시 (이미 삭제된 경우 등)
    }
  }

  Future<void> updateProduct({
    required String id,
    required String name,
    required int price,
    required String description,
    String? imgUrl,
  }) async {
    final doc = FirebaseFirestore.instance.collection('product').doc(id);

    await doc.update({
      'name': name,
      'price': price,
      'description': description,
      if (imgUrl != null) 'img': imgUrl, // 이미지가 있으면 업데이트
      'modifiedTime': FieldValue.serverTimestamp(),
    });
  }

  Future<void> addProduct({
    required String name,
    required int price,
    required String description,
    File? img,
  }) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;
    String? imgUrl;
    if (img != null) {
      imgUrl = await uploadImage(img);
    }

    FirebaseFirestore.instance.collection('product').add({
      'name': name,
      'price': price,
      'description': description,
      'uid': user.uid,
      'img': imgUrl,
      'createdTime': FieldValue.serverTimestamp(),
      'modifiedTime': FieldValue.serverTimestamp(),
      'likes': 0,
      'likedUsers': <String>[],
    });
  }

  Future<bool> checkAuthorized(String uid, String productId) async {
    final doc = FirebaseFirestore.instance.collection('product').doc(productId);
    final snapshot = await doc.get();

    // 문서가 존재하고, 작성자 uid가 일치하면 true, 아니면 false
    if (snapshot.exists && snapshot['uid'] == uid) {
      return true;
    } else {
      return false;
    }
  }

  Future<void> deleteProduct(String uid, String id) async {
    final doc = FirebaseFirestore.instance.collection('product').doc(id);
    final snapshot = await doc.get();

    // 문서가 존재하고, 작성자 uid가 일치할 때만 삭제
    if (snapshot.exists && snapshot['uid'] == uid) {
      await doc.delete();
    } else {
      throw Exception('Not Allowed!');
    }
  }

  Future<String> likeProduct(String uid, String productId) async {
    final doc = FirebaseFirestore.instance.collection('product').doc(productId);
    final snapshot = await doc.get();

    if (!snapshot.exists) {
      throw Exception('상품이 존재하지 않습니다.');
    }

    final likedUsers = List<String>.from(snapshot['likedUsers'] ?? []);
    if (likedUsers.contains(uid)) {
      return 'You can only do it once !!';
    }

    await doc.update({
      'likes': FieldValue.increment(1),
      'likedUsers': FieldValue.arrayUnion([uid]),
    });
    ChangeNotifier();
    return 'I Liked it!';
  }
}
