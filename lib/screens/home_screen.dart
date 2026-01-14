import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'menu_tab.dart'; 
import 'my_reservations_tab.dart';
import 'profile_tab.dart'; 
import 'login_screen.dart';
import 'create_reservation_screen.dart'; 

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0; // Tab hiện tại đang chọn

  // Danh sách các màn hình con (Đã thêm ProfileTab)
  final List<Widget> _tabs = [
    MenuTab(),           // Tab 0: Thực đơn
    MyReservationsTab(), // Tab 1: Lịch sử
    ProfileTab(),        // Tab 2: Thông tin cá nhân (MỚI)
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // AppBar
      appBar: AppBar(
        title: Text("Restaurant - 1771020152", style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.deepOrange,
        centerTitle: true,
        automaticallyImplyLeading: false, // Tắt nút back mặc định
      ),
      
      // Hiển thị màn hình tương ứng với tab đang chọn
      body: _tabs[_currentIndex], 
      
      // Thanh điều hướng dưới đáy (Đã thêm item thứ 3)
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        selectedItemColor: Colors.deepOrange,
        unselectedItemColor: Colors.grey,
        type: BottomNavigationBarType.fixed, // Giữ cố định vị trí icon
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.restaurant_menu),
            label: "Thực Đơn",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.history),
            label: "Lịch Sử",
          ),
          // --- THÊM ITEM NÀY ---
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: "Cá Nhân",
          ),
          // ---------------------
        ],
      ),
      
      // Nút đặt bàn nổi (Chỉ hiện khi ở Tab Menu)
      floatingActionButton: _currentIndex == 0 ? FloatingActionButton.extended(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => CreateReservationScreen()),
          );
        },
        label: Text("ĐẶT BÀN NGAY"),
        icon: Icon(Icons.calendar_today),
        backgroundColor: Colors.deepOrange,
      ) : null,
    );
  }
}