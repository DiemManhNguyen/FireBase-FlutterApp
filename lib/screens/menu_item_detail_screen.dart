import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class MenuItemDetailScreen extends StatefulWidget {
  final Map<String, dynamic> data; // Nhận dữ liệu món ăn từ màn hình trước

  const MenuItemDetailScreen({Key? key, required this.data}) : super(key: key);

  @override
  _MenuItemDetailScreenState createState() => _MenuItemDetailScreenState();
}

class _MenuItemDetailScreenState extends State<MenuItemDetailScreen> {
  int _quantity = 1; // Số lượng mặc định mua

  // Hàm format tiền
  String formatCurrency(num price) {
    return NumberFormat.currency(locale: 'vi_VN', symbol: 'đ').format(price);
  }

  @override
  Widget build(BuildContext context) {
    final data = widget.data;
    final bool isAvailable = data['isAvailable'] ?? false;

    return Scaffold(
      appBar: AppBar(
        title: Text(data['name'] ?? "Chi tiết món"),
        backgroundColor: Colors.deepOrange,
      ),
      body: Column(
        children: [
          // 1. Phần nội dung cuộn được
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Ảnh bìa món ăn
                  Container(
                    width: double.infinity,
                    height: 250,
                    color: Colors.grey[200],
                    child: data['imageUrl'] != null
                        ? Image.network(
                            data['imageUrl'],
                            fit: BoxFit.cover,
                            errorBuilder: (_, __, ___) => Icon(Icons.fastfood, size: 80, color: Colors.grey),
                          )
                        : Icon(Icons.fastfood, size: 80, color: Colors.grey),
                  ),

                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Tên và Giá
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Text(
                                data['name'] ?? "Tên món",
                                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                              ),
                            ),
                            Text(
                              formatCurrency(data['price'] ?? 0),
                              style: TextStyle(fontSize: 20, color: Colors.deepOrange, fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                        SizedBox(height: 8),

                        // Các Badge (Cay, Chay, Category)
                        Wrap(
                          spacing: 8,
                          children: [
                            Chip(
                              label: Text(data['category'] ?? "Khác"),
                              backgroundColor: Colors.orange[100],
                            ),
                            if (data['isSpicy'] == true)
                              Chip(
                                avatar: Icon(Icons.whatshot, size: 16, color: Colors.white),
                                label: Text("Cay", style: TextStyle(color: Colors.white)),
                                backgroundColor: Colors.red,
                              ),
                            if (data['isVegetarian'] == true)
                              Chip(
                                avatar: Icon(Icons.grass, size: 16, color: Colors.white),
                                label: Text("Chay", style: TextStyle(color: Colors.white)),
                                backgroundColor: Colors.green,
                              ),
                          ],
                        ),
                        SizedBox(height: 16),

                        // Mô tả
                        Text("Mô tả:", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                        SizedBox(height: 4),
                        Text(
                          data['description'] ?? "Chưa có mô tả cho món ăn này.",
                          style: TextStyle(color: Colors.grey[700], height: 1.5),
                        ),
                        SizedBox(height: 16),

                        // Nguyên liệu (Yêu cầu đề bài)
                        if (data['ingredients'] != null && (data['ingredients'] as List).isNotEmpty) ...[
                          Text("Nguyên liệu chính:", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                          SizedBox(height: 8),
                          Wrap(
                            spacing: 8,
                            children: (data['ingredients'] as List).map((ing) {
                              return Chip(
                                label: Text(ing.toString()),
                                backgroundColor: Colors.grey[200],
                              );
                            }).toList(),
                          ),
                        ],
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          // 2. Thanh Bottom Bar (Đặt mua)
          Container(
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 10, offset: Offset(0, -5))],
            ),
            child: Row(
              children: [
                // Nút tăng giảm số lượng
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey[300]!),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      IconButton(
                        icon: Icon(Icons.remove),
                        onPressed: _quantity > 1 ? () => setState(() => _quantity--) : null,
                      ),
                      Text("$_quantity", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                      IconButton(
                        icon: Icon(Icons.add),
                        onPressed: () => setState(() => _quantity++),
                      ),
                    ],
                  ),
                ),
                SizedBox(width: 16),
                
                // Nút Thêm vào đơn
                Expanded(
                  child: ElevatedButton(
                    onPressed: isAvailable
                        ? () {
                            // Xử lý thêm vào giỏ hàng (Hiện tại chỉ thông báo)
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text("Đã thêm $_quantity ${data['name']} vào đơn!"),
                                backgroundColor: Colors.green,
                              ),
                            );
                            Navigator.pop(context);
                          }
                        : null, // Nếu hết hàng thì disable nút
                    style: ElevatedButton.styleFrom(
                      backgroundColor: isAvailable ? Colors.deepOrange : Colors.grey,
                      padding: EdgeInsets.symmetric(vertical: 16),
                    ),
                    child: Text(
                      isAvailable ? "THÊM VÀO ĐƠN" : "HẾT HÀNG",
                      style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}