import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:khoa_luan_tot_nghiep/Practice/ActivityDoPractice.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../mainLayout.dart';

class ResultPractice extends StatelessWidget {
  final int totalQuestions;
  final int correctAnswers;
  final List<bool?> questionResults;
  final Duration timeSpent;
  String formattedDateTime = DateFormat('dd/MM/yyyy h:mm a').format(DateTime.now());
  ResultPractice({Key? key, required this.totalQuestions, required this.correctAnswers, required this.questionResults, required this.timeSpent}) : super(key: key);

  Future<void> _resetTestStatus(BuildContext context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? idBoDe = prefs.getString('boDeId');
    print(idBoDe);
    if (idBoDe != null) {
      try {
        await FirebaseFirestore.instance
            .collection('Bo_de')
            .doc(idBoDe)
            .update({'Tinh_trang': false});
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) => ActivityDoPractice(),
          ),
        );
      } catch (e) {
        // Handle error
        print('Error updating test status: $e');
      }
    } else {
      // Handle the case where boDeID is null
      print('No boDeID found in SharedPreferences');
    }
  }

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
              'Thời gian hoàn thành:',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
            ),
            Text('$formattedDuration / 01:00:00', style: TextStyle(fontSize: 20)),
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
            SizedBox(height: 100),
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
                  Text(
                    'Chúc mừng bạn đã hoàn thành',
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
                  _resetTestStatus(context);
                },
                child: Text(
                  'Làm lại',
                  style: TextStyle(color: Colors.white, fontSize: 25),
                ),
              ),
            ),
            SizedBox(height: 40,),
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
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(
                      builder: (context) => mainLayout(),
                    ),
                  );
                },
                child: Text(
                  'Quay về trang chủ',
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
