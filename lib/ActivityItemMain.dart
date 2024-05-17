import 'package:flutter/material.dart';
import 'ActivityDoTest.dart';

class ActivityItemMain extends StatelessWidget {

  final String subtitle;

  ActivityItemMain({ required this.subtitle});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => ActivityDoTest()),
        );
      },
      child: Container(
        width: 350,
        height: 150,
        color: Colors.blue[100],
        margin: EdgeInsets.only(bottom: 30, left: 20, right: 20), // Khoảng cách từ lề trái, phải và dưới
        child: Row(
          children: <Widget>[
            Padding(
              padding: EdgeInsets.all(10),
              child: Image.asset('images/tetmass3.png', width: 100, height: 100), // Logo
            ),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Text('Tiếp tục', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30)),
                  SizedBox(height: 10),
                  Text(subtitle, style: TextStyle(fontSize: 20)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}