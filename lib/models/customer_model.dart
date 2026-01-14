import 'package:cloud_firestore/cloud_firestore.dart';

class CustomerModel {
  String customerId;
  String email;
  String fullName;
  String phoneNumber;
  String address;
  List<String> preferences; 
  int loyaltyPoints;
  DateTime createdAt;
  bool isActive;

  CustomerModel({
    required this.customerId,
    required this.email,
    required this.fullName,
    required this.phoneNumber,
    required this.address,
    required this.preferences,
    this.loyaltyPoints = 0,
    required this.createdAt,
    this.isActive = true,
  });

  factory CustomerModel.fromSnapshot(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return CustomerModel(
      customerId: doc.id,
      email: data['email'] ?? '',
      fullName: data['fullName'] ?? '',
      phoneNumber: data['phoneNumber'] ?? '',
      address: data['address'] ?? '',
      preferences: List<String>.from(data['preferences'] ?? []),
      loyaltyPoints: data['loyaltyPoints'] ?? 0,
      // Sửa nhẹ chỗ này: Nếu null thì lấy giờ hiện tại để không crash app
      createdAt: data['createdAt'] != null 
          ? (data['createdAt'] as Timestamp).toDate() 
          : DateTime.now(),
      isActive: data['isActive'] ?? true,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'email': email,
      'fullName': fullName,
      'phoneNumber': phoneNumber,
      'address': address,
      'preferences': preferences,
      'loyaltyPoints': loyaltyPoints,
      'createdAt': Timestamp.fromDate(createdAt),
      'isActive': isActive,
    };
  }
}