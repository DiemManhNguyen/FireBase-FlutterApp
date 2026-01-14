import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/menu_item_model.dart'; // Đảm bảo import đúng đường dẫn

class MenuScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Restaurant App - 1771020152"), // Mã SV của bạn
        backgroundColor: Colors.orange,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('menu_items').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) return Center(child: Text("Lỗi tải dữ liệu"));
          if (!snapshot.hasData) return Center(child: CircularProgressIndicator());

          var docs = snapshot.data!.docs;
          
          if (docs.isEmpty) return Center(child: Text("Chưa có món ăn nào"));

          return GridView.builder(
            padding: EdgeInsets.all(10),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 0.75, // Chỉnh lại tỷ lệ cho đẹp hơn
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
            ),
            itemCount: docs.length,
            itemBuilder: (context, index) {
              // SỬA LỖI 1: Dùng đúng tên hàm fromSnapshot
              MenuItemModel item = MenuItemModel.fromSnapshot(docs[index]);

              return Card(
                elevation: 3,
                // Nếu hết món thì làm mờ đi
                color: item.isAvailable ? Colors.white : Colors.grey[200],
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Expanded(
                      // SỬA LỖI 2: Kiểm tra chuỗi rỗng thay vì null
                      child: item.imageUrl.isNotEmpty
                          ? Image.network(
                              item.imageUrl,
                              fit: BoxFit.cover,
                              errorBuilder: (ctx, err, stack) => Icon(Icons.broken_image), // Xử lý nếu link ảnh chết
                            )
                          : Container(
                              color: Colors.grey[300],
                              child: Icon(Icons.fastfood, size: 50, color: Colors.grey),
                            ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            item.name,
                            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          SizedBox(height: 4),
                          Text(
                            "${item.price.toStringAsFixed(0)} VND", // Format số tiền
                            style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold),
                          ),
                          if (!item.isAvailable)
                            Text(
                              "HẾT MÓN",
                              style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold, fontSize: 12),
                            ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}