import 'package:flutter/material.dart';
import '../repositories/auth_repository.dart';
import '../services/dummy_data_service.dart'; // <--- [QUAN TRỌNG] Import file tạo dữ liệu mẫu
import 'home_screen.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passController = TextEditingController();
  final AuthRepository _authRepo = AuthRepository();

  // Xử lý Đăng nhập
  void _handleLogin() async {
    try {
      await _authRepo.signIn(
        _emailController.text.trim(),
        _passController.text.trim(),
      );
      // Đăng nhập thành công -> Vào Menu
      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => HomeScreen()),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Lỗi: ${e.toString()}")),
      );
    }
  }

  // Hàm đăng ký nhanh (để test cho lẹ)
  void _handleQuickRegister() async {
    try {
      await _authRepo.signUp(
        email: _emailController.text.trim(),
        password: _passController.text.trim(),
        fullName: "Sinh Vien Test",
        phoneNumber: "0909123456",
      );
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Đã tạo tk thành công! Hãy bấm Đăng nhập.")));
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Lỗi ĐK: $e")));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Login - 1771020152"), // Mã Sinh Viên của bạn
        backgroundColor: Colors.orange,
      ),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: SingleChildScrollView( // Thêm cái này để không bị lỗi tràn màn hình khi phím hiện lên
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(height: 50), // Khoảng cách
              TextField(
                controller: _emailController,
                decoration: InputDecoration(
                  labelText: "Email",
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.email),
                ),
              ),
              SizedBox(height: 10),
              TextField(
                controller: _passController,
                decoration: InputDecoration(
                  labelText: "Password",
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.lock),
                ),
                obscureText: true,
              ),
              SizedBox(height: 20),
              
              // Nút Đăng nhập
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: _handleLogin,
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.orange),
                  child: Text("ĐĂNG NHẬP", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                ),
              ),
              
              SizedBox(height: 10),
              
              // Nút Đăng ký nhanh
              TextButton(
                onPressed: _handleQuickRegister,
                child: Text("Chưa có TK? Đăng ký nhanh (với email/pass ở trên)"),
              ),

              Divider(height: 40, thickness: 1),

              // --- NÚT BÍ MẬT TẠO DATA MẪU ---
              TextButton.icon(
                onPressed: () async {
                  try {
                    // Gọi hàm tạo data
                    await DummyDataService().generateDummyData();
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text("Đã tạo 20 món ăn mẫu thành công!")),
                    );
                  } catch (e) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text("Lỗi tạo data: $e")),
                    );
                  }
                },
                icon: Icon(Icons.data_saver_on, color: Colors.red),
                label: Text("Tạo Dữ Liệu Mẫu (Chỉ bấm 1 lần)", 
                  style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}