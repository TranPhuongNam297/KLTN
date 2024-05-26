import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'mainLayout.dart';

class Result extends StatelessWidget {

  final int totalQuestions;
  final int correctAnswers;
  final int subtitle;


  String formattedDateTime = DateFormat('dd/MM/yyyy h:mm a').format(DateTime.now());

  Result({Key? key, required this.totalQuestions, required this.correctAnswers, required this.subtitle}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Chi tiết điểm số',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.indigo, // Set toolbar color to indigo
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => mainLayout()));
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Tên đề thi:',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
            ),
            Text('$subtitle', style: TextStyle(fontSize: 20)),
            SizedBox(height: 16),
            Text(
              'Thời gian hoàn thành:',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
            ),
            Text('00:50:15 / 01:00:00', style: TextStyle(fontSize: 20)),
            SizedBox(height: 16),
            Text(
              'Chức độ:',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
            ),
            Text('Spark level 2', style: TextStyle(fontSize: 20)),
            SizedBox(height: 16),
            Text(
              'Điểm:',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
            ),
            Text('$correctAnswers / $totalQuestions', style: TextStyle(fontSize: 20)),
            SizedBox(height: 16),
            Text(
              'Chế độ:',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
            ),
            Text('Luyện tập', style: TextStyle(fontSize: 20)),
            SizedBox(height: 16),
            Text(
              'Ngày hoàn thành:',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
            ),
            Text(
              formattedDateTime,
              style: TextStyle(fontSize: 20),
            ),
            SizedBox(height: 32),
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    'Đã hoàn thành',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30, fontFamily: 'OpenSans'),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 20,),
                  Text('$correctAnswers / $totalQuestions', style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold, fontFamily: 'OpenSans')),
                  SizedBox(height: 20),
                  Text(
                    correctAnswers >= 2 ? 'Chúc mừng, bạn đã làm rất tốt!' : 'Thật tiếc, hãy thử lại!',
                    style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold, fontFamily: 'OpenSans'),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
            SizedBox(height: 40),
            Center(
              child: Container(
                width: 350,
                height: 55,
                decoration: BoxDecoration(
                  color: Colors.indigo[400],
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: Colors.black, width: 2),
                ),
                child: Center(
                  child: Text(
                    'Xem chi tiết đáp án',
                    style: TextStyle(color: Colors.white, fontSize: 25),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
