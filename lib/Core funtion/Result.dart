import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'AnswerDetail.dart';
import '../mainLayout.dart';

class Result extends StatelessWidget {
  final int totalQuestions;
  final int correctAnswers;
  final List<bool?> questionResults;
  final Duration timeSpent;

  String formattedDateTime = DateFormat('dd/MM/yyyy h:mm a').format(DateTime.now());

  Result({Key? key, required this.totalQuestions, required this.correctAnswers, required this.questionResults, required this.timeSpent}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String formattedDuration = "${timeSpent.inHours.toString().padLeft(2, '0')}:${(timeSpent.inMinutes % 60).toString().padLeft(2, '0')}:${(timeSpent.inSeconds % 60).toString().padLeft(2, '0')}";

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Chi tiết điểm số',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.indigo,
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
            SizedBox(height: 16),
            Text(
              'Thời gian hoàn thành:',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
            ),
            Text('$formattedDuration / 01:00:00', style: TextStyle(fontSize: 20)),
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
                  SizedBox(height: 20),
                  Text('$correctAnswers / $totalQuestions', style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold, fontFamily: 'OpenSans')),
                  SizedBox(height: 20),
                  Text(
                    correctAnswers >= 5 ? 'Chúc mừng, bạn đã làm rất tốt!' : 'Thật tiếc, hãy thử lại!',
                    style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold, fontFamily: 'OpenSans'),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
            SizedBox(height: 40),
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
                onPressed: () {
                  // Navigate to a new screen to show detailed answers
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => AnswerDetail(
                        totalQuestions: totalQuestions,
                        questionResults: questionResults,
                      ),
                    ),
                  );
                },
                child: Text(
                  'Xem chi tiết đáp án',
                  style: TextStyle(color: Colors.white, fontSize: 25),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
