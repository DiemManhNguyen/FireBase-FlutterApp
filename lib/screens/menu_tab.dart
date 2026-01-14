import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'menu_item_detail_screen.dart'; // <--- Đừng quên import file mới tạo

class MenuTab extends StatelessWidget {
  String formatCurrency(num price) {
    return NumberFormat.currency(locale: 'vi_VN', symbol: 'đ').format(price);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.grey[100],
      child: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('menu_items').where('isAvailable', isEqualTo: true).snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) return Center(child: Text("Lỗi tải dữ liệu"));
          if (snapshot.connectionState == ConnectionState.waiting) return Center(child: CircularProgressIndicator());

          var docs = snapshot.data!.docs;
          if (docs.isEmpty) return Center(child: Text("Chưa có món ăn nào"));

          return GridView.builder(
            padding: EdgeInsets.all(12),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: MediaQuery.of(context).size.width > 600 ? 4 : 2,
              childAspectRatio: 0.75,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
            ),
            itemCount: docs.length,
            itemBuilder: (context, index) {
              var data = docs[index].data() as Map<String, dynamic>;
              
              // --- SỬA Ở ĐÂY: Thêm InkWell để bắt sự kiện bấm ---
              return InkWell(
                onTap: () {
                  // Chuyển sang màn hình chi tiết
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => MenuItemDetailScreen(data: data),
                    ),
                  );
                },
                child: Card(
                  elevation: 4,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                  clipBehavior: Clip.antiAlias,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Ảnh món ăn
                      Expanded(
                        flex: 3,
                        child: Container(
                          width: double.infinity,
                          color: Colors.orange[50],
                          child: data['imageUrl'] != null && data['imageUrl'].toString().isNotEmpty
                              ? Image.network(
                                  data['imageUrl'],
                                  fit: BoxFit.cover,
                                  errorBuilder: (c, e, s) => Icon(Icons.fastfood, size: 50, color: Colors.orange),
                                )
                              : Icon(Icons.fastfood, size: 50, color: Colors.orange),
                        ),
                      ),
                      
                      // Thông tin
                      Expanded(
                        flex: 2,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    data['name'] ?? 'Món ăn',
                                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  SizedBox(height: 4),
                                  Row(
                                    children: [
                                      if (data['isSpicy'] == true) 
                                        Icon(Icons.whatshot, color: Colors.red, size: 16),
                                      if (data['isVegetarian'] == true) 
                                        Icon(Icons.grass, color: Colors.green, size: 16),
                                      SizedBox(width: 4),
                                      Text(data['category'] ?? '', style: TextStyle(color: Colors.grey, fontSize: 12)),
                                    ],
                                  ),
                                ],
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    formatCurrency(data['price'] ?? 0),
                                    style: TextStyle(color: Colors.deepOrange, fontWeight: FontWeight.bold, fontSize: 15),
                                  ),
                                  CircleAvatar(
                                    radius: 14,
                                    backgroundColor: Colors.deepOrange,
                                    child: Icon(Icons.add, color: Colors.white, size: 18),
                                  )
                                ],
                              )
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
              // -------------------------------------------------
            },
          );
        },
      ),
    );
  }
}