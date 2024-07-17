import 'package:flutter/material.dart';
import 'Core funtion/ActivityDoTest.dart';


class ActivityItemMain extends StatelessWidget {
  final String subtitle;

  ActivityItemMain({required this.subtitle});

  static const color = Color(0xff75e850);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // Navigator.push(
        //   context,
        //   MaterialPageRoute(builder: (context) => ActivityTestManager()),
        // );
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
              child: Image.asset('images/tetmass3.png', width: 100, height: 100),
            ),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Text('Tiếp tục', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30, color: Colors.white, fontFamily: 'OpenSans' )),
                  SizedBox(height: 10),
                  Text(subtitle, style: TextStyle(fontSize: 20, color: Colors.white, fontFamily: 'OpenSans')),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
