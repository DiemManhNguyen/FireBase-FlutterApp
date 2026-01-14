import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../repositories/customer_repository.dart';
import '../models/customer_model.dart';
import 'login_screen.dart';

class ProfileTab extends StatelessWidget {
  final CustomerRepository _repo = CustomerRepository();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<CustomerModel?>(
      future: _repo.getCurrentCustomer(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }
        
        CustomerModel customer = snapshot.data ?? CustomerModel(
          customerId: '', email: '...', fullName: 'Khách hàng', phoneNumber: '...',
          address: '', preferences: [], createdAt: DateTime.now()
        );

        return SingleChildScrollView(
          padding: EdgeInsets.all(16),
          child: Column(
            children: [
              SizedBox(height: 20),
              CircleAvatar(
                radius: 50,
                backgroundColor: Colors.deepOrange.shade100,
                child: Icon(Icons.person, size: 50, color: Colors.deepOrange),
              ),
              SizedBox(height: 16),
              
              Text(customer.fullName, style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
              Text(customer.email, style: TextStyle(color: Colors.grey)),
              
              SizedBox(height: 30),

              // Thẻ Điểm (Vẫn giữ nguyên)
              Card(
                elevation: 4,
                color: Colors.deepOrange,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                child: Padding(
                  padding: EdgeInsets.all(20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("ĐIỂM TÍCH LŨY", style: TextStyle(color: Colors.white70, fontSize: 12)),
                          SizedBox(height: 4),
                          Text("${customer.loyaltyPoints} điểm", style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold)),
                        ],
                      ),
                      Icon(Icons.stars, color: Colors.white, size: 40),
                    ],
                  ),
                ),
              ),
              
              SizedBox(height: 20),

              // --- PHẦN MỚI: Hiển thị thêm Địa chỉ & Sở thích ---
              ListTile(
                leading: Icon(Icons.phone, color: Colors.deepOrange),
                title: Text("Số điện thoại"),
                subtitle: Text(customer.phoneNumber.isNotEmpty ? customer.phoneNumber : "Chưa cập nhật"),
              ),
              Divider(),
              ListTile(
                leading: Icon(Icons.location_on, color: Colors.deepOrange),
                title: Text("Địa chỉ"),
                subtitle: Text(customer.address.isNotEmpty ? customer.address : "Chưa cập nhật địa chỉ"),
              ),
              Divider(),
              // Hiển thị Sở thích bằng Chip
              if (customer.preferences.isNotEmpty) ...[
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Wrap(
                      spacing: 8,
                      children: customer.preferences.map((pref) => Chip(
                        label: Text(pref),
                        backgroundColor: Colors.orange.shade50,
                        avatar: Icon(Icons.favorite, size: 14, color: Colors.red),
                      )).toList(),
                    ),
                  ),
                ),
                Divider(),
              ],

              SizedBox(height: 40),

              // Nút Đăng xuất
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () async {
                    await FirebaseAuth.instance.signOut();
                    if (context.mounted) {
                      Navigator.of(context).pushReplacement(
                        MaterialPageRoute(builder: (_) => LoginScreen())
                      );
                    }
                  },
                  icon: Icon(Icons.logout, color: Colors.white),
                  label: Text("ĐĂNG XUẤT", style: TextStyle(color: Colors.white)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    padding: EdgeInsets.symmetric(vertical: 12),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}