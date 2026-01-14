import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/reservation_model.dart';

class ReservationRepository {
  final CollectionReference _reservationRef =
      FirebaseFirestore.instance.collection('reservations');

  // Hàm tạo đặt bàn mới (Cập nhật theo Model mới)
  Future<void> createReservation({
    required DateTime date,
    required int guests,
    required String requests,
  }) async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user == null) throw Exception("Chưa đăng nhập");

    // Tạo đối tượng Model mới
    ReservationModel newRes = ReservationModel(
      customerId: user.uid,
      reservationDate: date,
      numberOfGuests: guests,
      specialRequests: requests,
      status: 'pending',
      paymentStatus: 'pending',
      orderItems: [], // Mặc định chưa có món
      subtotal: 0,
      total: 0,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );

    // Lưu vào Firestore
    await _reservationRef.add(newRes.toMap());
  }
}