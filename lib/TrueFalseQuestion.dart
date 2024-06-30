import 'package:flutter/material.dart';
import 'QuestionManager.dart';

class TrueFalseQuestion extends StatefulWidget {
  final QuestionManager questionManager;
  final void Function(bool) onAnswerSelected;

  TrueFalseQuestion({
    required this.questionManager,
    required this.onAnswerSelected,
  });

  @override
  _TrueFalseQuestionState createState() => _TrueFalseQuestionState();
}

class _TrueFalseQuestionState extends State<TrueFalseQuestion> {
  List<bool?> _selectedAnswers = [];

  @override
  void initState() {
    super.initState();
    _initializeSelectedAnswers();
  }

  void _initializeSelectedAnswers() {
    final subQuestions = widget.questionManager.questions[widget.questionManager.currentQuestionIndex]['subQuestions1'];
    _selectedAnswers = List<bool?>.filled(subQuestions.length, null);
  }

  @override
  Widget build(BuildContext context) {
    final subQuestions = widget.questionManager.questions[widget.questionManager.currentQuestionIndex]['subQuestions1'];

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: 50,
            child: Text(
              'Câu hỏi đúng sai',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 35),
              textAlign: TextAlign.center,
            ),
          ),
          SizedBox(height: 15),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text('Đúng / Sai', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            ],
          ),
          for (int i = 0; i < subQuestions.length; i++)
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(subQuestions[i]['question'], style: TextStyle(fontSize: 18)),
                Row(
                  children: [
                    Radio<bool?>(
                      value: true,
                      groupValue: _selectedAnswers[i],
                      onChanged: (value) {
                        setState(() {
                          _selectedAnswers[i] = value;
                        });
                        widget.onAnswerSelected(_selectedAnswers.every((answer) => answer != null && answer == subQuestions[_selectedAnswers.indexOf(answer)]['correctAnswer']));
                      },
                    ),
                    Radio<bool?>(
                      value: false,
                      groupValue: _selectedAnswers[i],
                      onChanged: (value) {
                        setState(() {
                          _selectedAnswers[i] = value;
                        });
                        widget.onAnswerSelected(_selectedAnswers.every((answer) => answer != null && answer == subQuestions[_selectedAnswers.indexOf(answer)]['correctAnswer']));
                      },
                    ),
                  ],
                ),
              ],
            ),
        ],
      ),
    );
  }
}
