import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';
import '../repositories/reservation_repository.dart';
import '../models/reservation_model.dart';

class MyReservationsTab extends StatefulWidget {
  @override
  _MyReservationsTabState createState() => _MyReservationsTabState();
}

class _MyReservationsTabState extends State<MyReservationsTab> {
  final ReservationRepository _repo = ReservationRepository();
  final String? currentUserId = FirebaseAuth.instance.currentUser?.uid;

  // Hàm helper để chọn màu cho trạng thái
  Color _getStatusColor(String status) {
    switch (status) {
      case 'confirmed': return Colors.green;
      case 'completed': return Colors.blue;
      case 'cancelled': return Colors.red;
      default: return Colors.orange; // pending
    }
  }

  @override
  Widget build(BuildContext context) {
    if (currentUserId == null) return Center(child: Text("Vui lòng đăng nhập"));

    return Container(
      color: Colors.grey[50],
      child: FutureBuilder<List<ReservationModel>>(
        future: _repo.getReservationsByCustomer(currentUserId!),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text("Lỗi: ${snapshot.error}"));
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.history, size: 60, color: Colors.grey),
                Text("Bạn chưa có lịch sử đặt bàn nào"),
              ],
            ));
          }

          // Hiển thị danh sách
          return ListView.builder(
            padding: EdgeInsets.all(12),
            itemCount: snapshot.data!.length,
            itemBuilder: (context, index) {
              final item = snapshot.data![index];
              return Card(
                elevation: 3,
                margin: EdgeInsets.only(bottom: 12),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Dòng 1: Ngày giờ và Trạng thái
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Icon(Icons.calendar_today, size: 16, color: Colors.deepOrange),
                              SizedBox(width: 8),
                              Text(
                                DateFormat('dd/MM/yyyy - HH:mm').format(item.reservationDate),
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                          Container(
                            padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: _getStatusColor(item.status).withOpacity(0.1),
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(color: _getStatusColor(item.status)),
                            ),
                            child: Text(
                              item.status.toUpperCase(),
                              style: TextStyle(
                                color: _getStatusColor(item.status),
                                fontWeight: FontWeight.bold,
                                fontSize: 10
                              ),
                            ),
                          )
                        ],
                      ),
                      Divider(),
                      // Dòng 2: Thông tin chi tiết
                      Row(
                        children: [
                          Icon(Icons.people, size: 16, color: Colors.grey),
                          SizedBox(width: 8),
                          Text("${item.numberOfGuests} Khách"),
                          Spacer(),
                          Text(
                            "Tổng: ${NumberFormat.currency(locale: 'vi_VN', symbol: 'đ').format(item.total)}",
                            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
                          ),
                        ],
                      ),
                      if (item.specialRequests != null && item.specialRequests!.isNotEmpty)
                        Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: Text(
                            "Ghi chú: ${item.specialRequests}",
                            style: TextStyle(fontStyle: FontStyle.italic, color: Colors.grey[600]),
                          ),
                        ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}