import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/menu_item_model.dart';

class MenuItemRepository {
  final CollectionReference _menuCollection =
      FirebaseFirestore.instance.collection('menu_items');

  // 1. Thêm MenuItem (3 điểm)
  Future<void> addMenuItem(MenuItemModel item) async {
    // Nếu chưa có ID, Firestore tự tạo, nhưng model cần ID. 
    // Nên tạo doc trước để lấy ID rồi set data.
    if (item.itemId.isEmpty) {
      DocumentReference docRef = _menuCollection.doc();
      item.itemId = docRef.id;
      await docRef.set(item.toMap());
    } else {
      await _menuCollection.doc(item.itemId).set(item.toMap());
    }
  }

  // 2. Lấy MenuItem theo ID (2 điểm)
  Future<MenuItemModel?> getMenuItemById(String id) async {
    DocumentSnapshot doc = await _menuCollection.doc(id).get();
    if (doc.exists) {
      return MenuItemModel.fromSnapshot(doc);
    }
    return null;
  }

  // 3. Lấy tất cả MenuItems (2 điểm) - Stream để real-time
  Stream<List<MenuItemModel>> getAllMenuItems() {
    return _menuCollection.snapshots().map((snapshot) {
      return snapshot.docs.map((doc) => MenuItemModel.fromSnapshot(doc)).toList();
    });
  }

  // 4. Tìm kiếm MenuItems (4 điểm) - Tìm trong name, description, ingredients
  // Do Firestore search hạn chế, cách tốt nhất cho bài thi là tải về và lọc ở Client (hoặc dùng thư viện search bên thứ 3)
  // Dưới đây là cách lọc phía Client (phù hợp với quy mô bài thi nhỏ)
  Future<List<MenuItemModel>> searchMenuItems(String query) async {
    QuerySnapshot snapshot = await _menuCollection.get();
    List<MenuItemModel> allItems = snapshot.docs
        .map((doc) => MenuItemModel.fromSnapshot(doc))
        .toList();
    
    if (query.isEmpty) return allItems;

    String lowerQuery = query.toLowerCase();
    return allItems.where((item) {
      bool nameMatch = item.name.toLowerCase().contains(lowerQuery);
      bool descMatch = item.description.toLowerCase().contains(lowerQuery);
      // Tìm trong mảng ingredients
      bool ingredientMatch = item.ingredients.any((ing) => ing.toLowerCase().contains(lowerQuery));
      
      return nameMatch || descMatch || ingredientMatch;
    }).toList();
  }

  // 5. Lọc MenuItems (3 điểm)
  Stream<List<MenuItemModel>> filterMenuItems({
    String? category,
    bool? isVegetarian,
    bool? isSpicy,
  }) {
    Query query = _menuCollection;

    if (category != null && category.isNotEmpty) {
      query = query.where('category', isEqualTo: category);
    }
    if (isVegetarian != null) {
      query = query.where('isVegetarian', isEqualTo: isVegetarian);
    }
    if (isSpicy != null) {
      query = query.where('isSpicy', isEqualTo: isSpicy);
    }

    return query.snapshots().map((snapshot) {
      return snapshot.docs.map((doc) => MenuItemModel.fromSnapshot(doc)).toList();
    });
  }
}