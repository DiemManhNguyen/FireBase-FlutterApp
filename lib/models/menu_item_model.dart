import 'package:cloud_firestore/cloud_firestore.dart';

class MenuItemModel {
  String itemId;
  String name;
  String description;
  String category; // "Appetizer", "Main Course", etc.
  double price;
  String imageUrl;
  List<String> ingredients;
  bool isVegetarian;
  bool isSpicy;
  int preparationTime;
  bool isAvailable;
  double rating;
  DateTime createdAt;

  MenuItemModel({
    required this.itemId,
    required this.name,
    required this.description,
    required this.category,
    required this.price,
    required this.imageUrl,
    required this.ingredients,
    required this.isVegetarian,
    required this.isSpicy,
    required this.preparationTime,
    this.isAvailable = true,
    this.rating = 0.0,
    required this.createdAt,
  });

  factory MenuItemModel.fromSnapshot(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return MenuItemModel(
      itemId: doc.id,
      name: data['name'] ?? '',
      description: data['description'] ?? '',
      category: data['category'] ?? '',
      price: (data['price'] ?? 0).toDouble(),
      imageUrl: data['imageUrl'] ?? '',
      ingredients: List<String>.from(data['ingredients'] ?? []),
      isVegetarian: data['isVegetarian'] ?? false,
      isSpicy: data['isSpicy'] ?? false,
      preparationTime: data['preparationTime'] ?? 0,
      isAvailable: data['isAvailable'] ?? true,
      rating: (data['rating'] ?? 0).toDouble(),
      createdAt: (data['createdAt'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'description': description,
      'category': category,
      'price': price,
      'imageUrl': imageUrl,
      'ingredients': ingredients,
      'isVegetarian': isVegetarian,
      'isSpicy': isSpicy,
      'preparationTime': preparationTime,
      'isAvailable': isAvailable,
      'rating': rating,
      'createdAt': Timestamp.fromDate(createdAt),
    };
  }
}