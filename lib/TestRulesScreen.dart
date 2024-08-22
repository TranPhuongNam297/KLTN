import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; // Import Firestore package
import 'Core funtion/ActivityDoTest.dart';
import 'Model/bo_de.dart';
import 'Practice/ActivityDoPractice.dart'; // Import ActivityDoPractice

class TestRulesScreen extends StatefulWidget {
  @override
  _TestRulesScreenState createState() => _TestRulesScreenState();
}

class _TestRulesScreenState extends State<TestRulesScreen> {
  bool isLoading = false;
  void startTest() async {
    setState(() {
      isLoading = true;
    });

    // Lấy boDeId từ SharedPreferences
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? boDeId = prefs.getString('boDeId');
    prefs.setString('mode', 'lambai');
    if (boDeId != null) {
      // Truy xuất dữ liệu và lấy trường Mode
      bool isPracticeMode = await _fetchModeFromBoDe(boDeId);

      setState(() {
        isLoading = false;
      });

      // Điều hướng đến màn hình phù hợp dựa trên giá trị của Mode
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => isPracticeMode ? ActivityDoPractice() : ActivityDoTest(),
        ),
      );
    } else {
      // Xử lý trường hợp không có boDeId
      setState(() {
        isLoading = false;
      });
      // Bạn có thể hiển thị một thông báo lỗi hoặc chuyển hướng đến màn hình khác
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Không tìm thấy ID bài kiểm tra.')),
      );
    }
  }

  // Phương thức để lấy Mode từ Bo_de
  Future<bool> _fetchModeFromBoDe(String boDeId) async {
    try {
      // Truy xuất dữ liệu từ Firestore
      DocumentSnapshot docSnapshot = await FirebaseFirestore.instance
          .collection('Bo_de') // Thay thế bằng tên collection của bạn
          .doc(boDeId)
          .get();

      if (docSnapshot.exists) {
        // Lấy dữ liệu từ snapshot
        Map<String, dynamic> data = docSnapshot.data() as Map<String, dynamic>;
        // Tạo đối tượng bo_de từ dữ liệu
        bo_de boDe = bo_de.fromMap(data, docSnapshot.id);
        // Trả về giá trị của trường Mode
        print((boDe.Mode).toString()+ "bo de firebase tra ve");
        return boDe.Mode;
      } else {
        // Xử lý trường hợp không tìm thấy tài liệu
        throw Exception('Không tìm thấy boDe với ID: $boDeId');
      }
    } catch (e) {
      // Xử lý lỗi
      print('Lỗi khi lấy dữ liệu: $e');
      return false; // Hoặc xử lý lỗi theo cách khác nếu cần
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.indigo,
        title: Text('Thể lệ thi', style: TextStyle(color: Colors.white)),
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: Stack(
        children: [
          Padding(
            padding: EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Image.asset(
                  'images/thongbao.jpg', // Đường dẫn tới hình ảnh đầu tiên
                  fit: BoxFit.cover,
                ),
                Image.asset(
                  'images/thele.png', // Đường dẫn tới hình ảnh thứ hai
                  fit: BoxFit.cover,
                ),
                Spacer(),
                Center(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.indigo[400],
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                        side: BorderSide(color: Colors.black, width: 2),
                      ),
                      minimumSize: Size(350, 55),
                    ),
                    onPressed: startTest,
                    child: Text(
                      'Bắt đầu',
                      style: TextStyle(color: Colors.white, fontSize: 25),
                    ),
                  ),
                ),
              ],
            ),
          ),
          if (isLoading)
            Center(
              child: AlertDialog(
                title: Text('Đang tải...'),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CircularProgressIndicator(),
                    SizedBox(height: 16),
                    Text('Vui lòng chờ trong giây lát.'),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}
