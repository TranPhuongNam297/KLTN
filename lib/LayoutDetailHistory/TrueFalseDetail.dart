import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class TrueFalseDetail extends StatelessWidget {
  final String id;

  TrueFalseDetail({required this.id});

  Future<Map<String, dynamic>> _fetchQuestion(String id) async {
    DocumentSnapshot doc = await FirebaseFirestore.instance
        .collection('list_truefalse')
        .doc(id)
        .get();
    return doc.data() as Map<String, dynamic>;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(''),
      ),
      body: FutureBuilder<Map<String, dynamic>>(
        future: _fetchQuestion(id),
        builder: (context, snapshot) {
          print(id+"sau  luc bam");
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data == null) {
            return Center(child: Text('No data found.'));
          }

          var questionData = snapshot.data!;
          var question = questionData['Question'];
          var correctAnswer = questionData['CorrectAnswer'];

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Nội dung câu hỏi và đáp án đúng cho True/False',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 20),
                Expanded(
                  child: ListView(
                    children: [
                      _buildQuestionCard(question, correctAnswer),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildQuestionCard(String question, bool correctAnswer) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 10),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              question,
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 10),
            Text(
              'Đáp án đúng: ${correctAnswer ? 'Đúng' : 'Sai'}',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}