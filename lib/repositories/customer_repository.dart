import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/customer_model.dart';

class CustomerRepository {
  final CollectionReference _customerRef =
      FirebaseFirestore.instance.collection('customers');

  // 1. Lưu thông tin khách hàng mới (Đã khớp với Model của bạn)
  Future<void> createCustomer({
    required String uid,
    required String email,
    required String fullName,
    required String phone,
  }) async {
    // Tạo Model với các giá trị mặc định cho trường thiếu
    CustomerModel newCustomer = CustomerModel(
      customerId: uid,
      email: email,
      fullName: fullName,
      phoneNumber: phone,
      address: '',              // Mặc định rỗng
      preferences: [],          // Mặc định rỗng
      loyaltyPoints: 0,
      createdAt: DateTime.now(), // Lấy giờ hiện tại
      isActive: true,
    );

    // Lưu lên Firestore
    await _customerRef.doc(uid).set(newCustomer.toMap());
  }

  // 2. Lấy thông tin khách hàng
  Future<CustomerModel?> getCurrentCustomer() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user == null) return null;

    DocumentSnapshot doc = await _customerRef.doc(user.uid).get();
    if (doc.exists) {
      return CustomerModel.fromSnapshot(doc);
    }
    return null;
  }
}