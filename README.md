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
fullter pub get

### Bước 3:Cấu hình Firebase
Dự án đã được cấu hình sẵn firebase_options.dart và firebase.json cho dự án exam-firebase-1771020152.

Android: Đảm bảo file google-services.json đã nằm trong thư mục android/app/.

iOS: Đảm bảo file GoogleService-Info.plist đã nằm trong thư mục ios/Runner/.
## Lưu ý: Nếu bạn muốn kết nối với dự án Firebase của riêng mình, hãy chạy lệnh:  flutterfire configure

### Bước 4: Chạy ứng dụng
Chọn thiết bị giả lập (Emulator) hoặc thiết bị thật và chạy: flutter run

### 📂 Cấu trúc thư mục
<img width="848" height="324" alt="image" src="https://github.com/user-attachments/assets/0909d825-6a17-4b17-b76d-d7ce29ceabeb" />

### Những điểm tôi đã tối ưu hóa cho bạn:

1.  **Thông tin phiên bản:** Tôi đã lấy chính xác phiên bản SDK `^3.10.1` từ file `pubspec.yaml`.
2.  **Firebase:** Tôi đã thêm thông tin về `projectId` là `exam-firebase-1771020152` lấy từ file `firebase.json`  để người chấm thi hoặc người xem biết dự án kết nối đến đâu.
3.  **Thư viện:** Tôi liệt kê đầy đủ các thư viện quan trọng (`firebase_auth`, `cloud_firestore`, `intl`,...) và giải thích công dụng của chúng dựa trên danh sách dependencies.
4.  **Cấu hình Font:** Tôi đã thêm một mục riêng về "Cấu hình đặc biệt" vì trong `pubspec.yaml` của bạn có đoạn code custom để sửa lỗi ô vuông (`MaterialIcons-Regular.otf`). Đây là điểm cộng thể hiện sự chi tiết kỹ thuật.
5.  **Cấu trúc thư mục:** Mô tả sơ lược vị trí các file quan trọng.

Bạn có thể copy nội dung trên, tạo một file tên là `README.md` trong thư mục gốc của dự án và dán vào.

### 🤝 Đóng góp & Tác giả
Nguyễn Mạnh Điềm
MSSV: 1771020152
Email: diemmanmhnguyen115@gmail.com
