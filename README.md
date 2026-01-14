# 📱 Flutter App - Project 1771020152

![Flutter](https://img.shields.io/badge/Flutter-%3E%3D3.10.1-02569B?logo=flutter)
![Firebase](https://img.shields.io/badge/Firebase-Core%20%7C%20Auth%20%7C%20Firestore-FFCA28?logo=firebase)
![Dart](https://img.shields.io/badge/Dart-%5E3.10.1-0175C2?logo=dart)

Dự án ứng dụng di động được xây dựng bằng **Flutter**, tích hợp toàn diện với **Firebase** (Authentication, Firestore) và lưu trữ cục bộ. Dự án này được cấu hình để chạy đa nền tảng (Android, iOS, Web, Windows).

## 📋 Giới thiệu

Đây là dự án mã số `1771020152`, được phát triển nhằm mục đích xây dựng ứng dụng quản lý với các chức năng thời gian thực. Ứng dụng sử dụng kiến trúc hiện đại, tuân thủ các quy tắc `lints` chuẩn của Flutter.

**Project ID Firebase:** `exam-firebase-1771020152`

## 🌟 Tính năng chính

Dựa trên các thư viện được khai báo trong `pubspec.yaml`:

* **Xác thực người dùng (Authentication):** Đăng nhập, đăng ký và quản lý phiên người dùng thông qua Firebase Auth.
* **Cơ sở dữ liệu đám mây (Cloud Firestore):** Lưu trữ và đồng bộ dữ liệu thời gian thực (Real-time database).
* **Lưu trữ cục bộ (Local Storage):** Sử dụng `shared_preferences` để lưu cấu hình hoặc trạng thái đăng nhập đơn giản.
* **Định dạng dữ liệu:** Xử lý định dạng tiền tệ và ngày tháng chuyên nghiệp với thư viện `intl`.
* **Giao diện:** Sử dụng Material Design và bộ icon Cupertino cho iOS.

## 🛠️ Công nghệ sử dụng

| Thư viện | Phiên bản | Mục đích |
| :--- | :--- | :--- |
| **Flutter SDK** | `>=3.10.1` | Nền tảng phát triển ứng dụng |
| **firebase_core** | `^3.1.0` | Khởi tạo kết nối Firebase |
| **firebase_auth** | `^5.1.0` | Quản lý xác thực (Login/Register) |
| **cloud_firestore** | `^5.0.0` | Cơ sở dữ liệu NoSQL |
| **shared_preferences**| `^2.2.2` | Lưu trữ Key-Value cục bộ |
| **intl** | `^0.18.1` | Format Date/Currency |

## ⚙️ Yêu cầu cài đặt (Prerequisites)

Để chạy được dự án này, bạn cần cài đặt:

1.  **Flutter SDK**: Phiên bản 3.10.1 trở lên.
2.  **Dart SDK**: Tương thích với Flutter.
3.  **IDE**: VS Code hoặc Android Studio (đã cài plugin Flutter & Dart).
4.  **Java JDK**: Phiên bản 11 hoặc 17 (cho Android build).

## 🚀 Hướng dẫn chạy dự án

### Bước 1: Clone dự án
Tải mã nguồn về máy tính của bạn.

### Bước 2: Cài đặt các gói phụ thuộc
Mở terminal tại thư mục gốc của dự án và chạy lệnh:

```bash
flutter pub get
