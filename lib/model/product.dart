import 'package:cloud_firestore/cloud_firestore.dart';

class Product {
  final String id;
  final String name;
  final int price;
  final String description;
  final String creator; // uid 등
  final DateTime created;
  final DateTime modified;
  final String imgUrl;
  final int likes; // ← 추가
  final List<String> likedUsers; // ← 추가

  Product({
    required this.id,
    required this.name,
    required this.price,
    required this.description,
    required this.creator,
    required this.created,
    required this.modified,
    required this.imgUrl,
    this.likes = 0, // ← 기본값
    this.likedUsers = const [], // ← 기본값
  });

  // Firestore에서 읽어올 때 사용
  factory Product.fromMap(String id, Map<String, dynamic> map) {
    return Product(
      id: id,
      name: map['name'] ?? '',
      price: map['price'] ?? 0,
      description: map['description'] ?? '',
      creator: map['uid'] ?? '',
      created: (map['createdTime'] as Timestamp).toDate(),
      modified: (map['modifiedTime'] as Timestamp).toDate(),
      imgUrl: map['img'] ?? '',
      likes: map['likes'] ?? 0,
      likedUsers: List<String>.from(map['likedUsers'] ?? []),
    );
  }
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'price': price,
      'description': description,
      'uid': creator,
      'img': imgUrl,
      'createdTime': created,
      'modifiedTime': modified,
      'likes': likes,
      'likedUsers': likedUsers,
    };
  }
}
