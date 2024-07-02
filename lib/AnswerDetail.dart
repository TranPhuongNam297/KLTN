import 'package:flutter/material.dart';

class AnswerDetail extends StatelessWidget {
  final int totalQuestions;
  final List<bool?> questionResults;

  AnswerDetail({required this.totalQuestions, required this.questionResults});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Chi tiết đáp án',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.indigo,
      ),
      body: ListView.builder(
        itemCount: totalQuestions,
        itemBuilder: (context, index) {
          final questionNumber = index + 1;
          final isCorrect = questionResults[index] ?? false;

          return ListTile(
            title: Text('Câu hỏi $questionNumber:'),
            trailing: Icon(
              isCorrect ? Icons.check_circle : Icons.cancel,
              color: isCorrect ? Colors.green : Colors.red,
            ),
            subtitle: Text(
              isCorrect ? 'Đúng' : 'Sai',
              style: TextStyle(color: isCorrect ? Colors.green : Colors.red),
            ),
          );
        },
      ),
    );
  }
}
