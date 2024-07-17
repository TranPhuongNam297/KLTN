import 'package:flutter/material.dart';
import 'Core funtion/ActivityDoTest.dart';

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

    await Future.delayed(Duration(seconds: 2)); // Simulate a delay for 2 seconds

    setState(() {
      isLoading = false;
    });

    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => ActivityDoTest()),
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
                Text(
                  'Thể lệ thi:',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 10),
                Text(
                  '1. Mỗi bài thi gồm tối đa 40 câu hỏi.\n'
                      '2. Bạn có 1 tiếng để hoàn thành bài thi.\n'
                      '3. Bài thi sẽ tự động nộp khi hết giờ.',
                  style: TextStyle(fontSize: 16),
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
