import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart'; // <--- Thêm import này để lấy User hiện tại
import '../models/reservation_model.dart';
import '../models/menu_item_model.dart';
import '../models/customer_model.dart';

class ReservationRepository {
  final CollectionReference _resCollection =
      FirebaseFirestore.instance.collection('reservations');
  
  final CollectionReference _customerCollection =
      FirebaseFirestore.instance.collection('customers');

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // 1. Đặt Bàn (Create Reservation) - ĐÃ SỬA ĐỂ KHỚP VỚI MÀN HÌNH ĐẶT BÀN
  Future<void> createReservation({
    required DateTime date,
    required int guests,
    required String requests,
  }) async {
    // Tự động lấy User ID đang đăng nhập
    User? user = FirebaseAuth.instance.currentUser;
    if (user == null) throw Exception("Vui lòng đăng nhập để đặt bàn");

    DocumentReference docRef = _resCollection.doc();
    
    // Tạo ReservationModel với các giá trị mặc định
    ReservationModel reservation = ReservationModel(
      reservationId: docRef.id,
      customerId: user.uid, // Dùng ID thật của user
      reservationDate: date,
      numberOfGuests: guests,
      specialRequests: requests,
      status: 'pending',
      paymentStatus: 'pending',
      orderItems: [],
      subtotal: 0,
      total: 0,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );

    // Lưu vào Firestore
    await docRef.set(reservation.toMap());
  }

  // 2. Thêm Món vào Đơn (Add Item) - Logic cao cấp giữ nguyên
  Future<void> addItemToReservation(
      String reservationId, MenuItemModel item, int quantity) async {
    
    if (!item.isAvailable) throw Exception("Món ăn không còn phục vụ");

    DocumentReference resRef = _resCollection.doc(reservationId);

    await _firestore.runTransaction((transaction) async {
      DocumentSnapshot snapshot = await transaction.get(resRef);
      if (!snapshot.exists) throw Exception("Reservation not found");

      ReservationModel res = ReservationModel.fromSnapshot(snapshot);

      double itemTotal = item.price * quantity;
      
      Map<String, dynamic> newItem = {
        'itemId': item.itemId,
        'itemName': item.name,
        'quantity': quantity,
        'price': item.price,
        'subtotal': itemTotal,
      };

      List<Map<String, dynamic>> updatedItems = List.from(res.orderItems);
      updatedItems.add(newItem);

      // Tính toán lại tổng tiền
      double newSubtotal = res.subtotal + itemTotal;
      double newServiceCharge = newSubtotal * 0.10; // 10% phí phục vụ
      double newTotal = newSubtotal + newServiceCharge - res.discount;

      transaction.update(resRef, {
        'orderItems': updatedItems,
        'subtotal': newSubtotal,
        'serviceCharge': newServiceCharge,
        'total': newTotal,
        'updatedAt': Timestamp.now(),
      });
    });
  }

  // 3. Xác nhận Đặt Bàn (Confirm)
  Future<void> confirmReservation(String reservationId, String tableNumber) async {
    await _resCollection.doc(reservationId).update({
      'status': 'confirmed',
      'tableNumber': tableNumber,
      'updatedAt': Timestamp.now(),
    });
  }

  // 4. Thanh toán (Pay) - Logic tính điểm thưởng giữ nguyên
  Future<void> payReservation(String reservationId, String paymentMethod) async {
    await _firestore.runTransaction((transaction) async {
      // BƯỚC 1: Đọc Reservation
      DocumentReference resRef = _resCollection.doc(reservationId);
      DocumentSnapshot resSnapshot = await transaction.get(resRef);
      
      if (!resSnapshot.exists) throw Exception("Reservation not found");
      ReservationModel res = ReservationModel.fromSnapshot(resSnapshot);

      // BƯỚC 2: Đọc Customer
      DocumentReference customerRef = _customerCollection.doc(res.customerId);
      DocumentSnapshot customerSnapshot = await transaction.get(customerRef);

      // Nếu không tìm thấy customer (lỗi dữ liệu cũ), tạo customer ảo để không crash app
      int currentLoyaltyPoints = 0;
      if (customerSnapshot.exists) {
         CustomerModel customer = CustomerModel.fromSnapshot(customerSnapshot);
         currentLoyaltyPoints = customer.loyaltyPoints;
      }

      // --- Tính toán logic ---
      double maxDiscount = res.total * 0.5;
      double potentialDiscount = currentLoyaltyPoints * 1000.0;
      
      double actualDiscount = 0;
      int pointsUsed = 0;

      if (potentialDiscount > maxDiscount) {
        actualDiscount = maxDiscount;
        pointsUsed = (maxDiscount / 1000).ceil();
      } else {
        actualDiscount = potentialDiscount;
        pointsUsed = currentLoyaltyPoints;
      }

      double finalTotal = res.total - actualDiscount;

      // Cập nhật Reservation
      transaction.update(resRef, {
        'discount': actualDiscount,
        'total': finalTotal,
        'paymentMethod': paymentMethod,
        'paymentStatus': 'paid',
        'status': 'completed',
        'updatedAt': Timestamp.now(),
      });

      // Cập nhật Customer Loyalty (nếu customer tồn tại)
      if (customerSnapshot.exists) {
        int pointsEarned = (finalTotal * 0.01 / 1000).round(); 
        if (pointsEarned < 0) pointsEarned = 0;
        int newLoyaltyPoints = currentLoyaltyPoints - pointsUsed + pointsEarned;

        transaction.update(customerRef, {
          'loyaltyPoints': newLoyaltyPoints
        });
      }
    });
  }

  // 5. Lấy danh sách đặt bàn theo Customer
  Future<List<ReservationModel>> getReservationsByCustomer(String customerId) async {
    QuerySnapshot snapshot = await _resCollection
        .where('customerId', isEqualTo: customerId)
        .orderBy('reservationDate', descending: true)
        .get();
    
    return snapshot.docs.map((doc) => ReservationModel.fromSnapshot(doc)).toList();
  }

  // 6. Lấy danh sách đặt bàn theo Ngày
  Future<List<ReservationModel>> getReservationsByDate(DateTime date) async {
    DateTime startOfDay = DateTime(date.year, date.month, date.day);
    DateTime endOfDay = startOfDay.add(const Duration(days: 1));

    QuerySnapshot snapshot = await _resCollection
        .where('reservationDate', isGreaterThanOrEqualTo: Timestamp.fromDate(startOfDay))
        .where('reservationDate', isLessThan: Timestamp.fromDate(endOfDay))
        .get();

    return snapshot.docs.map((doc) => ReservationModel.fromSnapshot(doc)).toList();
  }
}