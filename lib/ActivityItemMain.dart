import 'package:flutter/material.dart';
import 'TestRulesScreen.dart';

class ActivityItemMain extends StatelessWidget {
  final String title;
  final String boDeId;
  final bool mode; // Thêm trường mode để xác định chế độ của bộ đề

  ActivityItemMain({required this.title, required this.boDeId, required this.mode});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => TestRulesScreen()),
        );
      },
      child: Container(
        width: 350,
        height: 150,
        decoration: BoxDecoration(
          color: Colors.indigo[400],
          borderRadius: BorderRadius.circular(10),
        ),
        margin: EdgeInsets.only(bottom: 30, left: 20, right: 20),
        child: Row(
          children: <Widget>[
            Padding(
              padding: EdgeInsets.all(10),
              child: Image.asset(
                'images/tetmass3.png',
                width: 100,
                height: 100,
                fit: BoxFit.cover,
              ),
            ),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    title,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 30,
                      color: Colors.white,
                      fontFamily: 'OpenSans',
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    mode ? 'Chế độ: Luyện tập' : 'Chế độ: Kiểm tra', // Hiển thị chế độ dựa trên giá trị của mode
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
