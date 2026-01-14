import 'package:cloud_firestore/cloud_firestore.dart';

class ReservationModel {
  String? reservationId; // Sửa thành nullable để dễ tạo mới
  final String customerId;
  final DateTime reservationDate;
  final int numberOfGuests;
  final String? tableNumber;
  final String status;
  final String? specialRequests;
  final List<Map<String, dynamic>> orderItems; // Danh sách món ăn
  final double subtotal;
  final double serviceCharge;
  final double discount;
  final double total;
  final String? paymentMethod;
  final String paymentStatus;
  final DateTime createdAt;
  final DateTime updatedAt;

  ReservationModel({
    this.reservationId, // Không bắt buộc khi tạo mới
    required this.customerId,
    required this.reservationDate,
    required this.numberOfGuests,
    this.tableNumber,
    this.status = 'pending',
    this.specialRequests,
    this.orderItems = const [], // Mặc định là danh sách rỗng
    this.subtotal = 0.0,
    this.serviceCharge = 0.0,
    this.discount = 0.0,
    this.total = 0.0,
    this.paymentMethod,
    this.paymentStatus = 'pending',
    required this.createdAt,
    required this.updatedAt,
  });

  // Factory nhận dữ liệu từ Firestore
  factory ReservationModel.fromSnapshot(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return ReservationModel(
      reservationId: doc.id, // Lấy ID từ Document
      customerId: data['customerId'] ?? '',
      reservationDate: (data['reservationDate'] as Timestamp).toDate(),
      numberOfGuests: data['numberOfGuests'] ?? 0,
      tableNumber: data['tableNumber'],
      status: data['status'] ?? 'pending',
      specialRequests: data['specialRequests'],
      orderItems: List<Map<String, dynamic>>.from(data['orderItems'] ?? []),
      subtotal: (data['subtotal'] ?? 0).toDouble(),
      serviceCharge: (data['serviceCharge'] ?? 0).toDouble(),
      discount: (data['discount'] ?? 0).toDouble(),
      total: (data['total'] ?? 0).toDouble(),
      paymentMethod: data['paymentMethod'],
      paymentStatus: data['paymentStatus'] ?? 'pending',
      createdAt: (data['createdAt'] as Timestamp).toDate(),
      updatedAt: (data['updatedAt'] as Timestamp).toDate(),
    );
  }

  // Chuyển đổi thành Map để lưu lên Firestore
  Map<String, dynamic> toMap() {
    return {
      'customerId': customerId,
      'reservationDate': Timestamp.fromDate(reservationDate),
      'numberOfGuests': numberOfGuests,
      'tableNumber': tableNumber,
      'status': status,
      'specialRequests': specialRequests,
      'orderItems': orderItems,
      'subtotal': subtotal,
      'serviceCharge': serviceCharge,
      'discount': discount,
      'total': total,
      'paymentMethod': paymentMethod,
      'paymentStatus': paymentStatus,
      'createdAt': Timestamp.fromDate(createdAt),
      'updatedAt': Timestamp.fromDate(updatedAt),
    };
  }
}