import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
// Import màn hình đăng nhập (đảm bảo file này tồn tại trong thư mục lib/screens/)
import 'screens/login_screen.dart'; 
import 'firebase_options.dart'; // <-- QUAN TRỌNG: Đã bỏ comment dòng này

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    // SỬA LẠI: Thêm options để Web nhận diện được cấu hình
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform, 
    );
    print("Firebase initialized successfully");
  } catch (e) {
    print("Firebase initialization failed: $e");
  }
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Restaurant App - 1771020152', 
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.orange),
        useMaterial3: true,
      ),
      home: LoginScreen(), 
    );
  }
}