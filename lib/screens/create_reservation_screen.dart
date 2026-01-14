import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // Cần gói intl
import 'package:cloud_firestore/cloud_firestore.dart';
import '../repositories/reservation_repository.dart';

class CreateReservationScreen extends StatefulWidget {
  @override
  _CreateReservationScreenState createState() => _CreateReservationScreenState();
}

class _CreateReservationScreenState extends State<CreateReservationScreen> {
  final _requestsController = TextEditingController();
  final _repo = ReservationRepository();
  
  DateTime _selectedDate = DateTime.now().add(Duration(days: 1)); // Mặc định là ngày mai
  TimeOfDay _selectedTime = TimeOfDay(hour: 18, minute: 00); // Mặc định 18:00
  int _guests = 2; // Mặc định 2 người
  bool _isLoading = false;

  // Hàm chọn ngày
  void _pickDate() async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(Duration(days: 30)),
      builder: (context, child) {
        // Đổi màu DatePicker cho đồng bộ màu cam
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: Colors.deepOrange, 
              onPrimary: Colors.white, 
              onSurface: Colors.black, 
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) setState(() => _selectedDate = picked);
  }

  // Hàm chọn giờ
  void _pickTime() async {
    TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: _selectedTime,
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: Colors.deepOrange,
              onPrimary: Colors.white,
              onSurface: Colors.black,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) setState(() => _selectedTime = picked);
  }

  // Hàm Gửi đặt bàn
  void _submitReservation() async {
    setState(() => _isLoading = true);
    try {
      // Gộp Ngày và Giờ lại thành 1 biến DateTime
      final fullDateTime = DateTime(
        _selectedDate.year,
        _selectedDate.month,
        _selectedDate.day,
        _selectedTime.hour,
        _selectedTime.minute,
      );

      // Gọi Repository (Nó sẽ tự điền các trường thiếu như status, orderItems...)
      await _repo.createReservation(
        date: fullDateTime,
        guests: _guests,
        requests: _requestsController.text.trim(),
      );

      // Kiểm tra xem màn hình còn hiển thị không trước khi báo thành công
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Đặt bàn thành công!"), backgroundColor: Colors.green),
        );
        Navigator.pop(context); // Quay về màn hình chính
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Lỗi: $e"), backgroundColor: Colors.red),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Đặt Bàn Mới"),
        backgroundColor: Colors.deepOrange,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Thông tin đặt bàn", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            SizedBox(height: 20),
            
            // 1. CHỌN NGÀY GIỜ
            Row(
              children: [
                Expanded(
                  child: InkWell(
                    onTap: _pickDate,
                    child: InputDecorator(
                      decoration: InputDecoration(
                        labelText: "Ngày", border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.calendar_today, color: Colors.deepOrange),
                      ),
                      child: Text(DateFormat('dd/MM/yyyy').format(_selectedDate)),
                    ),
                  ),
                ),
                SizedBox(width: 10),
                Expanded(
                  child: InkWell(
                    onTap: _pickTime,
                    child: InputDecorator(
                      decoration: InputDecoration(
                        labelText: "Giờ", border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.access_time, color: Colors.deepOrange),
                      ),
                      child: Text(_selectedTime.format(context)),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 20),

            // 2. CHỌN SỐ KHÁCH
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Số lượng khách:", style: TextStyle(fontSize: 16)),
                Text("$_guests người", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.deepOrange)),
              ],
            ),
            Slider(
              value: _guests.toDouble(),
              min: 1,
              max: 20,
              divisions: 19,
              activeColor: Colors.deepOrange,
              label: "$_guests người",
              onChanged: (val) => setState(() => _guests = val.toInt()),
            ),
            
            SizedBox(height: 20),

            // 3. YÊU CẦU ĐẶC BIỆT
            TextField(
              controller: _requestsController,
              decoration: InputDecoration(
                labelText: "Yêu cầu đặc biệt (Optional)",
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.note),
              ),
              maxLines: 3,
            ),
            SizedBox(height: 30),

            // 4. NÚT GỬI
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: _isLoading ? null : _submitReservation,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepOrange,
                  foregroundColor: Colors.white, // Chữ màu trắng
                ),
                child: _isLoading 
                  ? CircularProgressIndicator(color: Colors.white)
                  : Text("XÁC NHẬN ĐẶT BÀN", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              ),
            )
          ],
        ),
      ),
    );
  }
}