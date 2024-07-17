import 'package:flutter/material.dart';
import 'TestRulesScreen.dart';

class ActivityItemMain extends StatelessWidget {
  final String title;
  final String boDeId; // Thêm trường boDeId để xác định bài kiểm tra

  ActivityItemMain({required this.title, required this.boDeId});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => TestRulesScreen()), // Truyền boDeId đến TestRulesScreen
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
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
