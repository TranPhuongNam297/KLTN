import 'package:flutter/material.dart';
import 'Core funtion/ActivityDoTest.dart';

class TestRulesScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Thể lệ thi'),
      ),
      body: Padding(
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
              '1. Mỗi bài thi gồm tối đa 10 câu hỏi.\n'
                  '2. Bạn có 30 phút để hoàn thành bài thi.\n'
                  '3. Bài thi sẽ tự động nộp khi hết giờ.',
              style: TextStyle(fontSize: 16),
            ),
            Spacer(),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => ActivityDoTest()),
                  );
                },
                child: Text('Bắt đầu thi'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
