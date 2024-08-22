import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'Core funtion/ActivityDoTest.dart';
import 'Model/bo_de.dart';
import 'Practice/ActivityDoPractice.dart';

class TestRulesScreen extends StatefulWidget {
  final String boDeId;
  final bool mode;

  TestRulesScreen({required this.boDeId, required this.mode});

  @override
  _TestRulesScreenState createState() => _TestRulesScreenState();
}

class _TestRulesScreenState extends State<TestRulesScreen> {
  bool isLoading = false;

  void startTest() async {
    setState(() {
      isLoading = true;
    });

    String boDeId = widget.boDeId;
    bool isPracticeMode = widget.mode;

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
