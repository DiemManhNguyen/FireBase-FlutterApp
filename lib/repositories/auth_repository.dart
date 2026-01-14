// File: lib/repositories/auth_repository.dart
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/customer_model.dart';

class AuthRepository {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Đăng nhập
  Future<UserCredential> signIn(String email, String password) async {
    return await _auth.signInWithEmailAndPassword(email: email, password: password);
  }

  // Đăng ký (Tạo Auth + Tạo Customer trong Firestore)
  Future<void> signUp({
    required String email,
    required String password,
    required String fullName,
    required String phoneNumber,
  }) async {
    // 1. Tạo tài khoản Authentication
    UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );

    // 2. Chuẩn bị data Customer
    CustomerModel newCustomer = CustomerModel(
      customerId: userCredential.user!.uid, // Lấy UID từ Auth làm ID
      email: email,
      fullName: fullName,
      phoneNumber: phoneNumber,
      address: '', // Mặc định rỗng
      preferences: [],
      loyaltyPoints: 0,
      createdAt: DateTime.now(),
      isActive: true,
    );

    // 3. Lưu vào Firestore collection 'customers'
    await _firestore
        .collection('customers')
        .doc(newCustomer.customerId)
        .set(newCustomer.toMap());
  }

  // Đăng xuất
  Future<void> signOut() async {
    await _auth.signOut();
  }
  
  // Lấy user hiện tại
  User? get currentUser => _auth.currentUser;
}